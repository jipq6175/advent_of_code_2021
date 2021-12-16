# day 9

datafile = joinpath(pwd(), "day9", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

data = zeros(Int64, length(lines), length(lines[1]))
for i in 1:length(lines)
    data[i, :] = parse.(Int64, split(lines[i], ""))
end


# part 1
function low_point_risk(data::Matrix{Int64})

    m, n = size(data)
    pad = 9 * ones(Int64, m + 2, n + 2)
    pad[2:end-1, 2:end-1] = data

    low_count, risk = 0, 0
    for i in 2:m+1
        for j in 2:n+1
            if pad[i, j] == 9
                continue
            else
                if (pad[i, j] < pad[i - 1, j]) && (pad[i, j] < pad[i, j - 1]) && (pad[i, j] < pad[i + 1, j]) && (pad[i, j] < pad[i, j + 1])
                    low_count += 1
                    risk += pad[i, j] + 1
                end
            end
        end
    end
    return low_count, risk
end

low_count, ans1 = low_point_risk(data)
println(ans1)


# part 2

function count_islands(data::Matrix{Int64})

    m, n = size(data)
    pad = 9 * ones(Int64, m + 2, n + 2)
    pad[2:end-1, 2:end-1] = data
    mat = pad .== 9

    i = 2
    sizes = Vector{Int64}()
    for i in 2:m+1
        for j in 2:n+1
            if !mat[i, j] # in the island
                q = Vector{Tuple{Int64, Int64}}()
                s = 0
                push!(q, (i, j))
                while length(q) > 0
                    u, v = popfirst!(q)
                    # println(u, " ", v)
                    mat[u, v] = true
                    s += 1
                    !mat[u + 1, v] && !in((u + 1, v), q) ? push!(q, (u + 1, v)) : nothing
                    !mat[u, v + 1] && !in((u, v + 1), q) ? push!(q, (u, v + 1)) : nothing
                    !mat[u - 1, v] && !in((u - 1, v), q) ? push!(q, (u - 1, v)) : nothing
                    !mat[u, v - 1] && !in((u, v - 1), q) ? push!(q, (u, v - 1)) : nothing
                end
                push!(sizes, s)
            end
        end
    end
    return sizes
end


@time sizes = count_islands(data)
sort!(sizes, rev=true)
ans2 = prod(sizes[1:3])
print(ans2)
