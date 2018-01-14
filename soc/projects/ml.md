---
layout: default
title: Data Science and Machine Learning Projects – Summer of Code
---

{% include toc.html %}

## Model Loading for Flux.jl

It would be useful to load existing trained models created with other frameworks – say Caffe, TensorFlow or MXNet – into Flux. This project would involve investigating the model formats and building readers so that those models can be run in native Julia.

**Expected Results**: A package which can load external model files into Flux data structures.

**Recommended Skills**: Familiarity with neural network libraries.

**Mentors**: Mike Innes

## Making Aquiring Open-Data Easy

Goverments and Universities are releasing huge amounts of data under Open Data policies.
Web portals such as:
 - http://data.gov
 - http://data.gov.au
 - https://dataverse.harvard.edu/
 - http://datadryad.org/
 - https://figshare.com/
 
Expose great quanities of data just wating to be used.

[DataDeps.jl](https://github.com/oxinabox/DataDeps.jl) is a package that helps data scientists ensures that anyone running their code has all the data it needs, no matter when or where it is run.
To do this it needs a registration block, which is a chunk of julia code which says where the data can be download, who created it, what terms and conditions are on its use etc.
For a simple dataset that is all in one file writing this is pretty easy -- copy and paste the info from the website hosting the data.
When you want to dozens of datasets, some of which have dozens of files (and no easy way to download a .zip of all of them), writing this registration block is a bit more work.

[DataDepsGenerators.jl](https://github.com/oxinabox/DataDepsGenerators.jl) exists to solve that.
Give it a URL (or other identifier) for a page describing a dataset, and outputs all the code for a registration block, that you can copy and paste straight into your julia project.
Right now DataDepsGenerators only supports a couple of sites: GitHub (for https://github.com/BuzzFeedNews/ and https://github.com/fivethirtyeight/data/ and others) and the [UCI ML Repository](https://archive.ics.uci.edu/ml/datasets/).
This project aims to change that by adding support for the [CKAN](http://docs.ckan.org/en/latest/api/index.html) and the [OA-PMH](https://www.openarchives.org/OAI/openarchivesprotocol.html) APIs.

The [CKAN](http://docs.ckan.org/en/latest/api/index.html) and the [OA-PMH](https://www.openarchives.org/OAI/openarchivesprotocol.html) APIs allow the automated extraction of metadata for a dataset.
They are primarily used by goverment "data.gov.\*" sites and research repositories respectively.
Together they host millions of datasets, furfilling those institutions open data policies.

This project is to leverage those APIs, to allow others to leaverage those data repositories to produce easily repeatable, data driven research.


**Expected Results**: a series of patches to [DataDepsGenerators.jl](https://github.com/oxinabox/DataDepsGenerators.jl), giving it the capacity to generate a DataDeps registration block for any dataset hosted on site exposing a CRAN, or OAI-PMH API.

**Recommended Skills**: Familarity with web APIs and related technolgies (e.g. REST, JSON, XML (Probably not OAUTH, but if you've done OAUTH then your more than familar enough)). Some practice with webscraping is likely to be useful. A love of data and of doing cool things with it, is a big plus.

**Mentors**: [Lyndon White (oxinabox)](https://github.com/oxinabox/)

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

Some work in this area can be found in
[DiffEqParamEstim.jl](https://github.com/JuliaDiffEq/DiffEqParamEstim.jl)
and [DiffEqBayes.jl](https://github.com/JuliaDiffEq/DiffEqBayes.jl). Examples
can be found [in the DifferentialEquations.jl documentation](http://docs.juliadiffeq.org/latest/analysis/parameter_estimation.html).

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
