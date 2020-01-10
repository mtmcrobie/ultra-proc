#!/usr/bin/env Julia
module BaseFunctions

# export these functions
export userinput, yninput

# get user input after msg prompt.
function userinput(msg::String)
    print(msg, "\n>")
    msgout = readline()

    if msgout == "q" || msgout == "Q"
        println("Quitting ULTRAproc")
        exit()
    else
        return msgout
    end
end


# get y/n decision from user
function yninput(msg::String)
    print(msg, "\n[y/n]>")
    yn = readline()

    if yn == "q" || yn == "Q"
        println("Quitting ULTRAproc")
        exit()
    elseif yn == "y" || yn == "Y"
        return true
    elseif yn == "n" || yn == "N"
        return false
    else
        println("I don't understand. Please enter 'y', 'n', or to quit enter 'q'.")
    end
end


end
