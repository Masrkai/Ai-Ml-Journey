module IngestPipeline
using CSV
using DataFrames

export load_face_data

function load_face_data()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/faces.csv"))
    return CSV.read(path, DataFrame)
end

end
