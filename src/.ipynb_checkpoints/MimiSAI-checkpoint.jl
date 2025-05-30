module MimiSAI

using Mimi

using DelimitedFiles
using Random

include("helper.jl")

include("components/so2response.jl")
include("components/so4response.jl")


export get_model
const global default_nsteps = 35
const global default_datadir = joinpath(dirname(@__FILE__), "..", "data")
const global default_params = nothing

function get_model(;nsteps = default_nsteps, datadir = default_datadir, params = default_params)
    m = Model()
    if nsteps != default_nsteps
        if datadir != default_datadir || params != default_params
            set_dimension!(m, :time, collect(2035:2035 + nsteps))       # If the user provided an alternative datadir or params dictionary,  #the time dimensions can be reset now
            reset_time_dimension = false
        else
            nsteps > default_nsteps ? error(
                "Invalid `nsteps`: $nsteps. Cannot build a MimiFUND model with more than $default_nsteps  timesteps, unless an alternative `datadir` or `params` dictionary is provided."
                ) : nothing
          set_dimension!(m, :time, collect(2035:2035 + default_nsteps)) # start with the default FUND time dimension, so that`set_leftover_params!` will work with the default parameter lengths
            reset_time_dimension = true                                   # then reset the time dimension at the end
        end        
    else 
        set_dimension!(m, :time, collect(2035:2035 + default_nsteps))    # default FUND time dimension
        reset_time_dimension = false
    end

	add_comp!(m, so2response)
    add_comp!(m, so4response)

   # add_comp!(m, tem)
    #add_comp!(m, :SO2response, SO2response)
	update_param!(m, :so2response, :C1, 7.379823194841514e-12)
    update_param!(m, :so2response, :r1, 0.14538987085052762)
    update_param!(m, :so2response, :add1, -1.5998267744121919e-12)
    
    update_param!(m, :so4response, :C2,  18.77828025817871)
    update_param!(m, :so4response, :r2, 0.6283242702484131)
    update_param!(m, :so4response, :add2, 2.0582135995539375e-10)
#    update_param!(m, :so4response, :initial1, 28.80806579)
    
    connect_param!(m, :so4response, :SO2, :so2response, :SO2)  

    
    parameters = params === nothing ? load_default_parameters(datadir) : params
    
    for (name, value) in parameters[:unshared]
        update_param!(m, name[1], name[2], value)
    end

    # Reset the time dimension if needed
    reset_time_dimension ? set_dimension!(m, :time, collect(2035:2035 + nsteps)) : nothing
    #update_param!(m, :SO2response, :injection)
    
    return m
end

end




