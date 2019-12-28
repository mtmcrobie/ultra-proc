module SortRaw

using DelimitedFiles

export sortraw

function sortraw(file::String)
    inarr = readdlm(file, ',')
    nopixels = @view inarr[:, 2:end]
    pixels = @view inarr[:, 1]

    sorted = sortslices(nopixels, dims = 2)
    outarr = [pixels sorted]
    return outarr
end

end