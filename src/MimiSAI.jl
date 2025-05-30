module MimiSAI

using Mimi

using DelimitedFiles
using Random
using SpecialFunctions

include("helper.jl")

include("components/so2response.jl")
include("components/so4response.jl")
include("components/aodresponse.jl")
include("components/erfresponse.jl")
include("components/tempresponse.jl")

export get_model
const global default_nsteps = 35
const global default_datadir = joinpath(dirname(@__FILE__), "..", "data")
const global default_params = nothing

function get_model(;nsteps = default_nsteps, datadir = default_datadir, params = default_params)
    m = Model()
    if nsteps != default_nsteps
        if datadir != default_datadir || params != default_params
            set_dimension!(m, :time, collect(2035:2035 + nsteps))       
            reset_time_dimension = false
        else
            nsteps > default_nsteps ? error(
                "Invalid `nsteps`: $nsteps. Cannot build a MimiSAI model with more than $default_nsteps  timesteps, unless an alternative `datadir` or `params` dictionary is provided."
                ) : nothing
          set_dimension!(m, :time, collect(2035:2035 + default_nsteps)) 
            reset_time_dimension = true                                   
        end        
    else 
        set_dimension!(m, :time, collect(2035:2035 + default_nsteps))    
        reset_time_dimension = false
    end

	add_comp!(m, so2response)
    add_comp!(m, so4response)
    add_comp!(m, aodresponse)
    add_comp!(m, erfresponse)
    add_comp!(m, tempresponse)

 
   # add_comp!(m, tem)
    #add_comp!(m, :SO2response, SO2response)
	update_param!(m, :so2response, :C1, 7.379823194841514e-12)
    update_param!(m, :so2response, :r1, 0.14538987085052762)
    update_param!(m, :so2response, :add1, -1.5998267744121919e-12)
    update_param!(m, :so2response, :initial1, 4.54515881e-12)
    
    update_param!(m, :so4response, :C2, 18.77828025817871)
    update_param!(m, :so4response, :r2, 0.6283242702484131)
    update_param!(m, :so4response, :add2, 2.0582135995539375e-10)
    update_param!(m, :so4response, :initial2, 28.808065)
    connect_param!(m, :so4response, :SO2, :so2response, :SO2)     

    update_param!(m, :aodresponse, :C_lin, -5.20042419)
    update_param!(m, :aodresponse, :r_lin, 2.15803136e+09)
    update_param!(m, :aodresponse, :C_nonlin, 2.24517119e+06)
    update_param!(m, :aodresponse, :r_nonlin, 0.86207960)
    update_param!(m, :aodresponse, :initial3, 53867590.0)

    update_param!(m, :erfresponse, :C_aod, 13.223699) 
    update_param!(m, :erfresponse, :C_aod1,-28.26212) 
    update_param!(m, :erfresponse, :E_1, 0.7189846) 
    update_param!(m, :erfresponse, :add3,  0.112006664) 
    #update_param!(m, :erfresponse, :initial4, 23.11951)
    update_param!(m, :erfresponse, :initial4, -40.288612)

    update_param!(m,  :tempresponse, :mu,  3.225939) 
    update_param!(m,  :tempresponse, :tau, 14.15)
    update_param!(m,  :tempresponse, :initial5, 25.756693)
    connect_param!(m, :tempresponse, :AOD, :aodresponse, :AOD)     

 
    connect_param!(m, :aodresponse, :SO4, :so4response, :SO4)     
    connect_param!(m, :erfresponse, :AOD, :aodresponse, :AOD)     

    parameters = params === nothing ? load_default_parameters(datadir) : params
    
    for (name, value) in parameters[:unshared]
        update_param!(m, name[1], name[2], value)
    end


    reset_time_dimension ? set_dimension!(m, :time, collect(2035:2035 + nsteps)) : nothing
    #update_param!(m, :SO2response, :injection)
    
    return m
end

end



