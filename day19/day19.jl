

# function get_displacement i <> j
# capturing i - j  and j - i
function displacement_set(coord::Matrix{Int64})
    n = size(coord, 1)
    d = Dict{Tuple{Int64, Int64}, Vector{Int64}}()
    for i in 1:n for j in 1:n
        if i != j d[(i, j)] = coord[i, :] - coord[j, :] end
    end end
    return d
end

function generate_rotations()
    R1 = [0 0 -1; 0 1 0; 1 0 0]
    R2 = [1 0 0; 0 0 -1; 0 1 0]
    R3 = [0 -1 0; 1 0 0; 0 0 1]
    result = []
    for x = 0:3, y = 0:3, z = 0:3
        m = R1^x * R2^y * R3^z
        push!(result, m)
    end
    return unique(result)
end


# get all the coordinates using 2 pairs 
# one with known coordinate: scanner 0 at (0, 0, 0)
# get the coordinate of the other
# rot is the rotation of sc0 relative to scanner 0
function get_beacons(sc0::Matrix{Int64}, coord0::Vector{Int64}, sc1::Matrix{Int64}, rot::Matrix{Int64})

    rotations = generate_rotations()
    beacons = coord1 = idx = nothing
    x = y = common = nothing
    for i in 1:24
        x = displacement_set(sc0)
        y = displacement_set(sc1 * rotations[i])
        common = intersect(values(x), values(y))
        if length(common) >= 12 * 11
            idx = i
            break
        end
    end

    # scanner 0 and 1 do not overlap
    if isnothing(idx) return beacons, coord1, nothing end

    sc1_corrected = sc1 * rotations[idx]
    invx = Dict{Vector{Int64}, Tuple{Int64, Int64}}()
    for k in keys(x) invx[x[k]] = k end
    invy = Dict{Vector{Int64}, Tuple{Int64, Int64}}()
    for k in keys(y) invy[y[k]] = k end

    # mapping from ith beacon to 
    mapping = Dict{Int64, Int64}()
    for c in common 
        mapping[invx[c][1]] = invy[c][1]
        mapping[invx[c][2]] = invy[c][2] 
    end
    
    # compute the coordinates for scanner 1 relative to scanner 0
    k = collect(keys(mapping))[1]
    coord1 = sc0[k, :] - sc1_corrected[mapping[k], :]
    for m in keys(mapping) @assert sc0[k, :] - sc1_corrected[mapping[k], :] == coord1 end
    # get the absolute scanner coordinates
    coord1 = rot * coord1 + coord0

    # get the absolute beacon coordinate
    beacons1 = sc0 * rot .+ transpose(coord0)
    beacons2 = sc1_corrected * rot .+ transpose(coord1)
    beacons = unique(vcat(beacons1, beacons2), dims=1)

    return beacons, coord1, rotations[idx]
end


function read_file(datafile::String)

    f = open(datafile)
    lines = readlines(f)
    close(f)

    scanner, dct = -1, Dict{Int64, Matrix{Int64}}()
    for line in lines
        if length(line) == 0 continue end
        if startswith(line, "---")
            scanner += 1 
            dct[scanner] = Matrix{Int64}(undef, 0, 3)
            continue
        end

        dct[scanner] = vcat(dct[scanner], transpose(parse.(Int64, split(line, ","))))
    end
    return dct
end
        


function get_all_beacons(dct::Dict{Int64, Matrix{Int64}})
    
    coords, relative_rots = Dict{Int64, Vector{Int64}}(), Dict{Int64, Matrix{Int64}}()
    for i in keys(dct) coords[i] = zeros(Int64, 3) end
    relative_rots[0] = [1 0 0; 0 1 0; 0 0 1]

    n = length(dct)
    all_beacons = Matrix{Int64}(undef, 0, 3)
    
    # 1 vs all others
    for i in 1:n-1 
        println(i)
        beacons, coord, rot = get_beacons(dct[0], coords[0], dct[i], relative_rots[0])
        isnothing(coord) ? continue : nothing
        coords[i] = coord
        relative_rots[i] = rot
        all_beacons = vcat(all_beacons, beacons)
    end

    # the rest if not matched
    round = 0
    while (length(unique(values(coords))) < length(coords)) && round < 50
        # loop through all un-identified scanner and try pairing with those identified ones
        for i in 1:n-1
            if coords[i] != zeros(Int64, 3) continue end
            for j in 1:n-1
                i == j ? continue : nothing
                if coords[j] != zeros(Int64, 3) 
                    beacons, coord, __ = get_beacons(dct[j], coords[j], dct[i], relative_rots[j])
                    isnothing(coord) ? continue : nothing
                    coords[i] = coord
                    all_beacons = vcat(all_beacons, beacons)
                end
            end
        end
        round += 1
        println(round, " ", coords)
    end
    return all_beacons
end

datafile = joinpath(pwd(), "day19", "test.txt")
d = read_file(datafile)

# I = [1 0 0; 0 1 0; 0 0 1]
# __, coord1, rot = get_beacons(d[0], [0, 0, 0], d[1], I)
# bc, coord4, __ = get_beacons(d[1], coord1, d[4], rot)
# rot * coord4 + coord1
all_beacons = get_all_beacons(d)

# failed
