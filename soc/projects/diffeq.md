---
layout: default
title:  DiffEq Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## Native Julia ODE, SDE, DAE, DDE, and (S)PDE Solvers

The DifferentialEquations.jl ecosystem has an extensive set of state-of-the-art
methods for solving differential equations. By mixing native methods and wrapped
methods under the same dispatch system, [DifferentialEquations.jl serves both as a system to deploy and research the most modern efficient methodologies](https://arxiv.org/abs/1807.06430).
While most of the basic methods have been developed and optimized, many newer
methods need high performance implementations and real-world tests of their
efficiency claims. In this project students will be paired with current
researchers in the discipline to get a handle on some of the latest techniques
and build efficient implementations into the \*DiffEq libraries
(OrdinaryDiffEq.jl, StochasticDiffEq.jl, DelayDiffEq.jl). Possible families of
methods to implement are:

- Implicit-Explicit (IMEX) Methods
- Geometric (exponential) integrators
- Low memory Runge-Kutta methods
- Multistep methods specialized for second order ODEs (satellite simulation)
- Parallel (multithreaded) extrapolation (both explicit and implicit)
- Parallel Implicit Integrating Factor Methods (PDEs and SPDEs)
- Parallel-in-time ODE Methods
- Rosenbrock-W methods
- Approximate matrix factorization
- Runge-Kutta-Chebyschev Methods (high stability RK methods)
- Fully Implicit Runge-Kutta (FIRK) methods
- Anderson-Accelerated delay equation stepping
- Boundary value problem (BVP) solvers like MIRK and collocation methods
- BDF methods for differential-algebraic equations (DAEs)

Additionally, projects could potentially improve the performance of the full
differential equations ecosystem include:

- Approximate matrix factorization
- Alternative adaptive stepsize techniques and step optimization
- Quasi-Newton globalization and optimization
- Cache size reductions
- Enhanced within-method multithreading, distributed parallelism, and GPU usage
- Improved automated method choosing
- Adaptive preconditioning on large-scale (PDE) discretizations

Many of these methods are the basis of high-efficiency partial differential
equation (PDE) solvers and are thus important to many communities like
computational fluid dynamics, mathematical biology, and quantum mechanics.

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability (or eagerness to learn) to write fast code.

**Expected Results**: Contributions of production-quality solver methods.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Parallelization of the Sundials Solver Library

The Sundials set of solvers is a popular library for performing the time stepping
portion of large-scale partial differential equation (PDE) solvers. This library
has the ability to be internally parallelized, supporting threading, multi-node
distributed parallelism, and GPUs. The Julia package
[Sundials.jl](https://github.com/JuliaDiffEq/Sundials.jl) is a wrapper for the
Sundials library which is almost feature-complete with the wrapped code. However,
the functionality that it does not make use of is the parallelization. The purpose
of this project is to build the tooling to be able to utilize the parallelization
parts from within Julia, and benchmarking their effectiveness on large PDEs.

**Recommended Skills**: Background knowledge in C++. Some knowledge of parallel
computing is preferred.

**Expected Results**: Examples showing how to utilize the direct wrappers to
perform calculations in parallel and the ability to "flip a switch" to turn on
parallelism in high-level APIs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Tools for global and adjoint sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the affect that parameters
have on a differential equation model. A good introduction [can be found in this thesis](http://discovery.ucl.ac.uk/19896/). Global Sensitivity Analysis tools can be
much more efficient than Local Sensitivity Analysis tools, and give a better
view of how parameters affect the model in a more general sense. Julia currently
has an implementation Local Sensitivity Analysis, but there is no method for Global
Sensitivity Analysis. The goal of this project would be to implement more global
sensitivity analysis methods like the eFAST method into [DiffEqSensitivity.jl](https://github.com/JuliaDiffEq/DiffEqSensitivity.jl) which
can be used with any differential equation solver on the common interface.

In addition, adjoint sensitivity analysis is a more efficient method than
standard local sensitivity analysis when the number of parameters is large.
It is the differential equations extension of "backpropagation" and is used
in many other domains like parameter estimation as part of the optimization
process. An introduction to the adjoint sensitivity equations
[can be found in this documentation](https://computation.llnl.gov/casc/nsde/pubs/cvs_guide.pdf).
A project could focus on the development of high performance adjoint sensitivity
calculation techniques with checkpointing and other memory reduction techniques
for use on partial differential equation systems.

**Recommended Skills**: An understanding of how to use DifferentialEquations.jl
to solve equations.

**Expected Results**: Efficient functions for performing global and adjoint
sensitivity analysis.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Discretizations of partial differential equations

There are two ways to approach libraires for partial differential equations (PDEs):
one can build "toolkits" which enable users to discretize any PDE but require knowledge
of numerical PDE methods, or one can build "full-stop" PDE solvers for specific
PDEs. There are many different ways solving PDEs could be approached, and here
are some ideas for potential projects:

1. Enhancement of existing tools for discretizing PDEs. The finite differencing
   (FDM) library [DiffEqOperators.jl](https://github.com/JuliaDiffEq/DiffEqOperators.jl)
   could be enahnced to allow non-uniform grids or composition of operators. The
   finite element method (FEM) library [FEniCS.jl](https://github.com/JuliaDiffEq/FEniCS.jl)
   could wrap more of the FEniCS library.
2. Full stop solvers of common fluid dynamical equations, such as diffusion-advection-
   convection equations, or of hyperbolic PDEs such as the Hamilton-Jacobi-Bellman
   equations would be useful to many users.
3. Using stochastic differential equation (SDE) solvers to efficiently (and
   highly parallel) approximate certain PDEs.
4. Development of ODE solvers for more efficiently solving specific types of
   PDE discretizations. See the "Native Julia solvers for ordinary differential
   equations" project.

**Recommended Skills**: Background knowledge in numerical methods for solving
differential equations. Some basic knowledge of PDEs, but mostly a willingness
to learn and a strong understanding of calculus and linear algebra.

**Expected Results**: A production-quality PDE solver package for some common PDEs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)
