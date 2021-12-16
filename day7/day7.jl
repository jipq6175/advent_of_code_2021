# day 7

# data
datafile = joinpath(pwd(), "day7", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)
x = parse.(Int64, split(lines[1], ","))


# part 1
# this is finding the median
# but which one, if length(x) %2 == 0?
function find_alignment(x::Vector{Int64})

    pos = sort(x)
    n = length(pos)
    if n % 2 != 0
        cand = pos[Int64(ceil(n / 2))]
        return cand, sum(abs.(pos .- cand))
    else
        n2 = Int64(n / 2)
        cand1 = pos[n2]
        dist1 = sum(abs.(pos .- cand1))

        cand2 = pos[n2 + 1]
        dist2 = sum(abs.(pos .- cand2))

        return dist1 <= dist2 ? (cand1, dist1) : (cand2, dist2)
    end
end

alignment, ans1 = find_alignment(x)
println(ans1)


# part 2
# cost becomes linear
function cost(d::Int64)
    return Int64(d * (d + 1) / 2)
end
pos = sort(x)
costs = [sum(cost.(abs.(pos .- i))) for i in pos]
