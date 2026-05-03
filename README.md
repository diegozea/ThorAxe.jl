# ThorAxe.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://DiegoZea.github.io/ThorAxe.jl/dev/)
[![Build Status](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/DiegoZea/ThorAxe.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Aqua QA](https://juliatesting.github.io/Aqua.jl/dev/assets/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![Coverage](https://codecov.io/gh/DiegoZea/ThorAxe.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/DiegoZea/ThorAxe.jl)

`ThorAxe.jl` is a lightweight Julia helper around the Python
[`thoraxe`](https://pypi.org/project/thoraxe/) command-line programs.
ThorAxe identifies orthologous exonic regions, called s-exons, from
transcripts of orthologous genes and uses them to study conservation of
alternative splicing.

The usual ThorAxe workflow is:

1. `transcript_query`: download transcript and exon information from Ensembl.
2. `thoraxe`: identify s-exons and create the ThorAxe output tables.

`add_transcripts` is available for the less common case where you want to add custom transcripts that are not available from Ensembl before running
`thoraxe` into the `transcript_query` output.

[CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) provisions a Python 3.7
environment with `thoraxe==0.8.3`, so these Julia functions work without manual Python setup.

## Getting Started

```julia
pkg> add https://github.com/DiegoZea/ThorAxe.jl
julia> using ThorAxe

# Download the Ensembl data needed by ThorAxe for MAPK8 in human and mouse.
julia> transcript_query("MAPK8"; specieslist = ["homo_sapiens", "mus_musculus"])

# Run ThorAxe on the gene folder created by transcript_query.
julia> thoraxe("MAPK8")
```

Gene names can have synonyms or clashes, so using an Ensembl stable ID is safer
when you know it:

```julia
julia> transcript_query("ENSG00000107643"; specieslist = ["homo_sapiens", "mus_musculus"])
```

`transcript_query` creates a gene directory containing an `Ensembl/` folder.
`thoraxe(inputdir)` expects that gene directory as input. By default, ThorAxe
writes its output in the input directory; pass a second positional argument to
write somewhere else:

```julia
julia> thoraxe("MAPK8", "MAPK8_thoraxe")
```

## Optional Custom Transcripts

If you have transcripts that are not available from Ensembl, add them after
`transcript_query` and before `thoraxe`:

```julia
julia> transcript_query("MAPK8")
julia> add_transcripts("user_transcripts.csv", "MAPK8/Ensembl")
julia> thoraxe("MAPK8")
```

The input CSV for `add_transcripts` must describe complete transcript/exon
annotations in the format expected by the upstream ThorAxe CLI as described in the 
[Python documentation](https://phylosofs-team.github.io/thoraxe/programs/add_transcripts.html).

## Options

The positional arguments of the Julia functions correspond to the Python CLI
positional arguments. Keyword arguments map to CLI options and flags:

```julia
julia> transcript_query("MAPK8"; species = "homo_sapiens", orthology = "1:1")
julia> thoraxe("MAPK8"; phylosofs = true, plot_chimerics = true)
```

Use `?transcript_query`, `?thoraxe`, and `?add_transcripts` in the Julia REPL for
the complete Julia API, or see the upstream
[ThorAxe documentation](https://phylosofs-team.github.io/thoraxe/index.html) for
the Python command-line reference.

On the first run, CondaPkg resolves and downloads the managed environment, which may take
some time. Subsequent runs reuse the cached installation and are faster.

## Citation

If you use `ThorAxe.jl` in scientific work, please cite the ThorAxe paper:

Zea DJ, Laskina S, Baudin A, Richard H, Laine E. **Assessing conservation of
alternative splicing with evolutionary splicing graphs.** *Genome Research* 31(8):
1462-1473 (2021). https://doi.org/10.1101/gr.274696.120

Machine-readable citation metadata is available in `CITATION.cff` and
`CITATION.bib`.
