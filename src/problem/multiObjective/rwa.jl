function subasi2016()
    # Define the problem with 2 objectives
    problem = ContinuousProblem{Float64}("Subasi2016")

    # Define the bounds for the variables
    lower_bounds = [20.0, 6.0, 20.0, 0.0, 8000.0]
    upper_bounds = [60.0, 15.0, 40.0, 30.0, 25000.0]

    # Add variables to the problem
    for i in 1:length(lower_bounds)
        addVariable(problem, Bounds{Float64}(lower_bounds[i], upper_bounds[i]))
    end

    # Define the objectives
    nu = x -> begin
        H, t, Sy, theta, Re = x

        Nu = 89.027 + 0.300 * H - 0.096 * t - 1.124 * Sy - 0.968 * theta +
             4.148 * 10^(-3) * Re + 0.0464 * H * t - 0.0244 * H * Sy +
             0.0159 * H * theta + 4.151 * 10^(-5) * H * Re + 0.1111 * t * Sy -
             4.121 * 10^(-5) * Sy * Re + 4.192 * 10^(-5) * theta * Re

        return -Nu  # maximization (invert sign)
    end

    f = x -> begin
        H, t, Sy, theta, Re = x

        f_val = 0.4753 - 0.0181 * H + 0.0420 * t + 5.481 * 10^(-3) * Sy -
                0.0191 * theta - 3.416 * 10^(-6) * Re - 8.851 * 10^(-4) * H * Sy +
                8.702 * 10^(-4) * H * theta + 1.536 * 10^(-3) * t * theta -
                2.761 * 10^(-6) * t * Re - 4.400 * 10^(-4) * Sy * theta +
                9.714 * 10^(-7) * Sy * Re + 6.777 * 10^(-4) * H * H

        return f_val  # minimization (no sign change needed)
    end

    # Add objectives to the problem
    addObjective(problem, nu)
    addObjective(problem, f)

    return problem
end