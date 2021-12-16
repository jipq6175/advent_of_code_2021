# day 8

# data
datafile = joinpath(pwd(), "day8", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

# get the 10 pattterns and number
function pattern_number(lines::Vector{String})
    patterns, numbers = Vector{String}(), Vector{String}()
    for line in lines
        pattern, number = split(line, " | ")
        push!(patterns, pattern)
        push!(numbers, number)
    end
    return patterns, numbers
end

patterns, numbers = pattern_number(lines)


# part 1
easy_length = [2, 3, 4, 7]
ans1 = 0
for number in numbers
    ans1 += sum(.!isnothing.(indexin(length.(split(number)), easy_length)))
end
println(ans1)


# part 2
function decode_mapping(pattern::String)
    digs = split(pattern)
    lens = length.(digs)

    # 1 & 7 >> a
    acf = digs[lens .== 3][1]
    cf = digs[lens .== 2][1]
    a = setdiff(acf, cf)[1]


    bcdf = digs[lens .== 4][1]
    abcdefg = digs[lens .== 7][1]


    ele6 = digs[lens .== 6]
    bfg = setdiff(intersect(ele6[1], ele6[2], ele6[3]), [a])
    c = setdiff(cf, bfg)[1]
    f = intersect(cf, bfg)[1]

    ele5 = digs[lens .== 5]
    dg = setdiff(intersect(ele5[1], ele5[2], ele5[3]), [a])
    g = intersect(bfg, dg)[1]
    d = setdiff(dg, bfg)[1]

    b = setdiff(bcdf, [c, d, f])[1]
    e = setdiff(abcdefg, [a, b, c, d, f, g])[1]

    rlt = Dict(a => 'a', b => 'b', c => 'c', d => 'd', e => 'e', f => 'f', g => 'g')
    return rlt
end


REPRESENTATION = Dict{String, Int64}("acdeg" => 2,
                                     "acdfg" => 3,
                                     "abdfg" => 5,
                                     "abdefg" => 6,
                                     "abcdfg" => 9,
                                     "abcefg" => 0)

function decode_digit(s::String, mp::Dict{Char, Char}, rep::Dict{String, Int64}=REPRESENTATION)

    if length(s) == 2
        return 1
    elseif length(s) == 3
        return 7
    elseif length(s) == 4
        return 4
    elseif length(s) == 7
        return 8
    else
        news = join(sort([mp[x] for x in collect(s)]))
        return rep[news]
    end
end


ans2 = 0
for i in 1:length(patterns)

    mp = decode_mapping(patterns[i])
    ns = String.(split(numbers[i]))
    value = 0
    for j in 1:4
        value += 10 ^ (4 - j) * decode_digit(ns[j], mp)
    end
    ans2 += value
end
