# =====================================================================
# Stage 4: Visualizations & Summary Reporting
# =====================================================================

println("\n[4] Generating Visualizations & Summary Report...")

output_dir = joinpath(dirname(dirname(@__DIR__)), "output")
mkpath(output_dir)

gr(fmt=:png, size=(800, 600))

# 1. Survival by Pclass
pclass_grouped = combine(groupby(df_clean, :Pclass), :Survived => mean => :SurvivalRate)
plt1 = bar(string.(pclass_grouped.Pclass), pclass_grouped.SurvivalRate .* 100,
    xlabel="Passenger Class (Pclass)", ylabel="Survival Rate (%)",
    title="Titanic Survival Rate by Passenger Class", legend=false, color=:orange)
savefig(plt1, joinpath(output_dir, "survival_by_pclass.png"))

# 2. Age Distribution by Survival
survived_age = df_clean.Age[df_clean.Survived .== 1]
died_age = df_clean.Age[df_clean.Survived .== 0]
plt2 = histogram([died_age, survived_age], label=["Did Not Survive" "Survived"],
    bins=20, alpha=0.6, xlabel="Age (Years)", ylabel="Passenger Count",
    title="Titanic Age Distribution by Survival Status")
savefig(plt2, joinpath(output_dir, "age_distribution.png"))

println("Visualizations saved successfully to $output_dir/")

report_path = joinpath(output_dir, "summary_report.txt")
open(report_path, "w") do io
    for line in summary_lines
        println(io, line)
    end
end
println("Summary report written to $report_path")
