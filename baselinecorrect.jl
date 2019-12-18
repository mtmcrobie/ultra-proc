# using these functions
using DelimitedFiles, Polynomials

# function definitions

# get input from user
function userinput(msg)
	println(msg)
	chomp(readline())
end

# get rid of first 250 ps and return array of remaining spectra
function droptimes()
	arr = readdlm("all_procesd_spectra_.csv", ',')
	smallarr = hcat(arr[:, 1], arr[:, 42:end])
	return smallarr
end


# stitch all times back together
function stitch(corrected)
	original = readdlm("all_procesd_spectra_.csv", ',')
	earlytimes = original[2:end, 41]
	delays = original[1, : ]
	arrout = hcat(original[2:end, 41], corrected)
	arrout = vcat(original[1, : ], arrout)




# create initial global variables (future work: find faster method)
#delays = arrin[1, : ]
#pixels = arrin[:, 1]
#arrin = arrin[2:end, : ]
#indexl = arrin[1:128, 1]
#indexr = arrin[129:end, 1]
#spectra = arrin[:, 2:end]
#fitpointsl = [11, 34, 56, 77, 103, 117]
#fitpointsr = [144, 158, 177, 205, 221, 240]
#yindiciesl = [findfirst(isequal(i), indexl) for i in fitpointsl]
#yindiciesr = [findfirst(isequal(j), indexr) for j in fitpointsr]


# get left y-values for polynomial fitting
function ysforpolyfitl(arrin)
	spectral = arrin[2:129, 2:end]
	indexl = arrin[2:129, 1]
	fitpointsl = [11, 34, 56, 77, 103, 117]
	yindiciesl = [findfirst(isequal(n), indexl) for n in fitpointsl]

	ys = [spectral[j, 1] for j in yindiciesl]
	for i in 2:length(spectral[1, : ])
		temp =  [spectral[j, i] for j in yindiciesl]
		ys = hcat(ys, temp)
	end
	return ys
end


# get right y-values for polynomial fitting
function ysforpolyfitr(arrin)
	spectrar = arrin[130:end, 2:end]
	indexr = arrin[130:end, 1]
	fitpointsr = [144, 158, 177, 205, 221, 240]
	yindiciesr = [findfirst(isequal(n), indexr) for n in fitpointsr]

	ys = [spectrar[j, 1] for j in yindiciesr]
	for i in 2:length(spectrar[1, : ])
		temp =  [spectrar[j, i] for j in yindiciesr]
		ys = hcat(ys, temp)
	end
	return ys
end

# generate array of baseline subtractions for left detector
function genbasesubsl(arrin, polys)
	indexl = arrin[2:129, 1]
	subs = [polyval(polys[1], j) for j in indexl]
	for i in 2:length(polys)
		temp = [polyval(polys[i], j) for j in indexl]
		subs = hcat(subs, temp)
	end
	return subs
end


# generate array of baseline subtractions for right detector
function genbasesubsr(arrin, polys)
	indexr = arrin[130:end, 1]
	subs = [polyval(polys[1], j) for j in indexr]
	for i in 2:length(polys)
		temp = [polyval(polys[i], j) for j in indexr]
		subs = hcat(subs, temp)
	end
	return subs
end


# get array of left detector polynomials
function polynomialsl(yvalues)
	fitpointsl = [11, 34, 56, 77, 103, 117]
	polys = [polyfit(fitpointsl, yvalues[:, i]) for i in 1:length(yvalues[1, : ])]
	return polys
end


# get array of right detector polynomials
function polynomialsr(yvalues)
	fitpointsr = [144, 158, 177, 205, 221, 240] 
	polys = [polyfit(fitpointsr, yvalues[:, i]) for i in 1:length(yvalues[1, : ])]
	return polys
end

# get array of corrected baseline corrected spectra
function subtractbase(arrin, subs)
	spectra = arrin[2:end, 2:end]
	corrected = spectra .- subs
	return corrected
end

# code below here
const arrin = droptimes()
const fitpointsl = [11, 34, 56, 77, 103, 117]
const fitpointsr = [144, 158, 177, 205, 221, 240]
subs = vcat(genbasesubsl(arrin, polynomialsl(ysforpolyfitl(arrin))), genbasesubsr(arrin, polynomialsr(ysforpolyfitr(arrin))))

corrected = subtractbase(arrin, subs)
println(size(corrected))
outarr = arrin[2:end, 1]
println(size(outarr))
outarr = hcat(outarr, corrected)
println(size(outarr))
outarr = vcat(transpose(arrin[1, : ]), outarr)
println(size(outarr))

writedlm("testset.csv", outarr, ',')
