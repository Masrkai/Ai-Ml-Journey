module GenerationPipeline
export generate_text

function sample_categorical(chars, probs)
    r = rand()
    cum = 0.0
    for (c, p) in zip(chars, probs)
        cum += p
        if r <= cum
            return c
        end
    end
    return chars[end]
end

function generate_text(model, seed, length=100, n=3)
    curr = seed
    output = curr
    for _ in 1:length
        if haskey(model, curr)
            chars = collect(keys(model[curr]))
            counts = collect(values(model[curr]))
            probs = counts ./ sum(counts)
            next_char = sample_categorical(chars, probs)
            output *= string(next_char)
            curr = output[end-n+1:end]
        else
            break
        end
    end
    return output
end

end
