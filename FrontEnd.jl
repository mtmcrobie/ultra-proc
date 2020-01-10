#!/usr/bin/env Julia
module FrontEnd

include("BaseFunctions.jl")
include("SortRaw.jl")

import .BaseFunctions: userinput, yninput
import .SortRaw.sortraw
#= imported modules
import Kinetics
import RemovePO
import SortOrg
=#


# start of execution flow

println("Welcome to ULTRAproc! Enter [Q] at any prompt to [Q]uit.")

while true
    new = yninput("Do you want to process a fresh dataset? [Y/N]")

    if new == true
        new_file_present = findfirst(x -> x == "Run 0 Avg Diff spec 01.csv", readdir())

        if new_file_present == nothing
            println("Could not find 'Run 0 Avg Diff spec 01.csv'.")
            println("Please ensure it is in the same directory and try again.")
            continue
        end

        confirm_start = yninput("Start processing $(pwd())/Run 0 Avg Diff spec 01.csv?")

        if confirm_start == false
            continue # go to start of program
        end

        sorted = sortraw("Run 0 Avg Diff spec 01.csv")
        
        @label baseline_correction
        include("BaselineCorrect.jl")

        @label remove_po
        include("RemovePO.jl")

        @label kinetics
        include("Kinetics.jl")


    elseif new == false
        userinput("[B]aseline correction, [R]emove pixel overlap, or [K]inetic analysis?")
        #code
    end
end


end
