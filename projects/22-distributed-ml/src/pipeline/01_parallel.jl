module ParallelPipeline
export parallel_compute
function parallel_compute(n=1000000)
    println("Running parallel computation across threads (Threads.nthreads() = $(Threads.nthreads()))...")
    res = zeros(n)
    Threads.@threads for i in 1:n
        res[i] = sin(i) * cos(i)
    end
    return sum(res)
end
end
