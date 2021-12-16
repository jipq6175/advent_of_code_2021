
# day14.jl
using StatsBase: countmap

datafile = joinpath(pwd(), "day14", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

template = lines[1]

# build the data dictionary
orders = Dict{String, String}()
for i in 3:length(lines)
    p, ins = String.(split(lines[i], " -> "))
    orders[p] = ins
end


# part 1

# the idea is to get the insertion index
# then do the insersion from tail to head
function polymer_step!(template::String, orders::Dict{String, String})

    insertion_dct = Dict{Int64, String}()
    ps = keys(orders)

    for i in (length(template) - 1):-1:1
        subs = template[i:i+1]
        if subs in ps
            template = template[1:i] * orders[subs] * template[i+1:end]
        end
    end
    return template
end


t = template
@time for i in 1:10
    t = polymer_step!(t, orders)
end


ht = countmap(t)
ans1 = maximum(values(ht)) - minimum(values(ht))
println(ans1)


# part 2
# need a better algorithm or data representation
# only need to update the letter counts and pair counts?
function polymer_step_eff!(letter_counts::Dict{Char, Int64}, pair_counts::Dict{String, Int}, orders::Dict{String, String})
    new_pair_counts = copy(pair_counts)
    for (p, ins) in orders # cannot do this in order
        pair_count = pair_counts[p]
        # println(p, " ", pair_count)
        letter_counts[ins[1]] += pair_count
        new_pair_counts[p[1:1] * ins] += pair_count
        new_pair_counts[ins * p[2:2]] += pair_count
    end
    for (p, ins) in orders
        new_pair_counts[p] -= pair_counts[p]
    end
    return new_pair_counts
end


# build the letter counts and pair counts
letters = unique(join(keys(orders)))
letter_counts = Dict{Char, Int64}((x, 0) for x in letters)
pair_counts = Dict{String, Int64}((join([x, y]), 0) for x in letters for y in letters)
for letter in collect(template)
    letter_counts[letter] += 1
end

for i in 1:length(template)-1
    pair_counts[template[i:i+1]] += 1
end

@time for i in 1:40
    pair_counts = polymer_step_eff!(letter_counts, pair_counts, orders)
end

ans2 = maximum(values(letter_counts)) - minimum(values(letter_counts))
println(ans2)
