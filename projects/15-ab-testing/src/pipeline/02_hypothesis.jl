module HypothesisPipeline
using DataFrames
using Statistics

export run_ab_test

function run_ab_test(df::DataFrame)
    control = df[df.Variant .== "Control", :Converted]
    treatment = df[df.Variant .== "Treatment", :Converted]
    
    p_c = mean(control)
    p_t = mean(treatment)
    n_c = length(control)
    n_t = length(treatment)
    
    p_pool = (sum(control) + sum(treatment)) / (n_c + n_t)
    se = sqrt(p_pool * (1 - p_pool) * (1/n_c + 1/n_t))
    z_stat = (p_t - p_c) / se
    
    return p_c, p_t, z_stat
end

end
