module Tmp

    # add exported definitions below
    export get_baseline_points


    # get user input with a custom msg
    function get_baseline_points()
        println("Enter desired points for baseline correction, separated by spaces:")
        string = readline()
        splitstring = split(string, " ")
        return [parse(Int, i) for i in splitstring]
    end


end