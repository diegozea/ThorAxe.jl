
using Test
using ThorAxe

function build_cmd_parts(inputdir, outputdir; kwargs...)
    # Mirror the keyword handling in `thoraxe` without spawning the external tool.
    flags = (
        "--inputdir" => inputdir,
        "--outputdir" => outputdir,
        "--aligner" => get(kwargs, :aligner, ThorAxe.THORAXE_DEFAULTS.aligner),
        "--maxtsl" => get(kwargs, :maxtsl, ThorAxe.THORAXE_DEFAULTS.maxtsl),
        "--minlen" => get(kwargs, :minlen, ThorAxe.THORAXE_DEFAULTS.minlen),
        "--mingenes" => get(kwargs, :mingenes, ThorAxe.THORAXE_DEFAULTS.mingenes),
        "--mintranscripts" => get(kwargs, :mintranscripts, ThorAxe.THORAXE_DEFAULTS.mintranscripts),
        "--coverage" => get(kwargs, :coverage, ThorAxe.THORAXE_DEFAULTS.coverage),
        "--identity" => get(kwargs, :identity, ThorAxe.THORAXE_DEFAULTS.identity),
        "--gapopen" => get(kwargs, :gapopen, ThorAxe.THORAXE_DEFAULTS.gapopen),
        "--gapextend" => get(kwargs, :gapextend, ThorAxe.THORAXE_DEFAULTS.gapextend),
        "--rescue_unaligned_subexons" => get(kwargs, :rescue_unaligned_subexons, ThorAxe.THORAXE_DEFAULTS.rescue_unaligned_subexons),
        "--padding" => get(kwargs, :padding, ThorAxe.THORAXE_DEFAULTS.padding),
        "--phylosofs" => get(kwargs, :phylosofs, ThorAxe.THORAXE_DEFAULTS.phylosofs),
        "--no_movements" => get(kwargs, :no_movements, ThorAxe.THORAXE_DEFAULTS.no_movements),
        "--no_disintegration" => get(kwargs, :no_disintegration, ThorAxe.THORAXE_DEFAULTS.no_disintegration),
        "--plot_chimerics" => get(kwargs, :plot_chimerics, ThorAxe.THORAXE_DEFAULTS.plot_chimerics),
        "--specieslist" => get(kwargs, :specieslist, ThorAxe.THORAXE_DEFAULTS.specieslist),
        "--canonical_criteria" => get(kwargs, :canonical_criteria, ThorAxe.THORAXE_DEFAULTS.canonical_criteria),
        "--version" => get(kwargs, :version, ThorAxe.THORAXE_DEFAULTS.version),
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
