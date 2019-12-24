module Tmp
    # using these
    using DelimitedFiles, Plots, LsqFit, Debugger
    plotlyjs()

    # add exported definitions below
    export get_file
    export xydata
    export expdec1
    export expdec2
    export export_parameters
    export export_residuals
    export single_kinetic

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
        wavenumber = convert(Int, round(input_file[pixel_index, 2]))

        println("Input first and last delay in ns, separated by a space:")
        delays = parse.(Float64, split(readline(), " "))
        first =  findfirst(isequal(delays[1]), input_file[1, :])
        last =  findfirst(isequal(delays[2]), input_file[1, :])
        xdata, ydata = input_file[1, first:last], input_file[pixel_index, first:last]

        return xdata, ydata, pixel, wavenumber
    end


    # perform expdec1 (3 parameter exponential model) fit
    function expdec1(xdata, ydata)
        @. model(x, p) = p[1] + (p[2] * exp(-x / p[3]))
        p0 = [0.5, 0.5, 0.5]

        fit = curve_fit(model, xdata, ydata, p0)
        model_ys = model(xdata, coef(fit))
        return fit, model_ys
    end

    function expdec2(xdata, ydata, pixel, wavenumber)
        @. model(x, p) = p[1] + (p[2] * exp(-x / p[3])) + (p[4] * exp(-x / p[5]))
        p0 = [0.5 for i in 1:5]
        
        fit = curve_fit(model, xdata, ydata, p0)
        model_ys = model(xdata, coef(fit))
        ci = confidence_interval(fit)
        
        parameter_array = ["Parameter" "Value"      "Upper Bound" "Lower Bound";
                           "y0"        coef(fit)[1] ci[1][1]      ci[1][2]     ;
                           "A1"        coef(fit)[2] ci[2][1]      ci[2][2]     ;
                           "t1"        coef(fit)[3] ci[3][1]      ci[3][2]     ;
                           "A2"        coef(fit)[4] ci[4][1]      ci[4][2]     ;
                           "t2"        coef(fit)[5] ci[5][1]      ci[5][2]     ;
                           ]
        writedlm("parameters$(pixel).csv", parameter_array, ',')

        single_kinetic_plot = scatter(xdata, ydata,
                                   label = "$(wavenumber) cm\u207b\u00b9",
                                   color = :black,
                                   xlabel = "Delay / ns",
                                   ylabel = "\u0394 Abs / OD",
                                   tick_dir = :out,
                                   grid = false
                                   )

        plot!(xdata, model_ys, label = "Exponential fit", color = :black, )

        png(single_kinetic_plot, "kinetics$(wavenumber)")
        return fit, model_ys
    end


    # export fit parameters and confidence limits
    function export_parameters(fit, pixel)
        ci = confidence_interval(fit)

        parameter_array = ["Parameter" "Value"      "Upper Bound" "Lower Bound";
                           "y0"        coef(fit)[1] ci[1][1]      ci[1][2]     ;
                           "A"         coef(fit)[2] ci[2][1]      ci[2][2]     ;
                           "t"         coef(fit)[3] ci[3][1]      ci[3][2]     ;
        ]

        writedlm("parameters$(pixel).csv", parameter_array, ',')
    end


    # export residuals
    function export_residuals(fit, xdata, pixel)
        writedlm("residuals$(pixel).csv", fit.resid, ',')
        residual_plot = scatter(xdata, fit.resid,

                    legend = :none,
                    color = :red,
                    xlabel = "Delay / ns",
                    ylabel = "Regular residual",
                    tick_dir = :out, grid = false,
                    markerstrokecolor = :red
                    )
        
        residual_plot = hline!(xdata, [0], color = :black)
        png(residual_plot, "residuals$(pixel)")
    end

    #= export plots
    function single_kinetic(xdata, ydata, model_ys, wavenumber)
        x_series = hcat(xdata, xdata)
        y_series = hcat(ydata, model_ys)
        labels = ["$wavenumber cm\u207b\u00b9", "Exponential fit"]
        types = [:scatter, :line]
        colors = [:black, :black]

        single_kinetic_plot = plot(x_series, y_series,

                    label = labels, seriestype = types, color = colors,
                    xlabel = "Delay / ns", ylabel = "\u0394 Abs / OD",
                    tick_dir = :out, grid = false
                   )

        png(single_kinetic_plot, "$(wavenumber)kinetics")
    end=#

end