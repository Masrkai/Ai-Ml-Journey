module PreprocessPipeline
using DataFrames
using Random

export vectorize_text

function vectorize_text(df::DataFrame)
    println("Vectorizing text corpus (TF-IDF bag of words)...")
    texts = df.Text
    labels = df.Sentiment

    # Build simple vocabulary
    words = unique(vcat([split(t) for t in texts]...))
    vocab = Dict(w => i for (i, w) in enumerate(words))
    V = length(vocab)

    n = length(texts)
    X = zeros(n, V)
    for (i, t) in enumerate(texts)
        tokens = split(t)
        for tok in tokens
            if haskey(vocab, tok)
                X[i, vocab[tok]] += 1.0
            end
        end
    end

    # TF-IDF scaling approximation
    idf = log.(n ./ (sum(X .> 0, dims=1) .+ 1))
    X_tfidf = X .* idf
    X_design = hcat(ones(n), X_tfidf)

    indices = shuffle(1:n)
    train_size = round(Int, 0.8 * n)
    train_idx = indices[1:train_size]
    test_idx = indices[train_size+1:end]

    return X_design[train_idx, :], labels[train_idx], X_design[test_idx, :], labels[test_idx]
end

end
