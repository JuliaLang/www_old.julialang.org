---
layout: post
title:  "Now we know where we've been: custom array indices in Julia"
author: <a href="http://holylab.wustl.edu">Tim Holy</a>
---

# Introduction: Arrays and indices

Arrays are a crucial component of any programming language,
particularly for a data-oriented language like Julia.  Arrays store
values according to their location: in Julia, given a two-dimensional
array `A`, the expression `A[1,3]` returns the value stored at a
location known as `(1,3)`.  If, for example, `A` stores `Float64`
numbers, the value returned by this expression will be a single
`Float64` number.

Julia's arrays conventionally start numbering their axes with 1,
meaning that the first element of a one-dimensional array `a` is
`a[1]`. The choice of 1 vs. 0 seems to generate a certain amount of
discussion. A fairly recent addition to the Julia landscape is the
ability to define arrays that start with an *arbitrary* index.  The
purpose of this blog post is to describe why this might be
interesting.  This is really a "user-oriented" blog post, hinting at
some of the ways this new feature can make your life simpler.  For
developers who want to write code that supports arrays with arbitrary
indices, see
[this documentation page](http://docs.julialang.org/en/latest/devdocs/offset-arrays.html#Arrays-with-custom-indices-1).

## We know where we're going...

Sometimes it's convenient to refer to a whole block of an array.  In
Julia, if we define an array

```julia
julia> A = collect(reshape(1:30, 5, 6))
5×6 Array{Int64,2}:
 1   6  11  16  21  26
 2   7  12  17  22  27
 3   8  13  18  23  28
 4   9  14  19  24  29
 5  10  15  20  25  30
```

then we can refer to a rectangular region like this:

```julia
julia> B = A[1:3, 1:4]
3×4 Array{Int64,2}:
 1  6  11  16
 2  7  12  17
 3  8  13  18
```

We can represent the same concept graphically using images:

```julia
using TestImages, Images

img = testimage("mandrill")
imgeye = img[35:99,130:220]
imgnose = img[331:445,145:350]
```

If we display these three images, we get the following:

![mandrill](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/offsetarrays_figures/mandrill.png?raw=true)
![mandrill](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/offsetarrays_figures/mandrill_eye.png?raw=true)
![mandrill](https://github.com/JuliaLang/julialang.github.com/blob/master/blog/_posts/offsetarrays_figures/mandrill_nose.png?raw=true)

In summary, it's very straightforward to pick a particular region of
an array and extract it for further analysis.  Like the Talking Heads
song "Road to Nowhere," we know where we're going...

## ...but we don't know where we've been...

For certain applications, one negative to extracting blocks is that
there is no record indicating where the new block originated from:

```julia
julia> B2 = A[2:4, 1:4]
3×4 Array{Int64,2}:
 2  7  12  17
 3  8  13  18
 4  9  14  19

julia> B2[1,1]
2
```

So `B2[1,1]` corresponds to `A[2,1]`, despite the fact that, as
measured by their indices, these are not the same location. Likewise,
when snipping out regions of an image, we don't know where, relative
to the original images, those pieces came from.  Often we may not
care, but in other cases it's essential to pass forward both the
snipped-out data *and* the indices used for the snipping. In complex
cases--when you have indices of indices of indices--keeping track of
location can make your head hurt.

## ...give us time to work it out

Starting with Julia 0.5, there is experimental support for a simple
solution to such problems. In programming, one of the best ways to
keep track of correspondences is to make sure that everything
maintains consistent "naming," which in this case means having
consistent indices.  We can do this using the [OffsetArrays](https://github.com/alsam/OffsetArrays.jl)
package:

```julia
julia> using OffsetArrays

julia> B3 = OffsetArray(A[2:4, 1:4], 2:4, 1:4)  # wrap the snipped-out piece in an OffsetArray
OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}} with indices 2:4×1:4:
 2  7  12  17
 3  8  13  18
 4  9  14  19

julia> B3[3,4]
18

julia> A[3,4]
18
```

So the indices in `B3` match those of `A`. Indeed, `B3` doesn't even
have an element "named" `(1,1)`:

```julia
julia> B3[1,1]
ERROR: BoundsError: attempt to access OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}} with indices 2:4×1:4 at index [1,1]
 in throw_boundserror(::OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}}, ::Tuple{Int64,Int64}) at ./abstractarray.jl:363
 in checkbounds at ./abstractarray.jl:292 [inlined]
 in getindex(::OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}}, ::Int64, ::Int64) at /home/tim/.julia/v0.5/OffsetArrays/src/OffsetArrays.jl:82
 ```

In this case we created `B3` by explicitly "wrapping" the extracted
array inside a type that allows you to supply custom indices.  (You
can retrieve just the extracted portion with `parent(B3)`.)  We could
do the same thing by adjusting the *indices* instead:

```julia
julia> ind1, ind2 = OffsetArray(2:4, 2:4), OffsetArray(1:4, 1:4)
([2,3,4],[1,2,3,4])

julia> B4 = A[ind1, ind2]
OffsetArrays.OffsetArray{Int64,2,Array{Int64,2}} with indices 2:4×1:4:
 2  7  12  17
 3  8  13  18
 4  9  14  19

julia> B4[3,4]
18
```

This implements a simple rule of composition:

**If `C = A[ind1, ind2]`, then `C[i, j] == A[ind1[i], ind2[j]]`**

Consequently, if your indices have their own unconventional indices,
they will be propagated forward to the next stage.

This technique can also be used to create a "view":

```julia
julia> V = view(A, ind1, ind2)
SubArray{Int64,2,Array{Int64,2},Tuple{OffsetArrays.OffsetArray{Int64,1,UnitRange{Int64}},OffsetArrays.OffsetArray{Int64,1,UnitRange{Int64}}},false} with indices 2:4×1:4:
 2  7  12  17
 3  8  13  18
 4  9  14  19

julia> V[3,4]
18

julia> V[1,1]
ERROR: BoundsError: attempt to access SubArray{Int64,2,Array{Int64,2},Tuple{OffsetArrays.OffsetArray{Int64,1,UnitRange{Int64}},OffsetArrays.OffsetArray{Int64,1,UnitRange{Int64}}},false} with indices 2:4×1:4 at index [1,1]
...
```

Note that this object is a *conventional* `SubArray` (it's not an
`OffsetArray`), but because it was passed `OffsetArray` indices it
preserves the indices of the indices.

# A first application: array/image filtering

A recent release (v0.6.0) of the Images package put both the power
and responsibility for dealing with arrays with custom indices into the
hands of users.  One of the key functions in this package is
`imfilter` which can be used to smooth or otherwise "filter" arrays. The
idea is that starting from an array `A`, each local neighborhood is
weighted by a "kernel" `kern`, producing an output value according to
the following formula:

```math
F[I] = \sum_J A[I+J] kern[J]
```

This is the formula for
[correlation](https://en.wikipedia.org/wiki/Cross-correlation); the
formula for another operation,
[convolution](https://en.wikipedia.org/wiki/Convolution), is very
similar.

Let's start with a trivial example: let's filter the array `1:8` with
a "delta function" kernel, meaning it has value `1` at
location 0. According to the correlation formula, because `kern[J]` is
1 at `J==0`, this should simply give us back our original array:

```julia
julia> using Images

julia> imfilter(1:8, [1])
WARNING: assuming that the origin is at the center of the kernel; to avoid this warning, call `centered(kernel)` or use an OffsetArray
 in depwarn(::String, ::Symbol) at ./deprecated.jl:64
 in _kernelshift at /home/tim/.julia/v0.5/ImageFiltering/src/imfilter.jl:1029 [inlined]
 in kernelshift at /home/tim/.julia/v0.5/ImageFiltering/src/imfilter.jl:1026 [inlined]
 in factorkernel at /home/tim/.julia/v0.5/ImageFiltering/src/imfilter.jl:996 [inlined]
 in imfilter at /home/tim/.julia/v0.5/ImageFiltering/src/imfilter.jl:10 [inlined]
 in imfilter(::UnitRange{Int64}, ::Array{Int64,1}) at /home/tim/.julia/v0.5/ImageFiltering/src/imfilter.jl:5
 in eval(::Module, ::Any) at ./boot.jl:234
 in eval_user_input(::Any, ::Base.REPL.REPLBackend) at ./REPL.jl:64
 in macro expansion at ./REPL.jl:95 [inlined]
 in (::Base.REPL.##3#4{Base.REPL.REPLBackend})() at ./event.jl:68
while loading no file, in expression starting on line 0
8-element Array{Int64,1}:
 1
 2
 3
 4
 5
 6
 7
 8
```

The warning is telling you that Images decided to make a guess about
your intention, that the kernel is centered around zero. You can
suppress the warning by explicitly passing the following kernel
instead:

```julia
julia> kern = centered([1])
OffsetArrays.OffsetArray{Int64,1,Array{Int64,1}} with indices 0:0:
 1

julia> kern[0]
1

julia> kern[1]
ERROR: BoundsError: attempt to access OffsetArrays.OffsetArray{Int64,1,Array{Int64,1}} with indices 0:0 at index [1]
...
```

which clearly specifies your intended indices for `kern`.

This can be used to shift an image in the following way (by default, `imfilter` returns its results over the same domain as the input):
```julia
julia> kern2 = OffsetArray([1], 2:2)  # a delta function centered at 2
OffsetArrays.OffsetArray{Int64,1,Array{Int64,1}} with indices 2:2:
 1

julia> imfilter(1:8, kern2, Fill(0))  # pad the edges of the input with 0
8-element Array{Int64,1}:
 3
 4
 5
 6
 7
 8
 0
 0

julia> kern3 = OffsetArray([1], -5:-5)   # a delta function centered at -5
OffsetArrays.OffsetArray{Int64,1,Array{Int64,1}} with indices -5:-5:
 1

julia> imfilter(1:8, kern3, Fill(0))
8-element Array{Int64,1}:
 0
 0
 0
 0
 0
 1
 2
 3
```

These are all illustrated in the following figure:

![deltafunctions]()

In other programming languages, when filtering with a kernel that has
an even number of elements, it can be difficult to remember the
convention for which of the two middle elements corresponds to an
index of 0.  In Julia, that's not an issue:

```julia
julia> kern = OffsetArray([0.5,0.5], 0:1)
OffsetArrays.OffsetArray{Float64,1,Array{Float64,1}} with indices 0:1:
 0.5
 0.5

julia> imfilter(1:8, kern, Fill(0))
8-element Array{Float64,1}:
 1.5
 2.5
 3.5
 4.5
 5.5
 6.5
 7.5
 4.0

julia> kern = OffsetArray([0.5,0.5], -1:0)
OffsetArrays.OffsetArray{Float64,1,Array{Float64,1}} with indices -1:0:
 0.5
 0.5

julia> imfilter(1:8, kern, Fill(0))
8-element Array{Float64,1}:
 0.5
 1.5
 2.5
 3.5
 4.5
 5.5
 6.5
 7.5
```

Likewise, sometimes we might have an application where we simply can't
handle the edges properly, and we wish to discard them.  For example,
consider the following quadratic function:

```julia
julia> a = [(i-3)^2 for i = 1:9]  # a quadratic function
9-element Array{Int64,1}:
  4
  1
  0
  1
  4
  9
 16
 25
 36

julia> imfilter(a, Kernel.Laplacian((true,)))
9-element Array{Int64,1}:
  -3
   2
   2
   2
   2
   2
   2
   2
 -11
```

Those weird values on the edges (for which there is no padding that
will "extrapolate" the quadratic) might cause problems. Consequently,
let's only extract the values that are well-defined, meaning that all
inputs to the correlation formula have explicitly-assigned values:

```julia
julia> imfilter(a, Kernel.Laplacian((true,)), Inner())
OffsetArrays.OffsetArray{Int64,1,Array{Int64,1}} with indices 2:8:
 2
 2
 2
 2
 2
 2
 2
```

Notice that in this case, it returned an `OffsetArray` so that the
values in the result align properly with the original array.

# Another application: Fourier transforms

There are many more things you can do with custom indices.  As one
further illustration, consider the
[Discrete Fourier Transform](https://en.wikipedia.org/wiki/Discrete_Fourier_transform),
which is defined on a periodic domain.  Typically, it's rather
difficult to emulate a periodic domain with arrays, because arrays
have finite size.  However, it's possible to define indexing objects
which possess periodic behavior.  Here we use the
[FFTViews](https://github.com/JuliaArrays/FFTViews.jl) package,
demonstrating the technique on a simple sinusoid:

```
julia> using FFTViews

julia> a = [sin(2π*x) for x in linspace(0,1,16)];

julia> afft = FFTView(fft(a))
FFTViews.FFTView{Complex{Float64},1,Array{Complex{Float64},1}} with indices FFTViews.URange(0,15):
 5.55112e-16+0.0im
       1.498-7.53098im
   -0.288537+0.69659im
   -0.236488+0.35393im
   -0.222614+0.222614im
   -0.216932+0.14495im
   -0.214217+0.0887316im
   -0.212937+0.0423558im
   -0.212557+0.0im
   -0.212937-0.0423558im
   -0.214217-0.0887316im
   -0.216932-0.14495im
   -0.222614-0.222614im
   -0.236488-0.35393im
   -0.288537-0.69659im
       1.498+7.53098im
```

Now, as every student of Fourier transforms learns, the mean value is associated with the 0-frequency bin:

```julia
julia> afft[0]
5.551115123125783e-16 + 0.0im
```

Since the mean of a sinusoid is zero, this is (within roundoff error) zero.

We can also check the amplitude at the Fourier-peak, and explore the
periodicity of the result:

```julia
julia> afft[1]
1.4980046017247872 - 7.53097769363728im

julia> afft[-1]      # negative frequencies are OK
1.4980046017247872 + 7.53097769363728im

julia> afft[64+1]    # look Ma, it's periodic!
1.4980046017247872 - 7.53097769363728im

julia> length(indices(afft,1))   # but we still know how big it is
16
```

While very simple, these techniques make it surprisingly more pleasant
to deal with what would otherwise be fairly complex index gymnastics.

# Summary: a user's perspective

This has only scratched the surface of what's possible with custom
indices.  In the opinion of the author, their main advantage is that
they can increase the clarity of code by ensuring that "names"
(indices) can be endowed with *absolute meaning*, rather than always
being "referenced to whatever data this particular array happens to
encode."  We can know where we have been, where we are now, and where
we will be in the future.

There is quite a lot of code that hasn't yet properly accounted for
the possibility of custom indices---surely, some of it written by the
author! So users should be prepared for the possibility that exploiting
custom indices will trigger errors in base Julia or in packages.
Rather than giving up, users are encouraged to report such errors as
issues, as this is the only way that custom indices will, over the
course of time, have solid support.

# Summary: a developer's perspective

For some algorithms, there appears to be little reason to ever use
arrays with anything but 1-based indices; in such cases, there may be
no reason to modify existing code.  But if your code has a "spatial"
interpretation--where location has meaning--then you just might want
to give the new facilities a try.

In transitioning existing code, the author of this post has observed
the following tendencies:

- algorithms that exploit custom indices are sometimes simpler to
  understand than their "1-locked" counterparts;

- if you're porting old code to support custom indices, there's some
  bad news: if you had to think carefully about the indexing the first
  time you wrote it, it usually requires significant investment to
  re-think the indexing, even if the end result is somewhat simpler.

- writing algorithms that are "indices aware" from the beginning seems
  to be scarcely harder than writing algorithms that implicitly
  assume indexing starts at 1.

Developers are referred to
[Julia's documentation](http://docs.julialang.org/en/latest/devdocs/offset-arrays.html#Arrays-with-custom-indices-1)
for further guidance.
