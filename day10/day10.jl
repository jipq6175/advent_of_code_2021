# day 10

datafile = joinpath(pwd(), "day10", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)


# part 1

# use the ida of satck
function get_first_unmatching_right(s::String)

    left_brackets = ['[', '{', '<', '(']
    q = Vector{Char}()
    for c in collect(s)

        if c in left_brackets
            push!(q, c)
        else
            if (c == ')' && q[end] == '(') || (c == ']' && q[end] == '[') || (c == '>' && q[end] == '<') || (c == '}' && q[end] == '{')
                pop!(q)
            else
                return c
            end
        end
    end
    return length(q) > 0 ? 'i' : 'd'
end


chars = [get_first_unmatching_right(line) for line in lines]
PRIZE = Dict{Char, Int64}(')' => 3, ']' => 57, '}' => 1197, '>' => 25137, 'd' => 0, 'i' => 0)
ans1 = sum([PRIZE[c] for c in chars])
println(ans1)


# part 2

function determine_ending_seq(s::String)

    left_brackets = ['[', '{', '<', '(']
    q = Vector{Char}()
    for c in collect(s)

        if c in left_brackets
            push!(q, c)
        else
            if (c == ')' && q[end] == '(') || (c == ']' && q[end] == '[') || (c == '>' && q[end] == '<') || (c == '}' && q[end] == '{')
                pop!(q)
            else
                error("not incomplete, corrupted!!")
            end
        end
    end

    mp = Dict{Char, Char}('{' => '}', '(' => ')', '[' => ']', '<' => '>')
    return [mp[q[end - i + 1]] for i in 1:length(q)]
end


function calculate_score(seq::Vector{Char})

    mp = Dict{Char, Int64}(')' => 1, ']' => 2, '}' => 3, '>' => 4)
    score = 0
    for c in seq
        score = 5 * score + mp[c]
    end
    return score
end



incomplete_lines = lines[chars .== 'i']
scores = sort([calculate_score(determine_ending_seq(incomplete_line)) for incomplete_line in incomplete_lines])
ans2 = scores[Int64(floor(53 / 2)) + 1]
println(ans2)
