@testitem "aligner checksum mismatch reports expected error" begin
    using ThorAxe

    bad_aligner = tempname()
    write(bad_aligner, "not ProGraphMSA")

    err = try
        ThorAxe._verify_aligner(bad_aligner, ThorAxe._aligner_filename())
        nothing
    catch e
        e
    finally
        isfile(bad_aligner) && rm(bad_aligner; force = true)
    end

    @test err isa ErrorException
    @test occursin("checksum mismatch", sprint(showerror, err))
end

@testitem "get_aligner downloads missing and replaces corrupt executable" begin
    using ThorAxe

    aligner_dir = mktempdir()
    expected_aligner = ThorAxe._aligner_path(aligner_dir)
    filename = ThorAxe._aligner_filename()

    aligner = ThorAxe.get_aligner(aligner_dir)

    @test aligner == expected_aligner
    @test isfile(aligner)
    @test readdir(aligner_dir) == [ThorAxe.ALIGNER_NAME]
    @test ThorAxe._verify_aligner(aligner, filename) === nothing
    @test (stat(aligner).mode & 0o111) != 0

    write(aligner, "corrupt")
    replaced_aligner = ThorAxe.get_aligner(aligner_dir)

    @test replaced_aligner == expected_aligner
    @test isfile(replaced_aligner)
    @test readdir(aligner_dir) == [ThorAxe.ALIGNER_NAME]
    @test ThorAxe._verify_aligner(replaced_aligner, filename) === nothing
    @test (stat(replaced_aligner).mode & 0o111) != 0
end

@testitem "space-safe aligner path reuses cached shim" begin
    using ThorAxe

    shim_dir = mktempdir()
    previous_shim = isassigned(ThorAxe.ALIGNER_SHIM_PATH) ? ThorAxe.ALIGNER_SHIM_PATH[] : nothing
    cached_shim = joinpath(shim_dir, ThorAxe.ALIGNER_NAME)
    write(cached_shim, "cached shim")
    chmod(cached_shim, 0o755)

    space_dir = mktempdir(; prefix = "thor axe ")
    space_aligner = joinpath(space_dir, ThorAxe.ALIGNER_NAME)
    write(space_aligner, "alternate aligner")
    chmod(space_aligner, 0o755)

    try
        ThorAxe.ALIGNER_SHIM_PATH[] = cached_shim

        @test ThorAxe._space_safe_aligner_path(space_aligner) == cached_shim
    finally
        ThorAxe.ALIGNER_SHIM_PATH[] = something(previous_shim, joinpath(shim_dir, "missing-shim"))
    end
end
