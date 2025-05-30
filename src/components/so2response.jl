@defcomp so2response begin
	SO2	= Variable(index=[time])	
	injection = Parameter(index=[time])
	C1	= Parameter()
    r1	= Parameter()
    add1 = Parameter()
    initial1 = Parameter()

    function run_timestep(p, v, d, t)

        if is_first(t)
           v.SO2[t]=p.initial1 * p.injection[t]

        else
           v.SO2[t]=p.C1 * p.injection[t] + p.r1*v.SO2[t-1] + p.add1

        end       
    end
end


