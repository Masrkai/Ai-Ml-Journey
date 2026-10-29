# AI, Machine Learning & Data Science Journey in Julia

Welcome to my repository documenting an extensive journey through Artificial Intelligence, Machine Learning, and Data Science, implemented entirely in **Julia**.

## Why Julia for AI, ML, and Data Science?

While Python has historically been the lingua franca for data science and machine learning, Julia was designed from the ground up to address the **"two-language problem"**—the practice of prototyping in a high-level dynamic language (like Python/R) and rewriting in a high-performance compiled language (like C++/Fortran/C).

### Key Advantages of Julia in this Journey:

1. **High Performance**: Julia compiles to native machine code via LLVM, matching or exceeding C/C++ speeds without sacrificing expressive, high-level syntax.
2. **Multiple Dispatch**: Julia's type system allows functions to be specialized on combinations of argument types, leading to elegant, extensible, and modular mathematical and algorithmic code.
3. **Metaprogramming & Macros**: Powerful metaprogramming capabilities enable domain-specific languages (DSLs) and seamless syntax transformations, ideal for neural network definition and mathematical modeling.
4. **Composability**: Julia packages are designed to compose naturally. For example, automatic differentiation (`Zygote.jl`), differential equations (`DifferentialEquations.jl`), and optimization libraries (`JuMP.jl`) work together seamlessly even across libraries written by different authors.
5. **Modern ML & Data Ecosystem**: Robust and high-performance libraries such as:
   - **DataFrames.jl**: Fast and expressive tabular data manipulation.
   - **Flux.jl**: Pure Julia deep learning library that is hackable and transparent.
   - **MLJ.jl**: A machine learning workbench providing a unified interface to hundreds of models.
   - **Plots.jl / Makie.jl**: Powerful visualization backends.

---

## Roadmap & Structure

The repository follows a progressive roadmap from foundational exploratory data analysis to advanced distributed machine learning and MLOps systems. Each project is housed under `projects/` with its own environment management (`Project.toml`), documentation, and implementation.

Refer to [`docs/roadmap.md`](docs/roadmap.md) for the complete 22-step curriculum.
