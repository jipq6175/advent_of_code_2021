# day 15

datafile = joinpath(pwd(), "day15", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

maze = zeros(Int64, length(lines), length(lines[1]))
for i in 1:length(lines)
    maze[i, :] = parse.(Int64, split(lines[i], ""))
end


# dp may fail because it only considers right and down movements
function dp(maze::Matrix{Int64})
    m, n = size(maze)
    risk = deepcopy(maze)
    for i in 2:m risk[i, 1] += risk[i - 1, 1] end
    for j in 2:n risk[1, j] += risk[1, j - 1] end
    for i in 2:m for j in 2:n
        risk[i, j] += min(risk[i - 1, j], risk[i, j - 1])
    end end
    return risk[m, n] - risk[1, 1]
end

@time r = dp(maze)

# part 1 using bfs
function bfs!(maze::Matrix{Int64}, indices::Vector{Tuple{Int64, Int64}}, index::Tuple{Int64, Int64}, visited::BitMatrix)


    m, n = size(maze)
    if index[1] == m && index[2] == n
        push!(indices, index)
        return nothing
    end

    u, v = index
    if visited[u, v]
        return nothing
    else
        push!(indices, index)
        visited[u, v] = true
    end

    to_go, m = (0, 0), 10
    for i in -1:2:1
        for j in -1:2:1
            if !visited[u+i, v+i] && m >= u+i >= 1 && n >= v+i >= 1
                if maze[u+i, v+i] < m
                    m = maze[u+i, v+i]
                    to_go = (u+i, v+i)
                end
            end
        end
    end

    bfs!(maze, copy(indices), to_go, copy(visited))
end


indices = Vector{Tuple{Int64, Int64}}()
index = (1, 1)
visited =
bfs!(maze, indices, index)


# implement dijkstra's algorithm
function dijkstra(maze::Matrix{Int64})

    m, n = size(maze)

    # create the coord set
    Q = Set([(i, j) for i in 1:m for j in 1:n])

    # dist and prev
    dist = Dict{Tuple{Int64, Int64}, Int64}()
    prev = Dict{Tuple{Int64, Int64}, Tuple{Int64, Int64}}()
    for q in Q
        dist[q] = typemax(Int64)
        prev[q] = (0, 0)
    end

    # set source = 0
    source, target = (1, 1), (m, n)
    dist[source] = 0

    while length(Q) > 0

        # find the coord in Q with smallest dist
        u, d = (0, 0), typemax(Int64)
        for q in Q
            if dist[q] < d
                d = dist[q]
                u = q
            end
        end
        @assert d < typemax(Int64)

        delete!(Q, u)
        u == target ? break : nothing

        # get neihbors that's in Q
        neighbors = intersect(Q, Set([(u[1]-1, u[2]), (u[1], u[2]-1), (u[1]+1, u[2]), (u[1], u[2]+1)]))
        for v in neighbors
            alt = dist[u] + maze[v[1], v[2]]
            if alt < dist[v]
                dist[v] = alt
                prev[v] = u
            end
        end
    end
    return dist, prev
end



@elapsed dist, prev = dijkstra(maze)
ans1 = dist[(100, 100)]
println(ans1)


# part 2
# construct the full map
maze2 = repeat(maze, outer=(5, 5))
for i in 1:5 for j in 1:5
    maze2[100*(i-1)+1:100*i, 100*(j-1)+1:100*j] .+= i + j - 2
end end
maze2 .%= 9
maze2[maze2 .== 0] .= 9

@elapsed dist, prev = dijkstra(maze2)
ans2 = dist[(500, 500)]
println(ans2)
