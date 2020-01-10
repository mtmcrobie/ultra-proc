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
    new = yninput("Do you want to process a fresh dataset?")

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

        confirm_baseline = yninput("Start baseline correction?")
        if confirm_baseline == false
            continue
        else
            @label baseline_correction
            include("BaselineCorrect.jl")
        end

        confirm_removepo = yninput("Remove pixel overlap?")
        if confirm_removepo == false
            continue
        else
            @label remove_po
            include("RemovePO.jl")
        end

        confirm_kinetics = yninput("Start kinetic analysis?")
        if confirm_kinetics == false
            continue
        else
            @label kinetics
            include("Kinetics.jl")
        end


    elseif new == false
        skip = userinput("[B]aseline correction, [R]emove pixel overlap, or [K]inetics?")
        #code
        if skip == "b" || skip == "B"
            @goto baseline_correction
        elseif skip == "r" || skip == "R"
            @goto remove_po
        elseif skip == "k" || skip == "K"
            @goto kinetics
        end
        
    end
end


end
