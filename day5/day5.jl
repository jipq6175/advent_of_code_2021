# day 5
using StatsBase

# load the datafile
datafile = joinpath(pwd(), "day5", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)



# utils
function get_coord(line::String)
    v = split(line, " -> ")
    x1, y1 = parse.(Int64, split(v[1], ","))
    x2, y2 = parse.(Int64, split(v[2], ","))
    return x1, y1, x2, y2
end


# part 1
coords = Vector{Tuple{Int64, Int64}}()
for line in lines{}
    x1, y1, x2, y2 = get_coord(line)
    if x1 == x2
        append!(coords, [(x1, y) for y in min(y1, y2):max(y1, y2)])
    elseif y1 == y2
        append!(coords, [(x, y1) for x in min(x1, x2):max(x1, x2)])
    else
        continue
    end
end
htable = countmap(coords)
ans = 0
for (k, c) in htable
    if c >= 2
        ans += 1
    end
end
println(ans)



# part 2
coords = Vector{Tuple{Int64, Int64}}()
for line in lines
    x1, y1, x2, y2 = get_coord(line)
    if x1 == x2
        append!(coords, [(x1, y) for y in min(y1, y2):max(y1, y2)])
    elseif y1 == y2
        append!(coords, [(x, y1) for x in min(x1, x2):max(x1, x2)])
    else
        @assert abs(x1 - x2) == abs(y1 - y2)
        m = (y2 - y1) / (x2 - x1)
        d = abs(x2 - x1)
        if m > 0
            append!(coords, [(min(x1, x2) + i, min(y1, y2) + i) for i in 0:d])
        else
            append!(coords, [(min(x1, x2) + i, max(y1, y2) - i) for i in 0:d])
        end

    end
end
htable = countmap(coords)
ans2 = 0
for (k, c) in htable
    if c >= 2
        ans2 += 1
    end
end
println(ans2)
