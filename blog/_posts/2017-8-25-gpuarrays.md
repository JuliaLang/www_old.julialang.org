---
layout: post
title: "Julia's GPU ecosystem: A status repot"
author: <a href="https://github.com/SimonDanisch">Simon Danisch</a>
---

A lot has been happening lately in Julia's GPU ecosystem.

[Tim Besard](https://github.com/maleadt) has put great effort into making [CUDAnative.jl](https://github.com/JuliaGPU/CUDAnative.jl/) a fully fledged compiler backend to execute Julia code on nvidia GPUs.

[Mike Innes](https://github.com/MikeInnes) just published [CuArrays](https://github.com/FluxML/CuArrays.jl) along with a detailed [blog post](http://mikeinnes.github.io/2017/08/24/cudanative.html) outlining all the great features Julia brings into the world of GPU programming.

I want to add some more words about my recent work on [GPUArrays](https://github.com/JuliaGPU/GPUArrays.jl) and benchmarking our current GPU packages.

GPUArrays is a backend independent N dimensional Array package that builds upon the work of [Transpiler.jl](https://github.com/SimonDanisch/Transpiler.jl) for an OpenGL and OpenCL backend and uses [CUDAnative](https://github.com/JuliaGPU/CUDAnative.jl/) for nvidia based hardware.
It also offers a threaded Julia backend which can even utilize Xeon Phis and is great for debugging the GPU kernels.
GPUArrays also includes abstractions over the intrinsics of the different backends and makes it possible to write GPU programs
completely in Julia for all hardware.

CuArrays is very similar to GPUArrays' CUDAnative backend and was first supposed to be an extension of that,
but we decided to concentrate on CUDA support in its own package to create a much leaner package.
This is a fair approach for now and we plan to merge things back at some point to decrease fragmentation of the ecosystem.

Like CuArrays, GPUArrays supports functions like [broadcast](https://julialang.org/blog/2017/01/moredots), `mapreduce`, indexing, `vcat`/`hcat` and all the functionality that comes for free from the support of these generic functions, e.g. `sum`, `maximum`, etc.

On top of that GPUArrays wraps CU/CL-BLAS and CU/CL-FFT enabling a wide range of applications.

To get an idea of where we are in terms of performance, I started writing a benchmark suite for Julia's GPU array packages including [ArrayFire](https://github.com/gaika/ArrayFire.jl).
It can run the whole suite and print out reports automatically. We're planning to integrate it into Github and publish the results on an interactive website where one can explore the results. Until then, the static report [over at GPUBenchmarks.jl](https://github.com/JuliaGPU/GPUBenchmarks.jl/blob/master/results/results.md) has to do the trick.
This is the first release of GPUBenchmarks, so please treat the numbers with care!

For the future, we plan to continue integrating existing libraries like [CUDNN](https://github.com/JuliaGPU/CUDNN.jl) and [CUSolver](https://github.com/JuliaGPU/CUSOLVER.jl) into GPUArrays as we head for feature parity with Julia's Base Array type.
We also hope to make the ecosystem much more stable and improve the abstractions needed to write platform independent GPU code.

All in all, Julia can now finally offer single source GPU programming, much like what [SyCL](https://www.khronos.org/sycl) is promising.

I'm sure the advantages we can offer for writing GPU code will make Julia a strong player for GPU programming in the coming years!
