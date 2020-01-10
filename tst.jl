#!/usr/bin/env Julia
module Tst
#using Kinetics
include("BaseFunctions.jl")
include("SortRaw.jl")
using .BaseFunctions
using .SortRaw

# add test code below

message = "What is your name?"
ynmessage = "Yes or no ([Q]uit)?"

name = BaseFunctions.userinput(message)
println("Hello $(name)")

yorn = BaseFunctions.yninput(ynmessage)
if yorn == true
    println("You selected yes")
elseif yorn == false
    println("You selected no")
end

outarr = SortRaw.sortraw("Run 0 Avg Diff spec 01.csv")
println(size(outarr))

println("Unit tests complete")

#xdata, ydata, wavenumber = xydata(get_file())
#fit = expdec1(xdata, ydata, wavenumber)
#fit = expdec2(xdata, ydata, wavenumber)
end
