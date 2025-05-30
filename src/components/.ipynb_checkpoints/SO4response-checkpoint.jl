@defcomp so4response begin
	SO4	= Variable(index=[time])	# Total greenhouse gas emissions
	SO2 = Parameter(index=[time])	# Emissions output ratio
	C2	= Parameter()	# Gross output - Note that YGROSS is now a parameter
    r2	= Parameter()
    add2 = Parameter()
    
    function run_timestep(p, v, d, t)
        if !is_first(t)
            v.SO4[t]=p.C2 * p.SO2[t] + p.add2
        else
            v.SO4[t]=p.C2 * p.SO2[t] + p.r2*v.SO2[t-1] + p.add2
               
        end
    end
end
