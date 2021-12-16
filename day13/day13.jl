# day 13

datafile = joinpath(pwd(), "day13", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

ix = findall(lines .== "")[1]
indices = zeros(Int64, ix - 1, 2)
for i in 1:ix-1
    indices[i, :] = parse.(Int64, split(lines[i], ","))
end

folding = lines[ix+1:end]

# part 1

function foldy(indices::Matrix{Int64}, y::Int64)
    m, n = size(indices)
    xmax, ymax = maximum(indices, dims=1)
    ts = Set{Tuple{Int64, Int64}}()
    for i in 1:m
        xx, yy = indices[i, 1], indices[i, 2]
        if yy < y
            push!(ts, (xx, yy))
        elseif yy > y
            push!(ts, (xx, ymax - yy))
        end
    end
    new_indices = zeros(Int64, length(ts), 2)
    for (i, t) in enumerate(ts)
        new_indices[i, 1], new_indices[i, 2] = t[1], t[2]
    end
    return new_indices
end


function foldx(indices::Matrix{Int64}, x::Int64)
    m, n = size(indices)
    xmax, ymax = maximum(indices, dims=1)
    ts = Set{Tuple{Int64, Int64}}()
    for i in 1:m
        xx, yy = indices[i, 1], indices[i, 2]
        if xx < x
            push!(ts, (xx, yy))
        elseif xx > x
            push!(ts, (xmax - xx, yy))
        end
    end
    new_indices = zeros(Int64, length(ts), 2)
    for (i, t) in enumerate(ts)
        new_indices[i, 1], new_indices[i, 2] = t[1], t[2]
    end
    return new_indices
end


new_indices = foldx(indices, 655)
ans1 = size(new_indices, 1)
println(ans1)




# part 2
ax, val = [], []
for line in folding
    s = split(split(line, " ")[3], "=")
    push!(ax, String(s[1]))
    push!(val, parse(Int64, s[2]))
end

function fold(indices::Matrix{Int64}, val::Int64, option::String)
    return option == "x" ? foldx(indices, val) : foldy(indices, val)
end

mat = copy(indices)
for i in 1:length(val)
    mat = fold(mat, val[i], ax[i])
end


# decode the image
xmax, ymax = maximum(mat, dims=1)
data = Matrix{String}(undef, ymax + 1, xmax + 1)
data .= "."
for i in 1:size(mat, 1)
    data[6 - mat[i, 2], 40 - mat[i, 1] - 1] = "*"
end

for i in 1:size(data, 1)
    l = join(data[i, :], " ")
    println(l)
end


# Weird issues for part 2
# FPEKBEJL
