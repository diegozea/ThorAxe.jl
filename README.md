# ThorAxe.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/dev/)
[![Build Status](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/DiegoZea/ThorAxe.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/DiegoZea/ThorAxe.jl)

`ThorAxe.jl` is a lightweight Julia helper around the Python
[`thoraxe`](https://pypi.org/project/thoraxe/) command-line tool.
[CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) provisions a Python 3.7
environment with `thoraxe==0.8.3`, keeping versions aligned.

## Getting started

```julia
pkg> add https://github.com/DiegoZea/ThorAxe.jl
julia> using ThorAxe

# Run thoraxe with the default CLI behaviour
julia> ThorAxe.thoraxe("./input", "./output"; maxtsl = 3)

# Build the command line parts if you need to inspect them
julia> ThorAxe._push_option!(String["thoraxe"], (
           "--inputdir" => "./input",
           "--outputdir" => "./output",
           "--maxtsl" => 3,
           "--minlen" => 4,
       ))
["thoraxe", "--inputdir", "./input", "--outputdir", "./output", "--maxtsl", "3", "--minlen", "4"]
```

Positional arguments correspond to `inputdir` and `outputdir`. Other keywords mirror the flags from `thoraxe --help` (minus the leading `--`) and default to the same values. Booleans behave like switches and you can always reuse `_push_option!` to inspect or tweak the generated command before execution.

The first invocation triggers CondaPkg to solve and download the managed
environment. Subsequent calls reuse the cached installation.
