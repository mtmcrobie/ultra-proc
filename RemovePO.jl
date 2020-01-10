# using these
using DelimitedFiles, Plots

# add exported definitions below
export get_files
export add_wavenumbers
export get_overlap_pixels
export remove_overlap


# get user input with a custom msg
function get_files()
    println("Getting files...")
    org, conv = readdlm("baseline_corrected.csv", ','), readdlm("conversion.csv", ',')
    return org, conv
end

# add wavenumbers to input file
function add_wavenumbers(original_file, conversion_file)
    println("Adding wavenumbers...")
    wavenumbers_added = hcat(conversion_file, original_file[:, 2:end])
    return wavenumbers_added
end


# get overlap pixels
function get_overlap_pixels(wavenumbers_added)
    println("Enter the last pixel on left detector and first pixel on right detector, separated by a space: ")
    pixelsin = split(readline())
    lpix, rpix = parse(Int, pixelsin[1]), parse(Int, pixelsin[2])
    lindex = findfirst(isequal(lpix), wavenumbers_added[:, 1])
    rindex = findfirst(isequal(rpix), wavenumbers_added[:, 1])
    return lindex, rindex
end
    

# remove pixel overlap
function remove_overlap(wavenumbers_added, lindex, rindex)
    println("Removing pixel overlap...")
    po_removed = vcat(wavenumbers_added[1:lindex, :], wavenumbers_added[rindex:end, :])
    writedlm("pixel_overlap_removed.csv", po_removed, ',')
    println("Plotting...")
    pyplot()
    porplot = plot(po_removed[2:end, 2],
                   po_removed[2:end, findfirst(isequal(5), po_removed[1, :])],
                   label = "5 ns")
    png(porplot, "porplot")
end

# code below here

original_file, conversion_file = get_files()
wavenumbers_added = add_wavenumbers(original_file, conversion_file)
lindex, rindex = get_overlap_pixels(wavenumbers_added)
remove_overlap(wavenumbers_added, lindex, rindex)

exit()
