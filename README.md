# ThorAxe.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/dev/)
[![Build Status](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/DiegoZea/ThorAxe.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/DiegoZea/ThorAxe.jl)

`ThorAxe.jl` is a lightweight Julia helper around the Python
[`thoraxe`](https://pypi.org/project/thoraxe/) command-line tool.
[CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) provisions a Python 3.7
environment with `thoraxe==0.8.3`, so invoking `ThorAxe.thoraxe` works without manual Python setup.

## Getting Started

```julia
pkg> add https://github.com/DiegoZea/ThorAxe.jl
julia> using ThorAxe

# Run ThorAxe with the default settings (the current directory is used for both input and output)
julia> ThorAxe.thoraxe()
```

The positional arguments of the `thoraxe` function correspond to `inputdir` and `outputdir`. 
Both default to the current directory, which you can check with `pwd()`. You can also use 
keyword arguments to override any of the CLI options or flags (see the `thoraxe` help 
with `?thoraxe` in the Julia REPL for the complete list).

On the first run, CondaPkg resolves and downloads the managed environment, which may take 
some time. Subsequent runs reuse the cached installation and are faster.

