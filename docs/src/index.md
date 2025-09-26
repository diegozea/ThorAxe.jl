
```@meta
CurrentModule = ThorAxe
```

# ThorAxe.jl

`ThorAxe.jl` is a thin Julia wrapper around the Python
[`thoraxe`](https://pypi.org/project/thoraxe/) command-line interface.
[CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) provisions a Python 3.7
environment with `thoraxe==0.8.3`, keeping the versions aligned.

## Getting started

```julia
pkg> add https://github.com/DiegoZea/ThorAxe.jl
julia> using ThorAxe

# Execute thoraxe with custom overrides
julia> ThorAxe.thoraxe("data/in", "data/out"; maxtsl = 5, no_movements = true)

# Inspect the command parts if needed
julia> ThorAxe._push_option!(String["thoraxe"], (
           "--inputdir" => "data/in",
           "--outputdir" => "data/out",
           "--maxtsl" => 5,
           "--no_movements" => true,
       ))
["thoraxe", "--inputdir", "data/in", "--outputdir", "data/out", "--maxtsl", "5", "--no_movements"]
```

Positional arguments map to the CLI defaults (`inputdir`, `outputdir`). Other
keywords mirror the `thoraxe --help` flags (minus the leading `--`) and share the
same default values. Booleans behave like switches, vectors are joined with
commas, and you can append raw fragments through `extra_args`.

## API reference

```@docs
ThorAxe.thoraxe
```
