using Documenter
using Topix
DocMeta.setdocmeta!(Topix, :DocTestSetup, :(using Topix, DataFrames, CSV); recursive=true)
makedocs(
    sitename = "Topix",
    format = Documenter.HTML(),
    modules = [Topix]
)
deploydocs(
    repo = "github.com/dokudo91/Topix.jl.git",
)