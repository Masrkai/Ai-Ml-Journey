# =====================================================================
# Project 14: Language Model from scratch - Master Driver
# =====================================================================

include("pipeline/01_corpus.jl")
include("pipeline/02_model.jl")
include("pipeline/03_generation.jl")
include("pipeline/04_evaluation.jl")

using .CorpusPipeline
using .ModelPipeline
using .GenerationPipeline
using .VisualizationPipeline

function run_pipeline()
    println("Starting Project 14: Language Model Pipeline")
    text = load_corpus()
    model = build_ngram_model(text, 3)
    seed = text[1:3]
    gen_text = generate_text(model, seed, 80, 3)
    save_report(gen_text)
    println("Project 14 Completed! Generated Text length: $(length(gen_text))")
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_pipeline()
end
