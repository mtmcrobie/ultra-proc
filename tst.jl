module Tst
    include("tmp.jl")
    using .Tmp

    # add test code below
    #println(size(get_file()))
    a, b = xydata(get_file())
    println(a); println(b)

    

end