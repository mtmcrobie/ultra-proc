module Tst
    include("tmp.jl")
    using .Tmp

    # add test code below

    #println(size(get_file()))

    #
    xdata, ydata = xydata(get_file())
    #=println(a); println(b)
    =#
    
    fit = expdec1(xdata, ydata)
    #println(Tmp.coef(fit))
    exp_parameters(fit)

end