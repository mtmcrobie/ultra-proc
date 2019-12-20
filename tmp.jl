module Tmp
    # using these
    using DelimitedFiles, Plots, LsqFit

    # add exported definitions below
    export get_file
    export xydata
    export expdec1
    export exp_parameters

    # get file for kinetic analysis
    function get_file()
        println("Importing pixel_overlap_removed.csv...")
        input_file = readdlm("pixel_overlap_removed.csv", ',')
        return input_file
    end


    # get x and y data for fitting
    function xydata(input_file)
        println("Input pixel for kinetic analysis:")
        pixel = parse(Int, readline())
        pixel_index = findfirst(isequal(pixel), input_file[:, 1])

        println("Input first and last delay in ns, separated by a space:")
        delays = parse.(Float64, split(readline(), " "))
        first =  findfirst(isequal(delays[1]), input_file[1, :])
        last =  findfirst(isequal(delays[2]), input_file[1, :])
        xdata, ydata = input_file[1, first:last], input_file[pixel_index, first:last]

        return xdata, ydata
    end


    # perform expdec1 (3 parameter exponential model) fit
    function expdec1(xdata, ydata)
        @. model(x, p) = p[1] + (p[2] * exp(-x / p[3]))
        p0 = [0.5, 0.5, 0.5]

        fit = curve_fit(model, xdata, ydata, p0)
        return fit
    end


    # export fit parameters and confidence limits
    function exp_parameters(fit)
        ci = confidence_interval(fit)

        parameter_array = ["Parameter" "Value"      "Upper Bound" "Lower Bound";
                           "y0"        coef(fit)[1] ci[1][1]      ci[1][2]     ;
                           "A"         coef(fit)[2] ci[2][1]      ci[2][2]     ;
                           "t"         coef(fit)[3] ci[3][1]      ci[3][2]     ;
        ]

        writedlm("parameters.csv", parameter_array, ',')
    end


    # 




end