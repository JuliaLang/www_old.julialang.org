---
layout: default
title:  Julia Benchmarks
---

<div class="figure">
<div class="cs-benchmark-table">
{% include benchmarks.html %}
<p class="caption"><b>Figure:</b>
benchmark times relative to C (smaller is better, C performance = 1.0).
</p>
<p class="note">
C and Fortran compiled with gcc 4.8.9, taking best timing from all optimization levels (-O0 through -O3).
C, Fortran, Go, Julia, Lua, Python, and Octave use <a href="https://github.com/xianyi/OpenBLAS">OpenBLAS</a> v0.2.19
for matrix operations; Mathematica uses Intel(R) MKL.
The Python environment is <a href="https://anaconda.org/anaconda/python">Anaconda Python</a> v3.5.4.
The Python implementations of <tt>rand_mat_stat</tt> and <tt>rand_mat_mul</tt> use <a href="http://www.numpy.org/">NumPy</a> v1.13.1 and OpenBLAS v0.2.19 functions; the rest are pure Python implementations. 
</p>
</div>
</center>
