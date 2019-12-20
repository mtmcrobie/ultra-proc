module Tst
    include("tmp.jl")
    using .Tmp

    # add test code below

    #println(size(get_file()))

    #
    xdata, ydata, pixel = xydata(get_file())
    #=println(a); println(b)
    =#
    
    fit = expdec1(xdata, ydata)
    #println(Tmp.coef(fit))
    #export_parameters(fit, pixel)
    export_residuals(fit, pixel)

end