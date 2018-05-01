+---
 +layout: post
 +title:  "Extensible broadcast fusion"
 +author: <a href="https://github.com/mbauman">Matt Bauman (Julia Computing)</a>
 +---

Julia version 0.7 brings with it an exciting new feature: the ability to customize broadcast fusion! This recently-merged change is the culmination of a long iterative design process that involved many members of the community. We have converged on a highly extensible interface that should satisfy many use-cases.  In this blog post I'll explain why this is a big deal by reviewing some of the key features and just scratch the surface of all that is possible with this new design. I'm quite certain that our enterprising community will come up with many more clever ways to exploit this new structure in the future.

Julia now uses a first-class datastructure to "lazily" represent a fused broadcast expression before executing it. If you're not a package developer this may not mean all that much to you, but you'll still reap the many rewards. In Base Julia and its standard libraries alone, this means:

* Ranges can now identify cases where they can compute the result in terms of a new range. For example, the expression `((1:10000) .+ 20) .* 7` doesn't need to allocate a vector for 10,000 elements — it doesn't even need to do 10,000 computations. It can simply operate in terms of the start, stop, and step to compute the result: `147:7:70140`.
* BitArrays can identify cases where they can operate on 64 bits at once, yielding huge performance gains — often two orders of magnitude or more!
* LinearAlgebra's structured matrices no longer return sparse arrays — they’ll either maintain an appropriate structure or return a dense array.
* Broadcasting at the global scope is now pre-compilable, and you can use dot-broadcast inside generated functions.

### What is broadcast fusion?

Broadcasting is a core feature of Julia: it allows you to compactly and efficiently express an elementwise operation over containers and scalars. In cases where the sizes don't match, it will virtually extend missing dimensions or "singleton" dimensions with only one value by repeating them to fill the outer shape. For example, the expression `([1, 2, 3] .+ [10 20 30 40]) ./ 10` combines a 3-element column vector, a 1x4 matrix, and a scalar to compute a 3x4 result. I imagine this as "extruding" the vector across the columns of the one-row matrix and spreading the 10 across the entire result:

```julia
julia> ([1, 2, 3] .+ [10 20 30 40]) ./ 10
3×4 Array{Float64,2}:
 1.1  2.1  3.1  4.1
 1.2  2.2  3.2  4.2
 1.3  2.3  3.3  4.3
```
 
Julia does this computation by "fusing" the two operations together into one pass. So instead of first constructing an integer matrix resulting from the addition (`[11 21 31 41; 12 22 ...]`) and then subsequently using a second loop to divide each element by 10, Julia does both the addition and division for each element at the same time, making just one pass through the output array and skipping the intermediate array entirely.  This fusion optimization happens as a syntax-level transformation so it is guaranteed to occur.

Julia computes this result by first constructing an object that represents the "kernel" and then immediately executing it. This little bit of indirection allows a whole host of customizations.

### The representation of a fused broadcast

You can see precisely how a fused broadcast is represented with `Meta.@lower`, but in simpler terms the expression `([1, 2, 3] .+ [10 20 30 40]) ./ 10` is effectively a syntax transformation for:

```julia
julia> using .Broadcast: materialize, broadcasted
       bc = broadcasted(/, broadcasted(+, [1, 2, 3], [10 20 30 40]), 10)
	   materialize(bc)
3×4 Array{Float64,2}:
 1.1  2.1  3.1  4.1
 1.2  2.2  3.2  4.2
 1.3  2.3  3.3  4.3
```

In this case, that `bc` object is an instance of a `Broadcasted` struct. It just holds onto the function and its arguments — and its arguments may include other nested `Broadcasted` structs. The `materialize` function does a bit of pre-processing and then calls `copy(bc)`, which allocates the result and then finally loops over the result and executes the functions.

Each step along the way is extensible, exploiting the power of Julia's multiple dispatch, inlining and argument specialization for near-zero overhead. With this basic framework in mind, you can begin to see how we the built-in and standard library arrays are able to implement all those new features mentioned above:

* Ranges are able to "opt-out" of fusion by defining specialized `Broadcast.broadcasted` methods that immediately return re-computed ranges.
* When LinearAlgebra's structured matrices are to asked to allocate the result, their specialized `broadcast_similar` methods can walk through the `Broadcasted` expression tree and identify if any structure will remain.
* When broadcasting into a `BitArray`, it can first introspect the functions and their arguments in the expression tree to see if it can operate at the level of the packed 64-bit chunks as `UInt64`s instead of working bit-by-bit.

### Potential applications: optimization, machine learning, and GPUs

Of course, this is all documented and available to packages, too. There's no secret sauce that we're hoarding for ourselves. It'll be exciting to see how the many creative minds in the package ecosystem manage to take advantage of all this new functionality. Some of the places where I see this yielding a significant benefit include mathematical optimization, machine learning, and GPUs.

Mathematical optimization: Convex.jl's use case?

ML: KNet/MXNet's opting out? And differentiation for back-propagation?

GPU: Fusing a complicated broadcast expression into a single kernel has already been a huge boon to the performance of arrays on GPUs. Most GPU programming packages won't necessarily need to introspect or customize the broadcasted expression, but they're looking to the future to a potential extension that would allow fusing _a reduction_ with the broadcasted expression.  While not possible yet, the bulk of the machinery is in place to operate directly upon the `Broadcasted` lazy wrapper instead of allocating the intermediate array in an expression like `sum(X.^2 .+ Y.^2)`.
