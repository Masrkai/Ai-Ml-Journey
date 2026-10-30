# =====================================================================
# Stage 2: Data Quality & Missingness Audit
# =====================================================================

println("\n[2] Performing Data Quality & Missingness Audit...")
push!(summary_lines, "\n[Data Quality Audit]")
for col in names(df)
    col_data = df[!, col]
    missing_count = count(ismissing, col_data)
    missing_pct = (missing_count / length(col_data)) * 100
    unique_count = length(unique(col_data))
    audit_str = " - Column '$(col)' ($(eltype(col_data))): missing = $(missing_count) ($(round(missing_pct, digits=2))%), unique_values = $(unique_count)"
    println(audit_str)
    push!(summary_lines, audit_str)
end

# Duplicate row check
dup_count = sum(nonunique(df))
dup_str = " - Exact duplicate rows detected: $(dup_count)"
println(dup_str)
push!(summary_lines, dup_str)
