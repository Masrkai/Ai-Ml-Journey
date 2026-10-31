module AgentPipeline
export train_q_learning
function train_q_learning(episodes=500)
    Q = zeros(5, 5, 4)
    total_reward = 0.0
    for ep in 1:episodes
        state = [1, 1]
        for step in 1:20
            if state == [5, 5]
                total_reward += 10.0
                break
            end
            action = rand(1:4)
            if action == 1 && state[1] < 5 state[1] += 1
            elseif action == 2 && state[1] > 1 state[1] -= 1
            elseif action == 3 && state[2] < 5 state[2] += 1
            elseif action == 4 && state[2] > 1 state[2] -= 1
            end
        end
    end
    return total_reward
end
end
