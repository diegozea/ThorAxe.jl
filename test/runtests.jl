
using Test
using ThorAxe

function build_cmd_parts(inputdir, outputdir; kwargs...)
    # Mirror the keyword handling in `thoraxe` without spawning the external tool.
    defaults = ThorAxe.THORAXE_DEFAULTS
    flags = (
        "--inputdir" => inputdir,
        "--outputdir" => outputdir,
        "--aligner" => get(kwargs, :aligner, defaults.aligner),
        "--maxtsl" => get(kwargs, :maxtsl, defaults.maxtsl),
        "--minlen" => get(kwargs, :minlen, defaults.minlen),
        "--mingenes" => get(kwargs, :mingenes, defaults.mingenes),
        "--mintranscripts" => get(kwargs, :mintranscripts, defaults.mintranscripts),
        "--coverage" => get(kwargs, :coverage, defaults.coverage),
        "--identity" => get(kwargs, :identity, defaults.identity),
        "--gapopen" => get(kwargs, :gapopen, defaults.gapopen),
        "--gapextend" => get(kwargs, :gapextend, defaults.gapextend),
        "--rescue_unaligned_subexons" => get(kwargs, :rescue_unaligned_subexons, defaults.rescue_unaligned_subexons),
        "--padding" => get(kwargs, :padding, defaults.padding),
        "--phylosofs" => get(kwargs, :phylosofs, defaults.phylosofs),
        "--no_movements" => get(kwargs, :no_movements, defaults.no_movements),
        "--no_disintegration" => get(kwargs, :no_disintegration, defaults.no_disintegration),
        "--plot_chimerics" => get(kwargs, :plot_chimerics, defaults.plot_chimerics),
        "--specieslist" => get(kwargs, :specieslist, defaults.specieslist),
        "--canonical_criteria" => get(kwargs, :canonical_criteria, defaults.canonical_criteria),
    )
    parts = String["thoraxe"]
    # Reuse the production helper so the test fails if we change the CLI logic.
    ThorAxe._push_option!(parts, flags)
end

@testset "default command" begin
    parts = build_cmd_parts(".", "")
    # Expect the same ordering exposed by `thoraxe --help`.
    expected = [
        "thoraxe",
        "--inputdir", ".",
        "--outputdir", "",
        "--aligner", "ProGraphMSA",
        "--maxtsl", "3",
        "--minlen", "4",
        "--mingenes", "1",
        "--mintranscripts", "2",
        "--coverage", "80.0",
        "--identity", "30.0",
        "--gapopen", "-10",
        "--gapextend", "-1",
        "--padding", "10",
        "--canonical_criteria", ThorAxe.THORAXE_DEFAULTS.canonical_criteria,
    ]
    @test parts == expected
end

@testset "overrides" begin
    parts = build_cmd_parts("/data/in", "/data/out";
        maxtsl = 5,
        coverage = 75.5,
        no_movements = true,
        specieslist = ["human", "mouse"],
    )
    # Spot-check a mix of numerical, boolean, and vector arguments.
    @test parts[findfirst(==("--inputdir"), parts) + 1] == "/data/in"
    @test parts[findfirst(==("--outputdir"), parts) + 1] == "/data/out"
    @test parts[findfirst(==("--maxtsl"), parts) + 1] == "5"
    @test parts[findfirst(==("--coverage"), parts) + 1] == "75.5"
    @test "--no_movements" in parts
    idx = findfirst(==("--specieslist"), parts)
    @test idx !== nothing
    @test parts[idx + 1] == "human,mouse"
end

@testset "boolean off" begin
    parts = build_cmd_parts(".", "";
        no_movements = false,
        phylosofs = false,
    )
    # Boolean flags should drop entirely when false.
    @test !("--no_movements" in parts)
    @test !("--phylosofs" in parts)
end
