# GridMaps

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ngharrison.github.io/GridMaps.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ngharrison.github.io/GridMaps.jl/dev/)
[![Build Status](https://github.com/ngharrison/GridMaps.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ngharrison/GridMaps.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Overview

This package provides the single, simple GridMap type. This type grants the ability to use an array of data as a continuous map of values across a designated rectangular region, interpolating values in between the known data points. It works with any number of dimensions. Its current interpolation method is a nearest-neighbor approximation, and it implicitly handles the calculation between map coordinates and array indices. A typical use of this package is to access values from a matrix as if it were a continuous 2D map with known bounds. See the documentation for details and usage examples.

## Installation

This package is registered and can be installed using Julia's builtin package manager:

``` julia
using Pkg; Pkg.add("GridMaps")
```

## Relation to other packages

A number of other packages have types and methods that can achieve similar functionality (relevant as of Dec 19, 2024):

- [AxisKeys](https://github.com/mcabbott/AxisKeys.jl) -- Provides a `KeyedArray` and a `Near` selector which does a nearest-neighbor look-up. In addition, allows the dimensions to be named through NamedDims.jl rather than solely accessing through indices.
- [DimensionalData](https://github.com/rafaqz/DimensionalData.jl) -- Similar to the previous one: provides a `DimArray` and a `Near` selector for a nearest-neighbor look-up. Performance of this and AxisKeys is on par with GridMaps.
- [Interpolations](https://github.com/JuliaMath/Interpolations.jl) -- Fits the goal of this package closer. Can interpolate values over multidimensional grids through B-splines, which results in a choice of interpolations between nearest-neighbor, linear, quadratic, and cubic. Shows a slight performance improvement (though probably not enough to matter) over the previous two and GridMaps when testing the same functionality.
- [GridInterpolations](https://github.com/sisl/GridInterpolations.jl) -- Can also do efficient interpolation (on par with Interpolations) of values over a multidimensional grid. Has linear and simplex interpolation (but no nearest-neighbor).


These other packages largely subsume what is achieved in this package, and it is recommended to consider them if more features are desired.
