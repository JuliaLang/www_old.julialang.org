---
layout: post
title:  "New array abstractions for julia-0.5"
author: <a href="http://holylab.wustl.edu">Tim Holy</a>
---

# Introduction

Arrays with arbitrary indices are coming as an experimental feature to
julia-0.5. Conventionally, Julia's arrays are indexed starting at 1,
whereas some other languages start numbering at 0, and yet others
(e.g., Fortran) allow you to specify arbitrary starting indices. While
there is much merit in picking a standard (i.e., 1 for Julia), there
are some algorithms which simplify considerably if you can index
outside the range `1:size(A,d)` (and not just `0:size(A,d)-1`,
either).

If you have cases where you think such indexing might help you,
starting with julia-0.5 you have reasonable prospects for making this
work. While the "unconventional" array types will be provided via
packages, the core language has been substantially (though surely
incompletely) generalized to ensure that algorithms work as expected
with such arrays.

The purpose of the blog post is to address the question, "what do I
have to do to support such arrays in my own code?"  First, let's
address the simplest case: if you know that your code will never need
to handle arrays with unconventional indexing, hopefully the answer is
"nothing." Old code, on conventional arrays, should function
essentially without alteration as long as it was using the exported
interfaces of Julia.  So if you're uninterested in unconventional
indexing, you can stop reading now.

From now on I'll assume that readers fall into one of two audiences:
(1) users/package maintainers who want their code to work properly
even when users pass in arrays with unconventional indexing, and (2)
people who want to write novel array types that implement
unconventional indexing.

# Writing generic code that supports "offset" arrays

## Avoiding segfaults

Let's get the worst out of the way immediately: because unconventional
indexing breaks deeply-held assumptions throughout the Julia
ecosystem, early-adopters running code that has not been updated are
likely to experience errors.  The most frustrating bugs are expected
to be segfaults (total crashes of Julia) due to code that uses
`@inbounds`:

```jl
function mycopy!(dest::AbstractVector, src::AbstractVector)
    length(dest) == length(src) || throw(DimensionMismatch("vectors must match"))
    # OK, now we're safe to use @inbounds, right? (not anymore!)
    for i = 1:length(src)
        @inbounds dest[i] = src[i]
    end
    dest
end
```

This code implicitly assumes that vectors are indexed from 1.
Previously that was a safe assumption, so this code was fine, but
(depending on what types the user passes to this function) it may no
longer be safe. In some cases, this code will run but produce an
incorrect answer; in others, you might get a segfault.

If you get segfaults, the first thing to do is to re-run the same
tests using `julia --check-bounds=yes`; that will ignore the
`@inbounds` request, and from the backtrace you should be able to
figure out where the error is coming from.

## Using "indices" for bounds-checks and loop iteration

It's quite easy to generalize `mycopy!` above and make it safe:

```jl
function mycopy!(dest::AbstractVector, src::AbstractVector)
    indices(dest) == indices(src) || throw(DimensionMismatch("vectors must match"))
    for i in indices(src, 1)
        @inbounds dest[i] = src[i]
    end
    dest
end
```

`indices(A)` is one generalization of `size`, returning a tuple like
`(1:m, 1:n)` for a (conventional) `Matrix` of size `(m, n)`.  When `A`
has unconventional indexing, the ranges may not start at 1.  If you
just want the range for a particular dimension `d`, there is
`indices(A, d)`.

For bounds-checking, there are also dedicated functions `checkbounds`
and `checkindex` which can simplify such tests.

## Using "shape" in place of "size"

`indices(A, d)` is a good replacement for `1:size(A, d)`, but what
about `size` on its own?  In many cases, the best choice here is
typically `shape`.  For an array with conventional indexing,
`shape(A)` returns a `Dims`-tuple, i.e., a tuple of `Int`, exactly the
same as `size`.  However, if `A` has unconventional indexing, `shape`
returns a tuple of `UnitRange{Int}` just like `indices`. In other
words, `shape` gives you "conventional" size information when it's
appropriate, and "explicit" shape information when it's required.
Like `size` and `indices`, `shape` can optionally be called with a
dimension-argument, `shape(A, d)`.

A good use case for `shape` is when you're allocating an array using
`similar`.  If you called `similar(A, (indices(A, 2),))`, the function
that handles this call would have to be prepared for the possiblity
that you're asking for an output that has unconventional indexing;
without further information, this might introduce type-instability,
because the return type might depend on whether `first(ind) == 1`.
By instead calling `similar(A, (shape(A, 2),))`, the shape information
itself conveys whether you want conventional or arbitrary indexing.

This can be handy in other situations.  For example, `sub2ind` is
measurably faster if you can make the assumption that indexing starts
at 1; consequently, Julia has two implementations of `sub2ind`, one
taking a `Dims` tuple and another taking a tuple of `UnitRange`s.  You
can use any of `sub2ind(A, inds...)`, `sub2ind(shape(A), inds...)`, or
`sub2ind(indices(A), inds...)`; when `A` has conventional indexing,
the first two will be faster than the third.

## Allocating specific storage: "allocate_for"

`similar(A, args...)` places all the control for allocation in the
hands of `A`; in some cases, you want more control over the allocated
type.  Currently, one usually allocates such arrays directly, using,
e.g., `Array{Int}(dims)` or `BitArray(dims)`.  However, if you need
this storage to match the indices of some input, these will fail for
inputs with unconventional indices.

The generic replacement for such patterns is a new function,
`allocate_for(storagetype, referencearray, [shape])`.  `storagetype`
indicates the kind of underlying "conventional" behavior you'd like,
e.g., `Array{Int}` or `BitArray`. `referencearray` is the array which
might have unconventional indexing, i.e., what you'd like to match
(both in type and indices). Optionally you can supply particular
`shape` inforation as the third argument.

Let's walk through a couple of explicit examples. First, if `A` has
conventional indices, `allocate_for(Array{Int}, A)` would end up
calling `Array{Int}(size(A))`, and thus return an array.  If `A` is an
`AbstractArray` type with unconventional indexing, then
`allocate_for(Array{Int}, A)` should return something that "behaves
like" an `Array{Int}` but with a shape (including indices) that
matches `A`.  (The most obvious implementation is to allocate an
`Array{Int}(size(A))` and then "wrap" it in a type matching `A` that
shifts the indices.  However, this behavior is not guaranteed.)

Finally, `allocate_for(Array{Int}, A, (shape(A, 2),))` would allocate
an `AbstractVector{Int}` (i.e., 1-dimensional array) that matches the
indices of the columns of `A`.

## Linear indexing ("linearindices")

Some algorithms are most conveniently (or efficiently) written in
terms of a single linear index, `A[i]` even if `A` is
multi-dimensional.  In "true" linear indexing, the indices always
range from `1:length(A)`. However, this raises an ambiguity for
one-dimensional arrays: does `v[i]` mean linear indexing, or Cartesian
indexing with the array's native indices?

For this reason, if you want to use linear indexing in an algorithm,
your best option is to get the index range by calling
`linearindices(A)`.  This will return `indices(A, 1)` if `A` is an
`AbstractVector`, and `1:length(A)` otherwise.

In a sense, one can say that 1-dimensional arrays always use Cartesian
indexing. To help enforce this, it's worth noting that `sub2ind(shape,
i...)` and `ind2sub(shape, ind)` will throw an error if `shape`
indicates a 1-dimensional array with unconventional indexing (i.e., is
a `Tuple{UnitRange}`).  For arrays with conventional indexing (for
which `shape` returns a `Dims`-tuple), these functions continue to
work the same as always.

## Checking for conventional indexing

The most direct way to check whether an array has conventional
indexing is to use a traits-function, `Base.indicesbehavior(A)`. The
default return value is `Base.IndicesStartAt1()`, which indicates that
the array uses conventional indexing.  The main alternative is
`Base.IndicesUnitRange()`.  When necessary, you can write code that
dispatches on these values:

```jl
indexingstyle(A) = indexingstyle(Base.indicesbehavior(A), A)
indexingstyle(::Base.IndicesStartAt1, A) = "conventional"
indexingstyle(::Base.IndicesUnitRange, A) = "unit-range"
```

For an array whose type is inferrable to Julia's compiler, these
functions should inline to a constant, so there should be literally no
overhead for this flexibility.

## Deprecations

In generalizing Julia's code base, at least one deprecation was
unavoidable: earlier versions of Julia defined `first(::Colon) = 1`,
meaning that the first index along a dimension indexed by `:` is 1.
This definition can no longer be justified, so it was deprecated.

# Creating new "offset" array types

If you're creating a new `AbstractArray` type and want it to support
unconventional indices, there are a few other things you need to know.
A good model to follow is `test/offsetarray.jl` in Julia's source
directory.

Most of the methods you'll need to define are
[standard](http://docs.julialang.org/en/latest/manual/interfaces/#abstract-arrays)
for any `AbstractArray` type.  In addition, for unconventional
indexing you'll need to define `Base.indicesbehavior`, `allocate_for`,
and (if you want to support broadcasting) `Base.promote_indices`. The
latter function is a helper method for `allocate_for`, allowing one to
pass a tuple-of-arrays as the `referencearray`.  You use
`promote_indices` to choose among the list of `referencearrays`, to
finally select a single one to represent the "template" type.  For
example, `test/offsetarray.jl` contains the definition

```jl
Base.promote_indices(a::OffsetArray, b::OffsetArray) = a
```

which ends up meaning that any list of `OffsetArray`s will result in a
call with `referencearray` of type `OffsetArray`.  The absence of any
other definitions implies that mixutures of conventional and
`OffsetArray`s, or mixing two different types of arrays supporting
unconventional indexing, will lead to an error.  Consequently, this is
a mechanism for enforcing type consistency among potentially
multiple packages that support unconventional indexing.

# Summary

Writing code that doesn't make assumptions about indexing requires a
few extra abstractions, but hopefully the necessary changes are
relatively straightforward.

As a reminder, this support is still experimental. While much of
julia's base code has been updated to support unconventional indexing,
there have surely been omissions that will be discovered only through
usage.  Moreover, at the time of this writing, most packages do not
support unconventional indexing.  As a consequence, early adopters
should be prepared to identify and/or fix bugs.
