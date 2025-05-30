@defcomp erfresponse begin
	ERF	= Variable(index=[time])

	AOD = Parameter(index=[time])	
	C_aod	= Parameter()	
    C_aod1	= Parameter()
    E_1 = Parameter()
    add3=Parameter()
    initial4=Parameter()
    
    function run_timestep(p, v, d, t)

        if is_first(t)
           v.ERF[t]= p.initial4 * p.AOD[t] 
       
        else  
                            
            v.ERF[t]=p.E_1* v.ERF[t - 1] + p.C_aod * p.AOD[t] + p.C_aod1 * p.AOD[t - 1] + p.add3
                                     
        end
    end
end
#    function run_timestep(p, v, d, t)
#            if is_first(t)
#               v.ERF[t]= p.initial4 * p.AOD[t] 
#
#            elseif !is_last(t)         
#               v.ERF[t]= v.ERF[t+1]
#           
#            else  
#                v.ERF[t]=p.E_1* v.ERF[t - 1] + p.C_aod * p.AOD[t] + p.C_aod1 * p.AOD[t - 1] + p.add3              
#            end
#    end
#end


