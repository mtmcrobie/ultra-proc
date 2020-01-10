module SortRaw

using DelimitedFiles

export sortraw

function sortraw(file::String)
    println("Sorting raw data")
    inarr = readdlm(file, ',')
    nopixels = @view inarr[:, 2:end]
    pixels = @view inarr[:, 1]

    sorted = sortslices(nopixels, dims = 2)
    outarr = [pixels sorted]
    writedlm("all_procesd_spectra_sorted.csv", outarr, ',')
    return outarr
end

end
