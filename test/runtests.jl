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

    @testset "Basic functionality" begin
        n = 3
        m = reshape(1:n^2, n, n)
        map = GridMap(m, (lower=[1, 1], upper=2 .* [n, n] .- 1))

        @test all(res(map) .== [2.0, 2.0])

        a = [CartesianIndex(i, j) for i in 1:n, j in 1:n]
        b = cellToPoint.([CartesianIndex(i, j) for i in 1:n, j in 1:n], Ref(map))
        c = pointToCell.(b, Ref(map))
        @test a == c

        axs, points = generateAxes(map)
        @test b == points

        # inside and boundaries
        @test pointToCell([1, 1], map) == CartesianIndex(1, 1)
        @test pointToCell([1.99, 1.99], map) == CartesianIndex(1, 1)
        @test pointToCell([2.01, 2.01], map) == CartesianIndex(2, 2)
        @test pointToCell([3, 3], map) == CartesianIndex(2, 2)
        @test pointToCell([3.99, 3.99], map) == CartesianIndex(2, 2)
        @test pointToCell([4.01, 4.01], map) == CartesianIndex(3, 3)
        @test pointToCell([5, 5], map) == CartesianIndex(3, 3)
    end
end
