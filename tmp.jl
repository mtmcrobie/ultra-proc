module Tmp
    # using these
    using DelimitedFiles, Plots, LsqFit
    plotlyjs()

    # add exported definitions below
    export get_file
    export xydata
    export expdec1
    export expdec2
    export export_parameters3
    export export_parameters5
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

        writedlm("$(wavenumber)kinetics.csv", ["delay" "absorption"; xdata ydata], ',')
        return xdata, ydata, wavenumber
    end


    # make single kinetic plot
    function single_kinetic_plot(xdata, ydata, model_ys, wavenumber)
        plot_out = scatter(xdata, ydata,
                           label = "$(wavenumber) cm\u207b\u00b9",
                           color = :black,
                           xlabel = "Delay / ns",
                           ylabel = "\u0394 Abs / OD",
                           tick_dir = :out,
                           grid = false
                           )

        plot!(xdata, model_ys, label = "Exponential fit", color = :black)
        png(plot_out, "$(wavenumber)kinetics")
    end


    # export 3 parameters for exponential fit
    function export_parameters3(fit, wavenumber)
        ci = confidence_interval(fit)

        parameter_array = ["Parameter" "Value"      "Upper Bound" "Lower Bound";
                           "y0"        coef(fit)[1] ci[1][1]      ci[1][2]     ;
                           "A"         coef(fit)[2] ci[2][1]      ci[2][2]     ;
                           "t"         coef(fit)[3] ci[3][1]      ci[3][2]     ;
                           ]

        writedlm("parameters$(wavenumber).csv", parameter_array, ',')
    end


    # export 5 parameters for exponential fit
    function export_parameters5(fit, wavenumber)
        ci = confidence_interval(fit)

        parameter_array = ["Parameter" "Value"      "Upper Bound" "Lower Bound" ;
                           "y0"         coef(fit)[1] ci[1][1]      ci[1][2]     ;
                           "A1"         coef(fit)[2] ci[2][1]      ci[2][2]     ;
                           "t1"         coef(fit)[3] ci[3][1]      ci[3][2]     ;
                           "A2"         coef(fit)[2] ci[2][1]      ci[2][2]     ;
                           "t2"         coef(fit)[3] ci[3][1]      ci[3][2]     ;
                           ]

        writedlm("parameters$(wavenumber).csv", parameter_array, ',')
    end


    # export residuals
    function export_residuals(fit, xdata, wavenumber)
        writedlm("residuals$(wavenumber).csv", fit.resid, ',')

        residual_plot = scatter(xdata, fit.resid,
                    legend = :none,
                    color = :red,
                    xlabel = "Delay / ns",
                    ylabel = "Regular residual",
                    tick_dir = :out, grid = false,
                    markerstrokecolor = :red
                    )

        residual_plot = hline!(xdata, [0], color = :black)
        png(residual_plot, "residuals$(wavenumber)")
    end


    # perform expdec1 (3 parameter exponential model) fit
    function expdec1(xdata, ydata, wavenumber)
        @. model(x, p) = p[1] + (p[2] * exp(-x / p[3]))
        p0 = [0.5, 0.5, 0.5]

        fit = curve_fit(model, xdata, ydata, p0)
        model_ys = model(xdata, coef(fit))

        single_kinetic_plot(xdata, ydata, model_ys, wavenumber)
        export_parameters3(fit, wavenumber)

        return fit
    end



    # perform expdec2 (5 parameter exponential model) fit
    function expdec2(xdata, ydata, wavenumber)
        @. model(x, p) = p[1] + (p[2] * exp(-x / p[3])) + (p[4] * exp(-x / p[5]))
        p0 = [0.5 for i in 1:5]

        fit = curve_fit(model, xdata, ydata, p0)
        model_ys = model(xdata, coef(fit))

        single_kinetic_plot(xdata, ydata, model_ys, wavenumber)
        export_parameters5(fit, wavenumber)
        return fit
    end


    function expgro1(xdata, ydata, wavenumber)
        @. model(x, p) = p[1] + (p[2] * exp(x / p[3]))
        p0 = [0.5, 0.5, 0.5]

        fit = curve_fit(model, xdata, ydata, p0)
        model_ys = model(xdata, coef(fit))

        single_kinetic_plot(xdata, ydata, model_ys, wavenumber)
        export_parameter3(fit, wavenumber)
        return fit
    end

end
