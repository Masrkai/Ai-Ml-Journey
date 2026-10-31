module ModelPipeline
export build_ngram_model
function build_ngram_model(text, n=3)
    model = Dict{String, Dict{Char, Int}}()
    for i in 1:(length(text)-n)
        context = text[i:i+n-1]
        next_char = text[i+n]
        if !haskey(model, context)
            model[context] = Dict{Char, Int}()
        end
        model[context][next_char] = get(model[context], next_char, 0) + 1
    end
    return model
end
end
