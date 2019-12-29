module Tst
    include("tmp.jl")
    using .Tmp

    # add test code below


    xdata, ydata, wavenumber = xydata(get_file())
    #fit = expdec1(xdata, ydata, wavenumber)
    #fit = expdec2(xdata, ydata, wavenumber)
end
