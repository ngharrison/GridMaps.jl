using GridMaps
using Test
using Aqua
using JET

@testset "GridMaps.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(GridMaps)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(GridMaps; target_defined_modules = true)
    end
    # Write your tests here.
end
