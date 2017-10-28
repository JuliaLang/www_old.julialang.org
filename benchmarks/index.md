---
layout: default
title:  Julia Benchmarks
---

The data presented here is generated with <a href="https://github.com/JuliaLang/IJulia.jl">IJulia</a> from <a href="http://nbviewer.ipython.org/url/julialang.org/benchmarks/benchmarks.ipynb">the benchmarks notebook</a>.

<div class="figure">
<div class="cs-benchmark-table">
{% include benchmarks.html %}
<p class="caption"><b>Figure:</b>
benchmark times relative to C (smaller is better, C performance = 1.0).
</p>
</div>

C and Fortran compiled with gcc 4.8.9, taking best timing from all
optimization levels (-O0 through -O3).  C, Fortran, Go, Julia, Lua,
Python, and Octave use <a
href="https://github.com/xianyi/OpenBLAS">OpenBLAS</a> v0.2.19 for
matrix operations; Mathematica uses Intel(R) MKL.  The Python
environment is <a href="https://anaconda.org/anaconda/python">Anaconda
Python</a> v3.5.4.  The Python implementations of
<tt>rand_mat_stat</tt> and <tt>rand_mat_mul</tt> use <a
href="http://www.numpy.org/">NumPy</a> v1.13.1 and OpenBLAS v0.2.19
functions; the rest are pure Python implementations.

These micro-benchmark results were obtained on a single core (serial
execution) on an Intel(R) Core(TM) i7-3960X 3.30GHz CPU with 64GB of
1600MHz DDR3 RAM, running openSUSE LEAP 42.2 Linux.

Raw benchmark numbers in CSV format are available [here](benchmarks/benchmarks.csv).
