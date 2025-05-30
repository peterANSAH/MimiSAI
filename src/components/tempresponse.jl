@defcomp tempresponse begin

    AOD = Parameter(index=[time])   
    T_sai = Variable(index=[time])       

    mu = Parameter()                      
    tau = Parameter()                    
    initial5 = Parameter()                

    function run_timestep(p, v, d, t)

        t_index = findfirst(x -> x == t, d.time)
        
        if is_first(t)
            v.T_sai[t] = p.initial5 * p.AOD[t]
        else
            temp_sum = 0.0
            for j in 1:(t_index - 1)
                h_val = h_sai(j, p.mu, p.tau)
                AOD_val = p.AOD[d.time[t_index - j]]
                temp_sum += h_val * AOD_val
            end
            v.T_sai[t] = temp_sum
        end
    end
end

function h_sai(j, mu, tau)
    if j == 0
        return 0.0
    end
    f1 = 1 / sqrt(pi * j * tau)
    f2 = exp(-j / tau) * erfc(sqrt(j / tau))
    return mu * (f1 - f2)
end


