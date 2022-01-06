# day 16

datafile = joinpath(pwd(), "day16", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

packets = lines[1]

# packets to bits
function to_bits(packets::String)

    bits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
    dct = Dict{String, BitVector}()
    for (index, bit) in enumerate(bits)
        dct[bit] = convert(BitVector, reverse(digits(index - 1, base=2, pad=4)))
    end

    rlt = BitVector()
    for i in 1:length(packets)
        rlt = vcat(rlt, dct[packets[i:i]])
    end
    return rlt
end

# bit to int
function bitarr_to_int(arr::BitVector)
    return sum(arr .* (2 .^ collect(length(arr)-1:-1:0)))
end


# part 1: recursive
function parse!(arr::BitVector, versions::Vector{Int64})

    version = bitarr_to_int(arr[1:3])
    push!(versions, version)
    # println(length(versions))
    arr = arr[4:end]

    tid = bitarr_to_int(arr[1:3])
    arr = arr[4:end]
    if tid == 4
        t = BitVector()
        while true
            t = vcat(t, arr[2:5])
            term = arr[1]
            arr = arr[6:end]
            !term ? break : nothing
        end
    else
        ltid = arr[1]
        arr = arr[2:end]
        if ltid
            n_subpackets = bitarr_to_int(arr[1:11])
            arr = arr[12:end]
            for i in 1:n_subpackets
                arr = parse!(arr, versions)
            end
        else
            length_subpackets = bitarr_to_int(arr[1:15])
            arr = arr[16:end]
            subpackets = arr[1:length_subpackets]
            while length(subpackets) > 6
                subpackets = parse!(subpackets, versions)
            end
            arr = arr[length_subpackets+1:end]
        end
    end
    return arr
end

# p = "8A004A801A8002F478"
arr = to_bits(packets)
versions = Vector{Int64}()
parse!(arr, versions)
ans1 = sum(versions)
println(ans1)


# part 2
function parse_compute!(arr::BitVector, versions::Vector{Int64})

    version = bitarr_to_int(arr[1:3])
    push!(versions, version)
    # println(length(versions))
    arr = arr[4:end]

    tid = bitarr_to_int(arr[1:3])
    arr = arr[4:end]
    if tid == 4
        t = BitVector()
        while true
            t = vcat(t, arr[2:5])
            term = arr[1]
            arr = arr[6:end]
            !term ? break : nothing
        end
        return (arr, bitarr_to_int(t))
    else
        ltid = arr[1]
        arr = arr[2:end]
        subpacket_values = Vector{Int64}()

        if ltid
            n_subpackets = bitarr_to_int(arr[1:11])
            arr = arr[12:end]
            for i in 1:n_subpackets
                arr, value = parse_compute!(arr, versions)
                push!(subpacket_values, value)
            end
        else
            length_subpackets = bitarr_to_int(arr[1:15])
            arr = arr[16:end]
            subpackets = arr[1:length_subpackets]
            while length(subpackets) > 6
                subpackets, value = parse_compute!(subpackets, versions)
                push!(subpacket_values, value)
            end
            arr = arr[length_subpackets+1:end]
        end

        if tid == 0
            rlt = sum(subpacket_values)
        elseif tid == 1
            rlt = prod(subpacket_values)
        elseif tid == 2
            rlt = minimum(subpacket_values)
        elseif tid == 3
            rlt = maximum(subpacket_values)
        elseif tid == 5
            rlt = subpacket_values[1] > subpacket_values[2] ? 1 : 0
        elseif tid == 6
            rlt = subpacket_values[1] < subpacket_values[2] ? 1 : 0
        elseif tid == 7
            rlt = subpacket_values[1] == subpacket_values[2] ? 1 : 0
        end
        return (arr, rlt)
    end
end

p = "9C0141080250320F1802104A08"
arr = to_bits(packets)
versions = Vector{Int64}()
__, ans2 = parse_compute!(arr, versions)
println(ans2)
