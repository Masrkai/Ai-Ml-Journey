module CorpusPipeline
export load_corpus
function load_corpus()
    path = normpath(joinpath(@__DIR__, "../../../../datasets/corpus.txt"))
    return read(path, String)
end
end
