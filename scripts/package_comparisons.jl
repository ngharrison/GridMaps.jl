# Note: this file is for interactive testing and these other packages are not
# included in this environment.

#*
using Random; Random.seed!(0); # for repeatability

n = 100
data = rand(n,n);
a = range(0, 1, n)
x = [.2, .75]; # a location/point
x2 = rand(2)

#*
using GridMaps

bnds = (
    lower = [0.0, 0.0],
    upper = [1.0, 1.0]
);
gmap = GridMap(data, bnds)

@time gmap(x)

#*
using AxisKeys

ka = KeyedArray(data; x=a, y=a)

@time ka(Near.(x)...)

#*
using DimensionalData

da = DimArray(data, (X(a), Y(a)))

@time da[Near.(x)...]

#*
using Interpolations

# using scaled b-splines with constant base = nearest-neighbor
itp = interpolate(data, BSpline(Constant()))
sitp = scale(itp, (a, a))
@time sitp(x...)

itp = interpolate(data, BSpline(Linear()))
sitp = scale(itp, (a, a))
@time sitp(x...)

#*
using GridInterpolations

# only linear, no nearest-neighbor
grid = RectangleGrid(a,a)
@time GridInterpolations.interpolate(grid, data, x)

sgrid = SimplexGrid(a,a)
@time GridInterpolations.interpolate(sgrid, data, x)

#*
using LocalFunctionApproximation

using GridInterpolations
grid = RectangleGrid(a,a)
gifa = LocalGIFunctionApproximator(grid, vec(data))

using NearestNeighbors, StaticArrays
points = vec(SVector.(Iterators.product(a,a)))
nntree = KDTree(points)
k = 1
knnfa = LocalNNFunctionApproximator(nntree, points, k)

@time compute_value(gifa, x)
@time compute_value(knnfa, x)
