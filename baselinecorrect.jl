# using these functions
using DelimitedFiles, Polynomials

# function definitions

# get user input for left baseline points
function get_baseline_points_l()
	println("Enter desired points for left baseline correction, separated by spaces:")
	string = readline()
	splitstring = split(string, " ")
	return [parse(Int, i) for i in splitstring]
end


# get user input for right baseline points
function get_baseline_points_r()
	println("Enter desired points for right baseline correction, separated by spaces:")
	string = readline()
	splitstring = split(string, " ")
	return [parse(Int, i) for i in splitstring]
end


# get order of polynomial for fitting
function get_polynomial_order()
	println("Enter polynomial order:")
	return parse(Int, readline())
end


# get rid of first 250 ps and return array of remaining spectra
function droptimes()
	println("getting input file")
	arr = readdlm("all_procesd_spectra_.csv", ',')
	pixels = @view arr[:, 1]
	longdelays = @view arr[:, 42:end]
	smallarr = hcat(pixels, longdelays)
	return smallarr
end


# stitch all times back together
function stitch(corrected)
	println("compiling output")
	original = readdlm("all_procesd_spectra_.csv", ',')
	shortdelays = @view original[2:end, 1:41]
	delays = @view original[1, :]
	arrout = vcat(transpose(delays), hcat(shortdelays, corrected))
	return arrout
end


# get left y-values for polynomial fitting
function ysforpolyfitl(arrin)
	spectral = @view arrin[2:129, 2:end]
	indexl = @view arrin[2:129, 1]
	yindiciesl = [findfirst(isequal(n), indexl) for n in fitpointsl]

	println("generate y-values for polynomial fit (left)")
	ys = [spectral[k, 1] for k in yindiciesl]
	for i in 2:length(spectral[1, : ])
		temp =  [spectral[j, i] for j in yindiciesl]
		ys = hcat(ys, temp)
	end
	return ys
end


# get right y-values for polynomial fitting
function ysforpolyfitr(arrin)
	spectrar = @view arrin[130:end, 2:end]
	indexr = @view arrin[130:end, 1]
	yindiciesr = [findfirst(isequal(n), indexr) for n in fitpointsr]

	println("generate y-values for polynomial fit (right)")
	ys = [spectrar[k, 1] for k in yindiciesr]
	for i in 2:length(spectrar[1, : ])
		temp =  [spectrar[j, i] for j in yindiciesr]
		ys = hcat(ys, temp)
	end
	return ys
end


# generate array of baseline subtractions for left detector
function genbasesubsl(arrin, polys)
	indexl = @view arrin[2:129, 1]
	println("generating baseline subtractions (left)")
	subslist = [polyval(polys[i], indexl) for i in 1:length(polys)]
	subs = subslist[1]
	for i in 2:length(subslist)
		subs = hcat(subs, subslist[i])
	end
	return subs
end


# generate array of baseline subtractions for right detector
function genbasesubsr(arrin, polys)
	indexr = @view arrin[130:end, 1]
	println("generating baseline subtractions (right)")
	subslist = [polyval(polys[i], indexr) for i in 1:length(polys)]
	subs = subslist[1]
	for i in 2:length(subslist)
		subs = hcat(subs, subslist[i])
	end
	return subs
end

# get array of left detector polynomials
function polynomialsl(yvalues)
	println("fitting polynomials (left)")
	polys = [polyfit(fitpointsl, yvalues[:, i], order) for i in 1:length(yvalues[1, : ])]
	return polys
end


# get array of right detector polynomials
function polynomialsr(yvalues)
	println("fitting polynomials (right)")
	polys = [polyfit(fitpointsr, yvalues[:, i], order) for i in 1:length(yvalues[1, : ])]
	return polys
end

# get array of corrected baseline corrected spectra
function subtractbase(arrin, subs)
	spectra = @view arrin[2:end, 2:end]
	println("subtracting baselines")
	corrected = spectra .- subs
	return corrected
end

# code below here
const fitpointsl = get_baseline_points_l()
const fitpointsr = get_baseline_points_r()
const order = get_polynomial_order()

const arrin = droptimes()
const subs = vcat(genbasesubsl(arrin, polynomialsl(ysforpolyfitl(arrin))), genbasesubsr(arrin, polynomialsr(ysforpolyfitr(arrin))))
const corrected = subtractbase(arrin, subs)

const outarr = stitch(corrected)

writedlm("baseline_corrected.csv", outarr, ',')
println("complete")
exit()
