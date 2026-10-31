module RegistryPipeline
export register_model
function register_model(name, version, metrics)
    println("Registering model $name (v$version) with metrics $metrics")
    return true
end
end
