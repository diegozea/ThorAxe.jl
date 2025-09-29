# ThorAxe.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/dev/)
[![Build Status](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/DiegoZea/ThorAxe.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/DiegoZea/ThorAxe.jl)

`ThorAxe.jl` is a lightweight Julia helper around the Python
[`thoraxe`](https://pypi.org/project/thoraxe/) command-line tool.
[CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) provisions a Python 3.7
environment with `thoraxe==0.8.3`, so invoking `ThorAxe.thoraxe` works without manual Python setup.

## Getting started

```julia
pkg> add https://github.com/DiegoZea/ThorAxe.jl
julia> using ThorAxe

# Run thoraxe with the default CLI behaviour (current directory inputs reused)
julia> ThorAxe.thoraxe()

# Override CLI flags directly from Julia
julia> ThorAxe.thoraxe("./input"; mintranscripts = 4,
                               specieslist = ["homo_sapiens", "mus_musculus"],
                               canonical_criteria = ["TranscriptLength", "TSL"])

# Build the command line parts if you need to inspect or tweak them
julia> ThorAxe._push_option!(String["thoraxe"], (
           "--inputdir" => "./input",
           "--mintranscripts" => 4,
           "--specieslist" => ["homo_sapiens", "mus_musculus"],
       ))
["thoraxe", "--inputdir", "./input", "--mintranscripts", "4",
 "--specieslist", "homo_sapiens,mus_musculus"]
```

Positional arguments correspond to `inputdir` and `outputdir` (defaulting to
the current directory). Runtime keywords mirror the flags from `thoraxe --help`
(without the leading `--`) and default to the values recorded in
`ThorAxe.THORAXE_DEFAULTS`. Booleans behave like switches,
numbers are passed as-is, and vectors are joined with commas to match the CLI
expectations. The default canonical criteria are
`"MinimumConservation,MinimumTranscriptWeightedConservation,MeanTranscriptWeightedConservation,TranscriptLength,TSL"`.

The first invocation triggers CondaPkg to solve and download the managed
environment. Subsequent calls reuse the cached installation.
