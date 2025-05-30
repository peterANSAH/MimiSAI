@defcomp SO2response begin
	SO2	= Variable(index=[time])	# Total greenhouse gas emissions
	injection = Parameter(index=[time])	# Emissions output ratio
	C1	= Parameter()	# Gross output - Note that YGROSS is now a parameter
    r1	= Parameter()
    add1 = Parameter()
    
    function run_timestep(p, v, d, t)
        if !is_first(t)
           v.SO2[t]=C * p.injection[t]
        end
           v.SO2[t]=p.C1 * p.injection[t] + p.r1*v.SO2[t-1] + p.add1
               
    end
end


