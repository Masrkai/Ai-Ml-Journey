# =====================================================================
# Stage 3: Target Distribution & Shannon Entropy Diagnostics
# =====================================================================

if !isnothing(target_col) && !(eltype(df[!, target_col]) <: Number)
    println("\n[3] Computing Target Class Distribution & Shannon Entropy...")
    push!(summary_lines, "\n[Target Class Imbalance & Entropy Diagnostics]")
    target_counts = combine(groupby(df, target_col), nrow => :count)
    total_rows = size(df, 1)
    entropy_val = 0.0
    for r in eachrow(target_counts)
        prop = r.count / total_rows
        global entropy_val -= prop * log2(prop)
        ratio_str = " - Class '$(r[target_col])': count = $(r.count) ($(round(prop * 100, digits=2))%)"
        println(ratio_str)
        push!(summary_lines, ratio_str)
    end
    ent_str = " - Shannon Entropy of Target Distribution: $(round(entropy_val, digits=4)) bits"
    println(ent_str)
    push!(summary_lines, ent_str)
end
