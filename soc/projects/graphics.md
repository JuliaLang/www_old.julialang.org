---
layout: default
title:  Graphic Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## Makie 1): Improve Documentation + add Examples

[Makie](https://github.com/JuliaPlots/Makie.jl) is a new plotting library in need of tests and documentation.

One needs to go through all sections of the current documentation, make sure they are understandable and
add examples to the documentation where necessary.
Depending on how much time is left,
there are endless opportunities to create impressive and creative plotting examples
for the example database.

**Expected Results**: greatly improved documentations
**Recommended skills**: Attention to detail and a lot of experience with plotting.
**Mentors**: [Simon Danisch](https://github.com/SimonDanisch/)


## Makie 2): Develop a Cairo/GR/WebVisualize backend

This project involves overloading the [Makie API](https://github.com/JuliaPlots/Makie.jl/tree/master/src/atomics)
for backends to draw all the different plot types.
You will start with a skeleton from already present backends, so it's about filling the
gaps and making sure all tests pass for the new backend.

**Expected Results**: a fully working new backend to Makie
**Recommended skills**: One should be familiar with a graphics drawing API like Cairo or WebGL for this project.
**Mentors**: [Simon Danisch](https://github.com/SimonDanisch/)


## Makie 3): Port Recipes

[Plots.jl](https://github.com/tbreloff/Plots.jl) offers a lot of [recipes](http://docs.juliaplots.org/latest/recipes/).
In Makie, we will need to make sure that they are available and work correctly.
This project will involve writing a compatibility layer for (PlotRecipes.jl)[https://github.com/JuliaPlots/PlotRecipes.jl] and then making sure
that all the recipes that are spread around the Julia plotting community work!
**Expected Results**: porting and testing as many recipes as possible
**Recommended skills**: Experience with Plots.jl would be great
**Mentors**: [Simon Danisch](https://github.com/SimonDanisch/)


## Refactor the GLAbstraction API

We are working on deep refactor of [GLAbstraction](https://github.com/JuliaGL/GLAbstraction.jl), to finally make a fully fledged,
general purpose layer above OpenGL.

The work happens at this [PR](https://github.com/JuliaGL/GLAbstraction.jl/pull/88) and has the following goals:

* getting rid of Reactive/Color/ and other not strictly opengl related packages. Instead offer overloadable APIs to do the job
* Introduce leaner VertexArray buffer, integrating nicely with view(buffer, faces). A mesh is then basically just view(vertices::Vector{Point3f0}, indices::Vector{GLTriangle})
* Introduce UniformBuffers to hold state in shaders independent of executing the shader
* Introduce lean RenderObject, that doesn't hold any data, besides information on the shader layout - data will get transferred via calling the object with new data. When uniformbuffers are used, data can also be updated in place
* remove GLVisualize specific code, that was basically just parked here because I didn't had a better place to put it
* Transpiler integration - make it the main way to create shaders, instead of having ugly templated shader that nobody understands

Besides Transpiler integration, a lot of those goals have been achieved and now effort needs to
be put into writing tests and porting the packages that rely on GLAbstraction to work with the new API.

**Expected Results**: finishing the PR and making sure it works with dependant packages
**Recommended skills**: Requirement is a good understanding of OpenGL
**Mentors**: [Simon Danisch](https://github.com/SimonDanisch/)
