```@meta
CurrentModule = GridMaps
```

# GridMaps

## Quick Intro

This package provides the single, simple GridMap type and some associated methods. The typical use is to create a GridMap using a multi-dimensional array of data and bounds for all the dimensions of the region. Then individual values can be extracted by calling the created type with a desired multi-dimensional point.

Following is a quick example of the main functionality of this package.

```@repl
using Random; Random.seed!(0); # for repeatability

using GridMaps

data = reshape(1:25, 5, 5);
bounds = (
    lower = [0.0, 0.0],
    upper = [1.0, 1.0]
);
gmap = GridMap(data, bounds) # stores the data and bounds
val = gmap[1,4] # can directly access the underlying matrix
x = [.2, .75]; # a location/point
val = gmap(x) # returns the value at a single 2D point
x, val = rand(gmap) # returns a random point and its value
getBounds(gmap) # can retrieve the bounds
res(gmap) # can calculate the cell resolutions
ix = pointToCell(x, gmap) # converts a location to a cell index
cellToPoint(CartesianIndex(1,4), gmap) # converts a cell index to a location
generateAxes(gmap) # creates axes and points for all cells
```


## Further Info

See below for further details on each type and method.

```@index
```

```@autodocs
Modules = [GridMaps]
```
