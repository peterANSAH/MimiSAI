@defcomp aodresponse begin
	AOD	= Variable(index=[time])
    logAOD=Variable(index=[time])
	SO4 = Parameter(index=[time])	
	C_lin	= Parameter()	
    r_lin	= Parameter()
    C_nonlin = Parameter()
    r_nonlin=Parameter()
    initial3 = Parameter()

    
    function run_timestep(p, v, d, t)
        if is_first(t)
           v.AOD[t]=p.initial3 * p.SO4[t]
 
        else
            if p.SO4[t] < 0.8e-9 # Linear Regime

               v.logAOD[t]=p.C_lin + p.r_lin * p.SO4[t] 

               v.AOD[t]=exp(v.logAOD[t])

            else
                v.AOD[t] = p.C_nonlin * (p.SO4[t])^p.r_nonlin  # nonlinear regime
                v.logAOD[t]=log(v.AOD[t])
                
            end
        end
    end
end
