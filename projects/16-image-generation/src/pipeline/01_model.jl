module ModelPipeline
export generate_pattern
function generate_pattern(size=32, steps=20)
    grid = rand(0:1, size, size)
    for _ in 1:steps
        grid = [sum(grid[max(1, i-1):min(size, i+1), max(1, j-1):min(size, j+1)]) % 2 for i in 1:size, j in 1:size]
    end
    return grid
end
end
