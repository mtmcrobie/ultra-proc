module Tst
    include("tmp.jl")
    using .Tmp

    # add test code below

    #println(size(get_file()))

    #
    xdata, ydata, wavenumber = xydata(get_file())
    #println(size(ydata))
    fit, model_ys = expdec1(xdata, ydata, wavenumber)
    #fit, model_ys = expdec2(xdata, ydata, wavenumber)
    #println(size(model_ys))
    #println(Tmp.coef(fit))
    #export_parameters(fit, wavenumber)
    export_residuals(fit, xdata, wavenumber)
    #single_kinetic(xdata, ydata, model_ys, wavenumber)


end
