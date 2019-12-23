module Tst
    include("tmp.jl")
    using .Tmp

    # add test code below

    #println(size(get_file()))

    #
    xdata, ydata, pixel, wavenumber = xydata(get_file())
    #println(size(ydata))
    
    fit, model_ys = expdec1(xdata, ydata)
    #println(size(model_ys))
    #println(Tmp.coef(fit))
    #export_parameters(fit, pixel)
    export_residuals(fit, xdata, pixel)
    #single_kinetic(xdata, ydata, model_ys, wavenumber)


end