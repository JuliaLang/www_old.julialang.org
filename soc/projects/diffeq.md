---
layout: default
title:  DiffEq Projects – Summer of Code
---

# {{ page.title }}

{% include toc.html %}

## Efficient DiffEq-Specific Differentiation Tooling

Methods for solving stiff differential equations and differential algebraic
equations (DAEs) are composed of similar calculus objects: gradients, Jacobians,
etc.  However, not only are these objects common, but there are also very common
use patterns. For example, the quantity (M - gamma*J)^(-1), (where M is a mass
matrix, J is the Jacobian, and gamma is a constant), is found in Rosenbrock
methods, Newton solvers for implicit Runge-Kutta methods, and update equations
for implicit multistep methods.

However, to make these efficient and cover a large array of problems we will
need to develop new tools for calculating such Jacobians. In many cases, like
discretizations of PDEs, the user may know in advance that the Jacobian has a
banded or sparse structure and can provide such a structure. In these cases,
the calculation can be made much more efficient by using this information to
calculate a low fewer function calls. Additionally, none of the current
differentiation tools in Julia support complex numbers, which limits the
applicability of stiff solvers to PDEs from quantum mechanics like Schrodinger's
equation.

Students who take on this project will encounter and utilize many of the core tools for scientific computing in Julia, and the result will be a very useful library for all differential equation solvers.

**Recommended Skills**: Familiarity with multivariable calculus (Jacobians).

**Expected Results**: A high-performance backend library for native differential
equation solvers.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Natural syntax parsing and symbolic transformations of differential equations

[ParameterizedFunctions.jl](https://github.com/JuliaDiffEq/ParameterizedFunctions.jl)
is a component of the JuliaDiffEq ecosystem that allows for users to define differential
equations in a natural syntax (with parameters). The benefits of this setup are threefold:

- The existence of parameters allows for optimization / machine learning techniques
  to be applied to and learn parameters from data.
- The natural syntax allows [DifferentialEquations.jl Online](http://app.juliadiffeq.org/)
  to have a user-friendly programming-free frontend.
- The setup allows for [SymEngine.jl](https://github.com/symengine/SymEngine.jl)
  to symbolically calculate various mathematical objects to speed up the solvers.

However, the macros are currently only able to parse ordinary differential
equations (ODEs) and stochastic differential equations (SDEs). An extension to
the language and parser will need to be introduced in order to handle
differential algebraic equations (DAEs) and delay differential equations (DDEs).
In addition, symbolic enhancements could be applied to automatically lower the
index of the DAEs and transform delay equations into larger systems of ODEs,
greatly increasing the amount of equations which can be easily solved. Finally,
this improved parser can be used to develop new pages for DifferentialEquations.jl
Online for solving DAEs and DDEs.

**Recommended Skills**: Some previous knowledge of parsing.

**Expected Results**: An improved parser within the macro which supports delay
and algebraic differential equations.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Native Julia solvers for ordinary differential equations and algebraic differential equations

Julia needs to have a full set of ordinary differential equations (ODE) and
algebraic differential equation (DAE) solvers, as they are vital for numeric
programming. There are many advantages to having a native Julia implementation,
including the ability to use Julia-defined types (for things like arbitrary
precision) and composability with other packages. A library of methods can be
built for the common interface, seamlessly integrating with the other available
methods. Possible families of methods to implement are:

- High Order Exponential Runge-Kutta Methods, including efficient expmv methods
- Implicit-Explicit (IMEX) Runge-Kutta Methods

**Recommended Skills**: Background knowledge in numerical analysis, numerical
linear algebra, and the ability to write fast code.

**Expected Results**: A production-quality ODE/DAE solver package.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Tools for global and adjoint sensitivity analysis

Global Sensitivity Analysis is a popular tool to assess the affect that parameters
have on a differential equation model. Global Sensitivity Analysis tools can be
much more efficient than Local Sensitivity Analysis tools, and give a better
view of how parameters affect the model in a more general sense. Julia currently
has an implementation Local Sensitivity Analysis, but there is no method for Global
Sensitivity Analysis. The goal of this project would be to implement methods like
the Morris method in [DiffEqSensitivity.jl](https://github.com/JuliaDiffEq/DiffEqSensitivity.jl) which
can be used with any differential equation solver on the common interface.

In addition, adjoint sensitivity analysis is a more efficient method than
standard local sensitivity analysis when the number of parameters is large.
It is the differential equations extension of "backpropagation" and is used
in many other domains like parameter estimation as part of the optimization
process.

**Recommended Skills**: An understanding of how to use DifferentialEquations.jl
to solve equations.

**Expected Results**: Efficient functions for performing global and adjoint
sensitivity analysis.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Machine learning tools for classification of qualitative traits of differential equation solutions

Machine learning has become a popular tool for understanding data, but scientists
typically want to use this data to better understand their differential
equation-based models. Differential equations usually have parameters which are
unknown but when changed can cause qualitative differences to the results. By
pairing machine learning tooling with data generation from differential equation
models, tools can be developed which can classify when behaviors are to be
expected in the solution.

**Recommended Skills**: Background knowledge of standard machine learning
techniques and the usage of DifferentialEquations.jl

**Expected Results**: Tools for easily classifying parameters using machine
learning tooling for users inexperienced with machine learning.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Discretizations of partial differential equations

One of the major uses for differential equations solvers is for partial
differential equations (PDEs). PDEs are solved by discretizing to create ODEs
which are then solved using ODE solvers. However, in many cases a good
understanding of the PDEs are required to perform this discretization and
minimize the error. The purpose of this project is to produce a library with
common PDE discretizations to make it easier for users to solve common PDEs.

The core of this project will be to build tooling that can be used to make it
easy to discretize any partial differential equation in an efficient manner.
This will be used to build a finite difference solver for the Heat Equation, a
canonical problem in many fields, which can be profiled and benchmarked to
ensure speed and accuracy. From there, the student can use these tools to take
other canoncial partial differential equations, doing things such as:

1) Discretizations of fluid dynamical equations, such as diffusion-advection-
   convection equations.
2) Extensions of discretizations to stochastic (random) partial differential
   equations.
3) Tackling more efficiency issues: full utilization of operator linearity,
   split operator and IMEX (implicit-explicit) discretizations.
4) Discretizations of hyperbolic PDEs such as the Hamilton-Jacobi-Bellman
  equations.
5) Using stochastic differential equation (SDE) solvers to efficiently (and
   highly parallel) approximate certain PDEs.

**Recommended Skills**: Background knowledge in numerical methods for solving
differential equations. Some basic knowledge of PDEs, but mostly a willingness
to learn and a strong understanding of calculus and linear algebra.

**Expected Results**: A production-quality PDE solver package for some common PDEs.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)

## Stiffness Detection and Automatic Switching Algorithms

Stiffness is a phenomena in differential equations which requires implicit methods
in order to be efficiently solved. However, implicit methods are inherently
more costly and thus inefficient when they are not needed. This is an issue
because many problems are not always stiff, and instead switch from stiff
and nonstiff modes. The purpose of this project would be to develop functionality
for detecting stiffness during integration and testing algorithms for automatic
switching between appropriate algorithms. These would not only be more efficient
on a large class of problems, but also decrease the cognative burden on the
user by being efficient for a large class of algorithms and likely become the
new default methods.

**Recommended Skills**: Background knowledge in numerical methods for solving
differential equations. The student is expected to already be familiar with
the concept of stiffness in ODEs, but not necessarily an expert.

**Expected Results**: Implementation of a trait-based engine for
algorithm-specific stiffness metrics, and new algorithms which implement
specific switching strategies.

**Mentors**: [Chris Rackauckas](https://github.com/ChrisRackauckas)
