# day 3 puzzle

datafile = joinpath(pwd(), "day3", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

n = length(lines)
m = length(lines[1])

data = BitMatrix(undef, n, m)
for i in 1:n
    data[i, :] = parse.(Bool, split(lines[i], ""))
end


# part 1

# bit arr to int
function bitarr_to_int(arr::BitVector, val::Int64=0)
    v = 1
    for i in view(arr, length(arr):-1:1)
        val += v*i
        v <<= 1
    end
    return val
end

b_gamma = sum(data, dims=1) .> (n / 2)
γ = bitarr_to_int(b_gamma[1, :])
ϵ = bitarr_to_int(.!b_gamma[1, :])
ans = γ * ϵ
println(ans)


# part 2

function find_o2_co2(data::BitMatrix)

    o2, co2 = copy(data), copy(data)
    m = size(data, 2)
    for i in 1:m
        # o2
        if size(o2, 1) > 1
            b = sum(o2[:, i]) >= size(o2, 1) / 2
            o2 = o2[o2[:, i] .== b, :]
        end

        # co2
        if size(co2, 1) > 1
            b = sum(co2[:, i]) < size(co2, 1) / 2
            co2 = co2[co2[:, i] .== b, :]
        end
    end
    return o2, co2
end
o2, co2 = find_o2_co2(data)
o2_level, co2_level = bitarr_to_int(o2[1, :]), bitarr_to_int(co2[1, :])
ans2 = o2_level * co2_level
println(ans2)
