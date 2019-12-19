module Tst
    include("tmp.jl")
    using .Tmp

    # add test code below

    # test get_files
    original_file, conversion_file = get_files()
    println(size(original_file))
    println(size(conversion_file))

    # test add_wavenumbers
    wavenumbers_added = add_wavenumbers(original_file, conversion_file)
    println(size(wavenumbers_added))

    # test get_overlap_pixels
    lindex, rindex = get_overlap_pixels(wavenumbers_added)
    println(lindex, " ", rindex)

    # test remove_overlap
    remove_overlap(wavenumbers_added, lindex, rindex)

end