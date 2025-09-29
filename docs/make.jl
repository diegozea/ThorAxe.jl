using ThorAxe
using Documenter

DocMeta.setdocmeta!(ThorAxe, :DocTestSetup, :(using ThorAxe); recursive=true)

makedocs(;
    modules=[ThorAxe],
    authors="Diego Javier Zea",
    sitename="ThorAxe.jl",
    format=Documenter.HTML(;
        canonical="https://diegozea.github.io/ThorAxe.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/diegozea/ThorAxe.jl.git",
    branch="gh-pages",
    devbranch="main",
)
