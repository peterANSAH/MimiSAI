@defcomp so4response begin
	SO4	= Variable(index=[time])	
	SO2 = Parameter(index=[time])	
	C2	= Parameter()	
    r2	= Parameter()
    add2 = Parameter()
    initial2=Parameter()
    
    function run_timestep(p, v, d, t)
        if is_first(t)
            v.SO4[t]= p.initial2 * p.SO2[t] #+ p.add2
        else
            v.SO4[t]= p.C2 * p.SO2[t] + p.r2 * v.SO4[t-1] + p.add2            
        end
    end
end
