using Distributions

"""
Converts a year value into an integer corresponding to fund's time index.
"""
function getindexfromyear(year::Int)
    baseyear = 2035
    return year - baseyear + 1
end


"""
Reads parameter csvs from data directory into a dictionary (parameter_name => default_value).
For parameters defined as distributions, this sets the value to their mode.
""" 
function load_default_parameters(datadir = joinpath(dirname(@__FILE__), "..", "data"))
    files = readdir(datadir)
    filter!(i -> i != "desktop.ini", files)
    parameters = Dict{Symbol, Any}(Symbol(splitext(file)[1]) => readdlm(joinpath(datadir,file), ',', comments = true) for file in files)

    prepparameters!(parameters)

    return parameters
end


function prepparameters!(parameters)
    for (param_name, p) in parameters
        column_count = size(p,2)
        if column_count == 1
            parameters[param_name] = p[1,1]
        elseif column_count == 2
            parameters[param_name] = Float64[p[j,2] for j in 1:size(p,1)]
        elseif column_count == 3
            length_index1 = length(unique(p[:,1]))
            length_index2 = length(unique(p[:,2]))
            new_p = Array{Float64}(undef, length_index1, length_index2)
            cur_1 = 1
            cur_2 = 1
            for j in 1:size(p,1)
                new_p[cur_1,cur_2] = p[j,3]
                cur_2 += 1
                if cur_2 > length_index2
                    cur_2 = 1
                    cur_1 += 1
                end
            end
            parameters[param_name] = new_p
        end
    end
end





