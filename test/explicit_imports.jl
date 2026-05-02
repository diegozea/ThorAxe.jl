@testitem "explicit imports lint" begin
    using ThorAxe
    import ExplicitImports

    ExplicitImports.test_explicit_imports(ThorAxe; all_qualified_accesses_are_public = false)
end
