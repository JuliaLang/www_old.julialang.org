---
layout: default
title:  Julia Micro-Benchmarks
---

# Julia Micro-Benchmarks

These micro-benchmarks, while not comprehensive, do test compiler
performance on a range of common code patterns, such as function
calls, string parsing, sorting, numerical loops, random number
generation, recursion, and array operations.

<div class="figure">
<div class="cs-benchmark-table">
{% include benchmarks.html %}
<p class="caption"><b>Figure:</b>
benchmark times relative to C (smaller is better, C performance = 1.0).
</p>
</div>
</div>

## Benchmark algorithms

It is important to note that the benchmark codes are not written for
absolute maximal performance --the fastest code to compute
`recursion_fibonacci(20)` is the constant literal `6765`.  Instead,
the benchmarks are written to test the performance of *identical
algorithms and code patterns* implemented in each language.  For
example, the Fibonacci benchmarks all use the same inefficient
doubly-recursive algorithm, and the pi summation benchmarks evaluate
the same slowly-converging series with the same *for* loop.

[iteration_pisum](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L89-L98)
tests performance of a hot *for* loop that sums the slowly-converging series π²/6 = 1/1² + 1/2² + 1/3² + ⋅ ⋅ ⋅ to 10,000 terms.

  
[recursion_fibonacci](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L11)
tests performance of  recursion by computing the 20th Fibonacci number 6765 with a
doubly-recursive algorithm. The Julia code is the one-liner
`fib(n) = n < 2 ? n : fib(n-1) + fib(n-2)`. 

[recursion_quicksort](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L65-L81)
tests recursion by sorting a vector of 5000 random integers with a
recursive quicksort algorithm. 

[parse_integers](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L18-L27)
tests performance of string libraries by converting 1000 random
integers to strings and parsing the strings back to integers.
An assertion for equality is included in the timing.

[print_to_file](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L147-L153)
tests fine-grained IO performance by printing 200,000 integers to a file,
two at a time. 

[matrix_statistics](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L119-L134)
tests an assortment of matrix computations, including concatenation,
multiplication, integer powers, Hermitian conjugation, and trace,
on small (5 × 5) random matrices. 

[matrix_multiply](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L142) 
tests random number generation and matrix multiplication on moderately
large (1000 × 1000) matrices. In Julia, the benchmark code is the one-liner
`rand(1000,1000)*rand(1000,1000)` and the matrix multiplication is
computed by a direct call to BLAS. In other languages the "algorithm"
is to call the most obvious built-in/standard random-number and matmul
routines (or to directly call BLAS if the language does not provide a
high-level matmul), except where a matmul/BLAS call is not possible
(such as in JavaScript).

[userfunc_mandelbrot](https://github.com/JuliaLang/Microbenchmarks/blob/1a88c0048de0507be69640c4e34cc07a30d45ee0/perf.jl#L43-L57)
tests performance of calls to user-defined functions, via calculation
of the Mandelbrot set over a 2d grid. The bottleneck is the user-defined
norm-squared function `myabs2(z) = real(z)*real(z) + imag(z)*imag(z)`,
which is called repeatedly to test divergence of the Mandelbrot iteration
z → z² + c. In most languages it would be more efficient to call a built-in
`abs` function, but the point of the benchmark is to test the performance
of the user-defined `myabs2`. 


Implementations of benchmark algorithms in other languages:
[C](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.c),
[Fortran](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.f90),
[Julia](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.jl),
[Python](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.py),
[Matlab/Octave](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.m),
[R](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.R),
[JavaScript](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.js),
[Java](https://github.com/JuliaLang/Microbenchmarks/tree/master/java/src/main/java),
[Lua](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.lua),
[Mathematica](https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.nb).

## Benchmark platform

These micro-benchmark results were obtained on a single core (serial
execution) of an Intel(R) Core(TM) i7-3960X 3.30GHz CPU with 64GB of
1600MHz DDR3 RAM, running openSUSE LEAP 42.3 Linux.

C and Fortran were compiled with gcc 4.8.5, taking best timing from all
optimization levels (-O0 through -O3).  C, Fortran, Go, Julia, Lua,
Python, and Octave use <a
href="https://github.com/xianyi/OpenBLAS">OpenBLAS</a> v0.2.19 for
matrix operations; Mathematica uses Intel(R) MKL.  The Python
environment is <a href="https://anaconda.org/anaconda/python">Anaconda
Python</a> v3.6.3.  The Python implementations of
<tt>rand_mat_stat</tt> and <tt>rand_mat_mul</tt> use <a
href="http://www.numpy.org/">NumPy</a> v1.13.1 and OpenBLAS v0.2.19
functions; the rest are pure Python implementations. Raw benchmark
numbers in CSV format are available [here](benchmarks.csv).

