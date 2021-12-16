# day 11
datafile = joinpath(pwd(), "day11", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

data = zeros(Int64, length(lines), length(lines[1]))
for i in 1:length(lines)
    data[i, :] = parse.(Int64, split(lines[i], ""))
end


# part 1

# modify matrix and return counts
function one_step!(mat::Matrix{Int64})

    m, n = size(mat)
    pad = -32767 * ones(Int64, m + 2, n + 2)
    pad[2:m+1, 2:n+1] = mat
    pad .+= 1
    exploded = Set{Tuple{Int64, Int64}}()
    for i in 2:m+1
        for j in 2:n+1
            if pad[i, j] > 9 # start the chain reaction
                # println(i, j)
                to_explode = Vector{Tuple{Int64, Int64}}()
                push!(to_explode, (i, j))
                while length(to_explode) > 0
                    u, v = pop!(to_explode)
                    push!(exploded, (u, v))
                    # println((u, v))
                    pad[u-1:u+1, v-1:v+1] .+= 1
                    pad[u, v] = 0
                    for k in -1:1 for l in -1:1
                        pad[u + k, v + l] > 9 && !in((u + k, v + l), to_explode) ? push!(to_explode, (u + k, v + l)) : nothing
                    end end
                end
            end
        end
    end
    # set al the exploded to 0
    for (u, v) in exploded
        pad[u, v] = 0
    end
    mat[:, :] = pad[2:m+1, 2:n+1]
    return length(exploded)
end


# m = [1 1 1 1 1; 1 9 9 9 1; 1 9 1 9 1; 1 9 9 9 1; 1 1 1 1 1]
# one_step!(m)
# m
mat, n_explode = copy(data), Vector{Int64}()
for i in 1:100
    push!(n_explode, one_step!(mat))
end
ans1 = sum(n_explode)
println(ans1)



# part 2
mat, ans2 = copy(data), -1
for i in 1:1000
    n = one_step!(mat)
    if n == prod(size(mat))
        ans2 = i
        break
    end
end
println(ans2)
