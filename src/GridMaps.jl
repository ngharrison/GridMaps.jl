module GridMaps

using DocStringExtensions: TYPEDSIGNATURES, TYPEDFIELDS, TYPEDEF, EXPORTS

export GridMap, randomPoint, res, pointToCell, cellToPoint,
       generateAxes, Bounds, getBounds

"""
$(TYPEDEF)

The bounds of the region. Consists of the lower and upper bounds, each a list of
floating-point values.
"""
const Bounds = @NamedTuple begin
    lower::Vector{Float64}
    upper::Vector{Float64}
end

"""
A general type for holding multi-dimensional data (usually a matrix) along with
associated dimension bounds. It's main purpose is to handle the conversion
between world coordinates and grid indices internally. Converting between the
two representations treats rows as the first variable (x-axis), columns as
the second (y-axis), and so on.

Its typical use is to act as a 2D map of some value that can be sampled. A GridMap
will return the value of the grid cell that a given point falls within. In other
words, the map value is constant within each cell. One can also think of this as
a nearest-neighbor approximation.

Each cell index is treated as the center of its cell. Thus the map's lower
bounds are at the center of the first cell and the map's upper bounds are at the
center of the last cell.

Also made to function directly like a built-in N-dimensional array by sub-typing
and implementing the base methods.

Fields:
$(TYPEDFIELDS)

A GridMap is constructed by passing the multi-dimensional array of data and the
dimension bounds. If no bounds are passed, they default to zeros for lower and
ones for upper.

# Examples
```julia
data = reshape(1:25, 5, 5)
bounds = (
    lower = [0.0, 0.0],
    upper = [1.0, 1.0]
)
gmap = GridMap(data, bounds)
gmap2 = GridMap(data) # bounds will be zero to one
```

"""
struct GridMap{T1<:Any, N<:Any, A<:AbstractArray{T1, N}, T2<:Real} <: AbstractArray{T1, N}
    "N-dimensional array of data"
    data::A
    "vectors of lower and upper bounds, defaults to zeros and ones"
    bounds::Bounds

    function GridMap(data, bounds)
        length(bounds.lower) == length(bounds.upper) == ndims(data) ||
            throw(DimensionMismatch("lengths of bounds don't match data dimensions"))
        new{eltype(data), ndims(data), typeof(data), eltype(bounds.lower)}(data, bounds)
    end
end

function GridMap(data::AbstractArray{<:Any})
    bounds = (
        lower=zeros(ndims(data)),
        upper=ones(ndims(data))
    )
    return GridMap(data, bounds)
end

"""
A variable of GridMap type can itself be called to retrieve map values. This
method accepts a single vector (the location), returns a scalar (the value at
that point).

# Examples
```julia
data = reshape(1:25, 5, 5)
gmap = GridMap(data)

x = [.2, .75]
val = m(x) # returns the value at a single 2D point
val2 = m[1,4] # can also use as if it's just the underlying matrix
```
"""
function (gmap::GridMap)(x)
    checkBounds(x, gmap)
    gmap[pointToCell(x, gmap)]
end

# make a map behave like an array
Base.size(m::GridMap) = size(m.data)
Base.IndexStyle(::Type{<:GridMap}) = IndexLinear()
Base.getindex(m::GridMap, i::Integer) = m.data[i]
Base.setindex!(m::GridMap, v, i::Integer) = (m.data[i] = v)

# change display
function Base.show(io::IO, gmap::GridMap{T1}) where T1
    print(io, "GridMap{$T1} [$(gmap.bounds.lower), $(gmap.bounds.upper)]")
end
function Base.show(io::IO, ::MIME"text/plain", gmap::GridMap{T1}) where T1
    print(io, "GridMap{$T1} [$(gmap.bounds.lower), $(gmap.bounds.upper)]:\n")
    show(io, "text/plain", gmap.data)
end

"""
$(TYPEDSIGNATURES)

Generates a random point within the map bounds. Returns a tuple of the location
and its value.
"""
function Base.rand(gmap::GridMap)
    x = randomPoint(gmap)
    return x, gmap(x)
end

"""
$(TYPEDSIGNATURES)

Generates a random point in the map. Returns the location.
"""
function randomPoint(gmap::GridMap)
    dif = (gmap.bounds.upper .- gmap.bounds.lower)
    return gmap.bounds.lower .+ rand(ndims(gmap)) .* dif
end

"""
Get the lower and upper bounds of the map.
"""
getBounds(gmap::GridMap) = gmap.bounds

"""
$(TYPEDSIGNATURES)

Function emits error if location is outside of map bounds.

# Examples
```julia
x = [.2, .75]
data = reshape(1:25, 5, 5)
gmap = GridMap(data)
checkBounds(x, gmap) # no error thrown
```
"""
function checkBounds(x, gmap::GridMap)
    length(x) == ndims(gmap) ||
        throw(DomainError(x, "length doesn't match map dimensions: $(ndims(gmap))"))
    all(gmap.bounds.lower .<= x .<= gmap.bounds.upper) ||
        throw(DomainError(x, "out of gmap bounds: ($(gmap.bounds.lower), $(gmap.bounds.upper))"))
end

"""
$(TYPEDSIGNATURES)

Returns the resolution (distance between cells) for each dimension of the given
GridMap as a vector.
"""
function res(gmap)
    return (gmap.bounds.upper .- gmap.bounds.lower) ./ (size(gmap) .- 1)
end

"""
$(TYPEDSIGNATURES)

Takes in a point in world-coordinates (a vector) and a GridMap and returns a
CartesianIndex for the underlying array.
"""
function pointToCell(x, gmap)
    dif = (x .- gmap.bounds.lower)
    return CartesianIndex(Tuple(round.(Int, dif ./ res(gmap)) .+ 1))
end

"""
$(TYPEDSIGNATURES)

Takes in a CartesianIndex and a GridMap and returns a point in world-coordinates
(a vector).
"""
function cellToPoint(ci, gmap)
    return (collect(Tuple(ci)) .- 1) .* res(gmap) .+ gmap.bounds.lower
end

"""
$(TYPEDSIGNATURES)

Method to generate the x, y, etc. axes and points of a GridMap. Useful for plotting.

# Examples
```julia
data = reshape(1:25, 5, 5)
gmap = GridMap(data)
generateAxes(gmap)
# output: ([0.0:0.25:1.0, 0.0:0.25:1.0], [[0.0, 0.0] [0.0, 0.25] … [1.0, 0.75] [1.0
, 1.0]])
```
"""
generateAxes(gmap) = generateAxes(gmap.bounds, size(gmap))

function generateAxes(bounds, dims)
    axes = range.(bounds..., dims)
    points = collect.(Iterators.product(axes...))
    return axes, points
end

end
