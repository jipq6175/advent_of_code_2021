# day 12

datafile  = joinpath(pwd(), "day12", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

# build the undirected graph datastructure
edges = Dict{String, Vector{String}}()
for line in lines
    u, v = split(line, "-")
    haskey(edges, u) ? push!(edges[u], v) : edges[u] = [v]
    haskey(edges, v) ? push!(edges[v], u) : edges[v] = [u]
end


# part 1 use dfs and keep track of visited lowercases
# using recursion !?
function dfs!(node::String, edges::Dict{String, Vector{String}}, path::Vector{String}, paths::Vector{Vector{String}}, visited::Vector{String})

    if node in visited # termination without keeping the path
        return nothing
    else
        push!(path, node)

        if node == "end" # termination and keep the path
            push!(paths, path)
            return nothing
        end

        # mark lower case node as visited
        islowercase(node[1]) ? push!(visited, node) : nothing

        # move forward onto the next nodes
        for neighbor in edges[node]
            dfs!(neighbor, edges, copy(path), paths, copy(visited))
        end
    end
end

node = "start"
path, visited, paths = Vector{String}(), Vector{String}(), Vector{Vector{String}}()
dfs!(node, edges, path, paths, visited)
ans1 = length(paths)
println(ans1)


# part 2

# recursion with changes in the termination criteria
# visited becomes a hash table
function dfs!(node::String, edges::Dict{String, Vector{String}}, path::Vector{String}, paths::Vector{Vector{String}}, visited::Dict{String, Int64})

    if haskey(visited, node)
        # visited twice or start node
        if visited[node] == 2 || node == "start"
            return nothing
        end

        # visited another twice and this one once
        if (visited[node] == 1) && (2 in values(visited))
            return nothing
        end
    end

    push!(path, node)

    if node == "end" # terminate and keep path
        push!(paths, path)
        return nothing
    end

    # update visited hash table
    if islowercase(node[1])
        haskey(visited, node) ? visited[node] += 1 : visited[node] = 1
    end

    # move forward
    for neighbor in edges[node]
        dfs!(neighbor, edges, copy(path), paths, copy(visited))
    end

end

node = "start"
path, visited, paths = Vector{String}(), Dict{String, Int64}(), Vector{Vector{String}}()
dfs!(node, edges, path, paths, visited)
ans2 = length(paths)
println(ans2)
