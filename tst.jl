#!/usr/bin/env Julia
module Tst
    include("Kinetics.jl")
    using Kinetics

    # add test code below


    xdata, ydata, wavenumber = xydata(get_file())
    #fit = expdec1(xdata, ydata, wavenumber)
    #fit = expdec2(xdata, ydata, wavenumber)
end
