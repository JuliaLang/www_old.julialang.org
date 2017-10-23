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

## Machine learning tools for classification of qualitative traits of differential equation models

Machine learning has become a popular tool for understanding data, but scientists
typically want to use this data to better understand their differential
equation-based models. Differential equations usually have parameters which are
unknown but when changed can cause qualitative differences to the results. By
pairing machine learning tooling with data generation from differential equation
models, tools can be developed which can classify when behaviors are to be
expected in the solution.

**Recommended Skills**: Background knowledge of standard machine learning
techniques. It's recommended but not required that one has basic knowledge of
differential equations and DifferentialEquations.jl.

**Expected Results**: Tools for easily classifying parameters using machine
learning tooling for users inexperienced with machine learning.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)
