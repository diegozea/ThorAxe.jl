```@meta
CurrentModule = ThorAxe
```

# ThorAxe.jl

`ThorAxe.jl` is a thin Julia wrapper around the Python
[`thoraxe`](https://pypi.org/project/thoraxe/) command-line interface.
[CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) provisions a Python 3.7
environment with `thoraxe==0.8.3`, so you can invoke the CLI directly from
Julia.

## Getting started

```julia
pkg> add https://github.com/DiegoZea/ThorAxe.jl
julia> using ThorAxe

# Run thoraxe using the defaults (current directory reused)
julia> ThorAxe.thoraxe()

# Override CLI flags directly from Julia
julia> ThorAxe.thoraxe("data/in"; mintranscripts = 3,
                               specieslist = ["homo_sapiens", "mus_musculus"],
                               canonical_criteria = ["TranscriptLength", "TSL"])
```

Positional arguments map to the CLI defaults (`inputdir`, `outputdir`). Runtime
keywords mirror the `thoraxe --help` flags (minus the leading `--`) and use the
values recorded in `ThorAxe.THORAXE_DEFAULTS`. Booleans behave like switches,
numbers are forwarded as-is, and vectors are joined with commas to match the CLI
expectations. The default canonical ordering is stored in
`ThorAxe.DEFAULT_CANONICAL_CRITERIA` (a comma-separated string).

## Implementation details

The helper `_push_option!` powers the CLI assembly by appending flag/value pairs
while respecting unset keywords. You can call it directly if you need to inspect
the command that will be executed:

```julia
julia> ThorAxe._push_option!(String["thoraxe"], (
           "--inputdir" => "data/in",
           "--mintranscripts" => 3,
           "--specieslist" => ["homo_sapiens", "mus_musculus"],
       ))
["thoraxe", "--inputdir", "data/in", "--mintranscripts", "3",
 "--specieslist", "homo_sapiens,mus_musculus"]
```

## API reference

```@docs
ThorAxe.thoraxe
```
