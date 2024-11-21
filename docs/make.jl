using GridMaps
using Documenter

DocMeta.setdocmeta!(GridMaps, :DocTestSetup, :(using GridMaps); recursive=true)

makedocs(;
    modules=[GridMaps],
    authors="Nicholas Harrison",
    sitename="GridMaps.jl",
    format=Documenter.HTML(;
        canonical="https://ngharrison.github.io/GridMaps.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ngharrison/GridMaps.jl",
    devbranch="main",
)
