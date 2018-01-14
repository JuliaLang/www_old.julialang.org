---
layout: default
title: Machine Learning General Projects – Summer of Code
---

{% include toc.html %}

## Model Loading for Flux.jl

It would be useful to load existing trained models created with other frameworks – say Caffe, TensorFlow or MXNet – into Flux. This project would involve investigating the model formats and building readers so that those models can be run in native Julia.

**Expected Results**: A package which can load external model files into Flux data structures.

**Recommended Skills**: Familiarity with neural network libraries.

**Mentors**: Mike Innes

## Standardized dataset packaging

Scientific and technical computing often makes use of publicly available datasets. Often, there's a lot of overhead to finding these data sets and coercing them into a usable format. Packages like [RDatasets.jl](https://github.com/johnmyleswhite/RDatasets.jl/) and [MNIST.jl](https://github.com/johnmyleswhite/MNIST.jl) attempt to make this easier by downloading data automatically and providing it as a Julia data structure.

This project involves building a "[BinDeps.jl](https://github.com/JuliaLang/BinDeps.jl) for data" which would make the creation of data-providing packages easier. The package would make it easy to download / unzip large files and check their integrity them in a cross-platform way. Facilities for downloading specific datasets can then be built on top of this.

**Expected Results**: A BinDeps-like package for downloading and managing data, as well as examples of this package used with specific data sets.

**Recommended Skills**: Only standard programming skills are needed for this project. Familiarity with Julia is a plus.

**Mentors**: [JuliaML Members](https://github.com/orgs/JuliaML/people)

## Parameter estimation for nonlinear dynamical models

Machine learning has become a popular tool for understanding data, but scientists
typically understand the world through the lens of physical laws and their
resulting dynamical models. These models are generally differential equations
given by physical first principles, where the constants in the equations such
as chemical reaction rates and planetary masses determine the overall dynamics.
The inverse problem to simulation, known as parameter estimation, is the process
of utilizing data to determine these model parameters.

The purpose of this project is to utilize the growing array of statistical,
optimization, and machine learning tools in the Julia ecosystem to build
library functions that make it easy for scientists to perform this parameter
estimation with the most high-powered and robust methodologies. Possible projects
include investigating methods for Bayesian estimation of parameters via Stan.jl
and Julia-based libraries like Turing.jl, or global optimization-based approaches.
Novel techniques like classifying model outcomes via support vector machines
and deep neural networks is can also be considered. Research and benchmarking
to attempt to find the most robust methods will take place in this project.

**Recommended Skills**: Background knowledge of standard machine learning,
statistical, or optimization techniques. It's recommended but not required that
one has basic knowledge of differential equations and DifferentialEquations.jl.
Using the differential equation solver to get outputs from parameters can
be learned on the job, but you should already be familiar (but not necessarily
an expert) with the estimation techniques you are looking to employ.

**Expected Results**: Library functions for performing parameter estimation
and inferring properties of differential equation solutions from parameters.
Notebooks containing benchmarks determining the effectiveness of various methods
and classifying when specific approaches are appropriate will be developed
simultaneously.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)
