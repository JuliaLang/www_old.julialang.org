---
layout: post
title:  More Dots: Syntactic Loop Fusion in Julia
author: <a href="http://math.mit.edu/~stevenj">Steven G. Johnson</a>
---

After a [lengthy design process](https://github.com/JuliaLang/julia/issues/8450), Julia 0.6 includes new facilities for writing code in the "vectorized"
style (familiar from Matlab, Numpy, R, etcetera) while avoiding the
overhead that this style of programming usually imposes: multiple
vectorized operations can now be "fused" into a single loop, without
allocating any extraneous temporary arrays.

This is best illustrated with an example.  Suppose we have
a function `f(x) = 3x^2 + 5x + 2` that evaluates a polynomial,
and we want to evaluate `f(2x^2 + 6x^3 - sqrt(x))` for a whole array `X`,
storing the result in-place in `X`.  You can now do:

```jl
X .= f.(2 .* X.^2 .+ 6 .* X.^3 .- sqrt.(X))
```

and the whole computation will be *fused* into a single loop, operating in-place,
and performance will be comparable to the hand-written
"devectorized" loop:

```jl
for i in eachindex(X)
    x = X[i]
    X[i] = f(2x^2 + 6x^3 - sqrt(x))
end
```

(Of course, like all Julia code, to get good performance both of these snippets should be executed inside some function, not in global scope.)

In this blog post, we delve into some of the details of this new development, in order to answer questions that often arise when this feature is presented:

* What is the overhead of traditional "vectorized" code?  Isn't vectorized code supposed to be fast already?

* Why are all these dots necessary?  Couldn't Julia just optimize "ordinary" vector code?

* Is this something unique to Julia, or can other languages do the same thing?

The short answers are:

* Ordinary vectorized code is fast, but not as fast as a hand-written loop
  (assuming loops are efficiently compiled)
  because each vectorized operation generates a new temporary array and
  executes a separate loop, leading to a lot of overhead when multiple
  vectorized operations are combined.

* The dots allow Julia to recognize the "vectorized" nature of the
  operations at a *syntactic* level (before e.g. the type of `x` is known),
  and hence the loop fusion is a *syntactic guarantee*, not a
  compiler optimization that may or may not occur for carefully written code.

* Other languages have implemented loop fusion for vectorized operations,
  but typically for only a small set of types and operations/functions that
  are known to the compiler.  Julia's ability to do it generically, even
  for *user-defined* array types and functions/operators, is unusual
  and relies in part on the syntax choices above and on its ability to efficiently
  compile higher-order functions.

## Isn't vectorized code already fast?

Let's rewrite the code above in a more traditional vectorized style, without
so many dots, that you might use in Julia 0.4 or in other languages
(most famously Matlab, Python/Numpy, or R).   

```jl
X = f(2 * X.^2 + 6 * X.^3 - sqrt(X))
```

Of course, this assumes that the functions `sqrt` and `f` are "vectorized,"
i.e. that they take vector arguments `X` and compute the
function elementwise.  This is true of `sqrt` in Julia 0.4, but it
means that we have to rewrite our own function `f` in a vectorized style, as
e.g. `f(x) = 3x.^2 + 5x + 2` (using the elementwise operator `.^` because
`array^scalar` is not defined).   (If we cared a lot about efficiency, we
might instead define a special method `f(X::AbstractArray) = map(f, X)`
or use the `@vectorize_1arg f Number` macro defined in Julia 0.4.)

### Which functions are vectorized?

As an aside, this example illustrates an annoyance with the vectorized style:

* You have to decide *in advance* whether a given function `f(x::Number)`
  will also be applied elementwise to arrays, and define a corresponding elementwise method.

For library functions like `sqrt`, this means that the library authors
have to guess at which functions should have vectorized methods, and users
have to guess at what vaguely defined subset of library functions work
for vectors.

One possible solution is to vectorize *every function automatically*.   The
language [Chapel](https://en.wikipedia.org/wiki/Chapel_%28programming_language%29)
does this: every function `f(x::Number...)` implicitly
defines a function `f(x::Array...)` that evaluates `map(f, x...)`
[(Chamberlain et al, 2011)](http://pgas11.rice.edu/papers/ChamberlainEtAl-Chapel-Iterators-PGAS11.pdf).
This could be implemented in Julia as well via
function-call overloading [(Bezanson, 2015: chapter 4)](https://github.com/JeffBezanson/phdthesis/blob/master/main.pdf),
but we chose to go in a different direction.

Instead, starting in Julia 0.5, *any* function `f(x)` can be applied elementwise
to an array `X` with the ["dot call" syntax `f.(X)`](http://docs.julialang.org/en/stable/manual/functions/#dot-syntax-for-vectorizing-functions).
Thus, the *caller* decides which functions to vectorize.  In Julia 0.6,
"traditionally" vectorized library functions like `sqrt(X)` are [deprecated](https://github.com/JuliaLang/julia/pull/17302) in
favor of `sqrt.(X)`, and dot operators
like `x .+ y` are [now equivalent](https://github.com/JuliaLang/julia/pull/17623) to
dot calls `(+).(x,y)`.   (Unlike Chapel's implicit vectorization, Julia's
`f.(x...)` syntax corresponds to `broadcast(f, x...)` rather than `map`,
which allows you to combine arrays of different shapes/dimensions.)
From the standpoint of the programmer, this adds a certain amount of
clarity because it indicates explicitly when an elementwise operation
is occuring.  From the standpoint of the compiler, dot-call syntax
enables the *syntactic loop fusion* optimization described in more detail
below, which we think is an overwhelming advantage of this style.

### Why vectorized code is fast

In many dynamic languages for technical computing, vectorization is
seen as a key (often *the* key) performance optimization.   It allows
your code to take advantage of highly optimized (perhaps even parallelized)
library routines for basic operations like `scalar*array` or `sqrt(array)`.
Those functions, in turn, are usually implemented in a low-level language
like C or Fortran.   Writing your own "devectorized" loops, in contrast,
is too slow, unless you are willing to drop down to a low-level language
yourself, because the semantics of those languages make it hard to
compile them to efficient code in general.

Thanks to Julia's design, a properly written devectorized loop in Julia
has performance comparable to C or Fortran, so there is no *necessity*
of vectorizing, but of course vectorization may still be convenient for some problems.
And vectorized operations like `scalar*array` or `sqrt(array)` are still fast in Julia
(calling optimized library routines, albeit ones written in Julia itself).

Furthermore, if your problem involves a function that does not have a pre-written,
highly optimized, vectorized, library routine in Julia, and does not
decompose easily into existing vectorized building blocks like `scalar*array`, then
you can write your own building block without dropping down to a low-level language.
(If all the performance-critical code you will ever need already existed in the
form of optimized library routines, programming would be a lot easier!)

### Why vectorized code is not as fast as it could be

There is a tension between two general principles in computing: on
the one hand, re-using highly optimized code is often good for
performance; on the other other hand, optimized code that is specialized
for your problem can usually beat general-purpose functions.
This is illustrated nicely by the vectorized version of our code above:

```jl
f(x) = 3x.^2 + 5x + 2
X = f(2 * X.^2 + 6 * X.^3 - sqrt(X))
```

Each of the operations like `X.^2`  and `5*X` *individually*
calls highly optimized functions, but their *combination*
leaves a lot of performance on the table when `X` is an array.   To see that,
you have to realize that this code is equivalent to:

```
tmp1 = X.^2
tmp2 = 2*tmp1
tmp3 = X.^3
tmp4 = 6 * tmp3
tmp5 = tmp2 + tmp4
tmp6 = sqrt(X)
tmp7 = tmp5 - tmp7
X = f(tmp7)
```

That is, each of these vectorized operations allocates a separate
temporary array, and is a separate library call with its own inner
loop.  Both of these properties are bad for performance.

First, eight arrays are allocated (`tmp1` through `tmp7`, plus another
for the result of `f(tmp7)`, and another four are allocated
internally by `f(tmp7)` for the same reasons, for *12 arrays in all*.
The resulting `X = ...` expression does *not* update `X` in-place, but
rather makes the variable `X` "point" to a new array returned by `f(tmp7)`,
discarding the old array `X`.   All of these extra arrays are eventually
deallocated by Julia's garbage collector, but in the meantime it wastes
a lot of memory (more than an order of magnitude!)

If the array `X` is small, then the performance cost of allocating
these temporary arrays is significant: heap allocation is expensive.
If the array `X` is large enough, then the time for the heap allocation
and garbage collection may be negligible, but you pay a *different* performance price
from the fact that you have 12 loops (12 passes over memory) compared
to one, largely because of the loss of [cache locality](https://en.wikipedia.org/wiki/Locality_of_reference).

In particular, main computer memory (RAM) is relatively slow (much slower than
arithmetic), so recently used data is stored in a [cache](https://en.wikipedia.org/wiki/Cache_%28computing%29): a small amount
of much faster memory.  Furthermore, there is a hierarchy of smaller,
faster caches, culminating in the [register memory](https://en.wikipedia.org/wiki/Processor_register)
of the CPU itself.   This means that, for good performance, you should
load each data item `x = X[i]` *once* into cache (into a register for small enough types), and
then perform several operations like `f(2x^2 + 6x^3 - sqrt(x))` on `x`
while you still have fast access to it, before loading the next datum;
this is called "temporal locality."   The ordinary vectorized code
discards this potential locality: each `X[i]` is loaded once for a
single small operation like `2*X[i]`, writing the result out to a temporary
array before immediately reading the next `X[i]`.

On a typical modern computer, therefore, the traditional vectorized
code `X = f(2 * X.^2 + 6 * X.^3 - sqrt(X))` is **almost 10× slower** than
the devectorized or fused-vectorized versions of the same code at the
beginning of this article.   This is not unique to Julia!  Such
vectorized code is suboptimal
in any language unless the language's compiler can automatically
fuse all of these loops (even ones that appear inside function calls),
which rarely happens for the reasons described below.

## Why does Julia need the dots to fuse the loops?

You might look at an expression like `2 * X.^2 + 6 * X.^3 - sqrt(X)` and
think that it is "obvious" that it could be combined into a single loop
over `X`.  Why can't Julia's compiler be smart enough to recognize this?

The thing that you need to realize is that, in Julia, there is nothing
particularly special about `+` or `sqrt` — they are just functions
and could do *anything*.   `X + Y` could send an email or open
a plotting window for all the compiler knows.   To figure out that it
could fuse e.g. `2*X + Y` into a single loop, allocating a single
array for the result, the compiler would need to:

* Given the types of `X` and `Y`, figure out what `*` and `+` functions
  to call.  (Julia already does, when type inference succeeds.)

* Look inside of those functions, realize that they are elementwise loops over `X`
  and `Y`, and realize that they are [pure](https://en.wikipedia.org/wiki/Pure_function)
  (e.g. `2*X` has no side-effects like modifying `Y`).  Also, it needs to infer
  not only the same purity of expressions like `X[i]` (which are calls to a function `getindex(X, i)`
  that is "just another function" to the compiler), but to detect
  what data dependencies they imply.

The key difficulty is the second step: looking at an arbitrary function and
figuring out that it is a pure elementwise loop or data access turns out to be a
very hard problem in general.  If fusion is viewed as a compiler *optimization*,
then the compiler is only free to fuse if it can *prove* that fusion *won't
change the results*, which requires the detection of purity and other data-dependency
analyses.

In contrast, when the Julia compiler sees an expression like `2 .* X .+ Y`,
it knows just from the *syntax* (the "spelling") that these are elementwise
operations, and it *guarantees* that it will *always* fuse into a single
loop, freeing it from the need to prove purity.  This is what we
term **syntactic loop fusion**.

### A halfway solution: Loop fusion for a few operations/types

One approach that may occur to you, and which has been implemented in a
variety of languages (e.g. [Kennedy & McKinley, 1993](http://dl.acm.org/citation.cfm?id=665526);
[Veldhuizen, 1995](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.43.248);
[Lewis et al., 1998](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.46.6627);
[Chakravarty & Keller, 2001](http://dl.acm.org/citation.cfm?id=507661);
[Manjikian & Abdelrahman, 2002](http://ieeexplore.ieee.org.libproxy.mit.edu/document/577265/);
[Sarkar, 2010](http://ieeexplore.ieee.org/document/5389392/);
[Prasad et al., 2011](http://dl.acm.org/citation.cfm?id=1993517);
[Wu et al., 2012](http://dl.acm.org/citation.cfm?id=2457490)), is to only
perform loop fusion for *a few "blessed" types and operations* that the
compiler can be built to recognize. In Julia, for example, we could
potentially build the compiler to recognize that it can fuse
`*`, `+`, `.^`, and similar operations for the built-in `Array` type,
but only for elements that are one of a few built-in numeric types (`Float64`, `Int`, etc.).
These operations are common enough that this may still be a worthwhile optimization
for Julia to implement at some point!

However, even though Julia will certainly implement additional compiler
optimizations as time passes, one of the key principles of Julia's design
is to "build in" as little as possible into the core language, implementing
as much of possible of Julia *in Julia* itself [(Bezanson, 2015)](https://github.com/JeffBezanson/phdthesis/blob/master/main.pdf).
Put another way, the same *optimizations should be just as available to user-defined
types and functions* as to the "built-in" functions of Julia's standard library
(`Base`).  You should be able to define your own array types
(e.g. the [StaticArrays](https://github.com/JuliaArrays/StaticArrays.jl)
package or [PETSc arrays](https://github.com/JuliaParallel/PETSc.jl))
and functions (such as our `f` above), and have them be capable of fusing vectorized operations.

### Syntactic loop fusion in Julia

In contrast, Julia's approach is quite simple and general: the caller
indicates, by adding dots, which function calls and operators are
intended to be applied elementwise (specifically, as `broadcast` calls).
The compiler notices these dots at *parse time* (or technically
at "lowering" time, but in any case long before it knows
the types of the variables etc.), and transforms them into calls to
`broadcast`.  Moreover, it guarantees that *nested* "dot calls" will
*always* be fused into a single broadcast call, i.e. a single loop.

Put another way, `f.(g.(x .+ 1))` is treated by Julia as simply
[syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar) for
`broadcast(x -> f(g(x + 1)), x)`.   An assignment `x .= f.(g.(y))`
is treated as sugar for the in-place operation
`broadcast!(x -> f(g(x + 1)), x, x)`.   The compiler need not prove
that this produces the same result as a corresponding non-fused operation,
because the fusion is a mandatory transformation defined as part
of the language, rather than an optional optimization.

Arbitrary user-defined functions `f(x)` work with this mechanism,
as do arbitrary user-defined collection types for `x`, as long as you
define `broadcast` methods for your collection.  (The default
`broadcast` already works for any subtype of `AbstractArray`.)

Moreover, dotted operators are now available for not just
the familiar ASCII operators like `.+`, but for *any*
character that Julia parses as a binary operator.  This includes
a wide array of Unicode symbols like `⊗`, `∪`, and `⨳`, most
of which are undefined by default.   So, for example, if you
define `⊗(x,y) = kron(x,y)` for the [Kronecker product](https://en.wikipedia.org/wiki/Kronecker_product),
you can immediately do `[A, B] .⊗ [C, D]` to compute the
"elementwise" operation `[A ⊗ C, B ⊗ D]`, because `x .⊗ y`
is sugar for `broadcast(⊗, x, y)`.

Note that "side-by-side" binary operations are actually equivalent
to nested calls, and hence they fuse for dotted operations.   For
example `3 .* x .+ y` is equivalent to `(+).((*).(3, x), y)`, and
hence it fuses into `broadcast((x,y) -> 3*x+y, x, y)`.   Note
also that the fusion stops as soon as a "non-dot" call is encountered,
e.g. `sqrt.(abs.(sort(x.^2)))` fuses the `sqrt` and `abs` operations
into a single loop, but `x.^2` occurs in a separate loop (producing
a temporary array) because of the intervening non-dot function call
`sort(...)`.

### Other partway solutions

For the sake of completeness, we should mention
some other possibilities that would partly
address the problems of vectorization.  For example, functions could
be specially [annotated to declare that they are pure](https://github.com/JuliaLang/julia/issues/414),
one could specially annotate container types with
array-like semantics, etcetera, to help the compiler recognize the
possibility of fusion.   But again, this imposes a lot of requirements
on the library authors, and as above it requires them to identify
in advance which functions are likely to be applied to vectors
(and hence be worth the additional analysis and annotation effort).

Another approach that has been suggested is to define updating operators
like `x += y` to be equivalent to calls to a special function,
like `plusequals!(x, y)` that can be defined as in-place operations, rather
than a synonym for `x = x + y` as in Julia today.
([NumPy does this](https://docs.python.org/3.3/reference/datamodel.html#object.__iadd__).)
By itself, this can be used to [avoid temporary arrays in some simple cases](http://blog.svenbrauch.de/2016/04/13/processing-scientific-data-in-python-and-numpy-but-doing-it-fast/) by breaking them into a sequence of in-place updates, but
it doesn't handle more complex expressions, is limited to a few
operations like `+`, and doesn't address the cache inefficiency of
multiple loops.   (In Julia 0.6, you can do `x .+= y` and it is
equivalent to `x .= x .+ y`, which does a single fused loop in-place,
but this syntax now extends to arbitrary combinations of arbitrary functions.)

A third partway solution is to define a [domain-specific
language](https://en.wikipedia.org/wiki/Domain-specific_language), on top of
Julia, for expressing a fusing sequence of vectorized operations, which then
hooks into a code-generation engine to produce the fused loops.   This kind of
approach was implemented directly in Julia, thanks to Julia's metaprogramming
facilities, in the [Devectorize
package](https://github.com/lindahua/Devectorize.jl). In Python, this approach
can be found in the
[Theano](http://deeplearning.net/software/theano/introduction.html) and
[PyOP2](https://op2.github.io/PyOP2/) software, both of which generate code in a
low-level language (e.g. C++) whose compiler is invoked as needed.   The common
limitation of these approaches, however, is that they are again limited to a
small set of "vector operations" (and a small set of array/scalar types in
Theano and PyOP2) that are known to their code-generation engines.

## Should other languages implement syntactic loop fusion?

Obviously, Julia's approach of syntactic loop fusion relies on the
fact that, as a young language, we are still relatively free to
redefine core syntactic elements like `f.(x)` and `x .+ y`.  But
suppose you were willing to add this or similar syntax to an
existing language, like Python or Go; would you then be able to
implement the same fusing semantics efficiently?

There is a catch: `2 .* x .+ x .^ 2` is sugar for
`broadcast(x -> 2*x + x^2, x)` in Julia, but for this to be
fast we need the [higher-order function](https://en.wikipedia.org/wiki/Higher-order_function)
`broadcast` to be very fast as well.  First, this
requires that arbitrary user-defined scalar (non-vectorized!) functions like
`x -> 2*x + x^2` be compiled to fast code, which isn't true in
most other dynamically typed high-level languages like Python, but is usually true
in statically typed languages like Go.   Second, it ideally requires that
higher-order functions like `broadcast` be able to [inline](https://en.wikipedia.org/wiki/Inline_expansion)
the function argument `x -> 2*x + x^2`, and this facility is even
less common.  (It wasn't available in Julia until version 0.5.)

### The importance of inlining

In particular, consider
a naive implementation of `broadcast` (only for one-argument functions):

```jl
function naivebroadcast(f, x)
    y = similar(x)
    for i in eachindex(x)
        y[i] = f(x[i])
    end
    return y
end
```

In Julia, as in other languages, `f` must be some kind of [function
pointer](https://en.wikipedia.org/wiki/Function_pointer) or [function
object](https://en.wikipedia.org/wiki/Function_object). Normally, a call
`f(x[i])` to a function object `f` must figure out where the actual [machine
code](https://en.wikipedia.org/wiki/Machine_code) for the function is (in Julia,
this involves dispatching on the type of `x[i]`; in object-oriented languages,
it might involve dispatching on the type of `f`), push the argument `x[i]`
etcetera to `f` via a register and/or a [call stack](https://en.wikipedia.org/wiki/Call_stack),
jump to the machine instructions to execute them, jump back to
the caller `naivebroadcast`, and extract the return value.
That is, calling a function argument `f` involves some overhead beyond
the cost of the computations inside `f`.

If `f(x)` is expensive enough, then the overhead of the function call may be negligible,
but for a cheap function like `f(x) = 2*x + x^2` the overhead can be very
significant: with Julia 0.4, the overhead is roughly a factor of two compared
to a hand-written loop that evaluates `z = x[i]; y[i] = 2*z + z^2`.   Since lots
of vectorized code in practice evaluates relatively cheap functions like this,
it would be a big problem for a generic vectorization method based on `broadcast`.

However, in Julia 0.5, every function has its own type.  And, in Julia,
whenever you call a function like `naivebroadcast(f, x)`, a *specialized version*
of `naivebroadcast` is compiled for `typeof(f)` and `typeof(x)`.   Since
the compiled code is specific to `typeof(f)`, i.e. to the specific function
being passed, the Julia compiler is free to inline `f(x)` into the generated code
if it wants to, and all of the function-call overhead can disappear.

Julia is neither the first nor the only language that can inline
higher-order functions; e.g. it is reportedly [possible in Haskell](http://stackoverflow.com/questions/25566517/can-haskell-inline-functions-passed-as-an-argument),
and indeed this kind of optimization is even more
important in such [functional languages](https://en.wikipedia.org/wiki/Functional_programming).
But it is less widely available in [imperative languages](https://en.wikipedia.org/wiki/Imperative_programming). Fast
higher-order functions are a key ingredient of Julia that allows
a function like `broadcast` to be written in Julia itself (and
hence be extensible to user-defined containers), rather than having
to be built in to the compiler (and limited to "built-in" types).
