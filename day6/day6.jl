# day6

datafile = joinpath(pwd(), "day6", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

counts = parse.(Int8, split(lines[1], ","))
length(counts)

# part 1
# the idea is to use a hash table and update counts in each day
using StatsBase: countmap

cmap = countmap(counts)
cmap[0] = cmap[6] = cmap[7] = cmap[8] = 0

# pass one day and do permutation
function pass_one_day!(cmap::Dict{Int8, Int64})
    n_zeros = cmap[0]
    for i in 0:7
        cmap[i] = cmap[i + 1]
    end
    cmap[8] = n_zeros
    cmap[6] += n_zeros
    return nothing
end

x = copy(cmap)
for i in 1:80
    pass_one_day!(x)
end
ans = sum(values(x))
print(ans)


# part2
x = copy(cmap)
for i in 1:256
    pass_one_day!(x)
end
ans2 = sum(values(x))
print(ans2)
