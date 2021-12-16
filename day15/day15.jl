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
