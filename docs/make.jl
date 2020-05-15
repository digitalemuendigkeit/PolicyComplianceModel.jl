using Documenter, PolicyComplianceModel

makedocs(;
    modules=[PolicyComplianceModel],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/sumidu/PolicyComplianceModel.jl/blob/{commit}{path}#L{line}",
    sitename="PolicyComplianceModel.jl",
    authors="André Calero Valdez <andrecalerovaldez@gmail.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/digitalemuendigkeit/PolicyComplianceModel.jl",
)
