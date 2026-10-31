module AuditPipeline
using CSV
using DataFrames

export audit_dataset

function audit_dataset()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/automl_data.csv"))
    df = CSV.read(path, DataFrame)
    println("Audited dataset: $(nrow(df)) rows, $(ncol(df)) columns.")
    return df
end

end
