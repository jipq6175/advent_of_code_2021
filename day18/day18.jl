# day18

datafile = joinpath(pwd(), "day18", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

test = "[[[[[9,8],1],2],3],4]"

# some utility functions 
DIGITS = collect('0':'9')

# find the indices for the deepest nested pairs
# [[[[[9,8],1],2],3],4] -> (5, 9)
function deepest_nested_pair(s::String, target::Int=4)
    depth = 0
    for (i, a) in enumerate(s)
        depth += a == '[' ? 1 : a == ']' ? -1 : 0
        if depth > target 
            return (i, findnext(']', s, i))
        end
    end
    return nothing
end


# find the index of the left digits
function find_digit_index(s::String, p::Tuple{Int, Int}; option::String="left")
    increment = option == "left" ? -1 : 1
    search_start = option == "left" ? p[1] : p[2]
    search_end = option == "left" ? 1 : length(s)
    
    idx = nothing
    for i in search_start:increment:search_end
        if s[i] in DIGITS
            idx = i
            break
        end
    end

    # did not find
    if isnothing(idx) return idx end
    
    if s[idx + increment] in DIGITS
        return min(idx, idx + increment), max(idx, idx + increment)
    else
        return idx, idx
    end
end


# distribute the number to the left and right
# inplace  
function distribute(s::String, p::Tuple{Int, Int})

    m = match(r"\[(\d+),(\d+)\]", s[p[1]:p[2]])

    # right
    right_idx = find_digit_index(s, p; option="right")
    # right_m = match(r"(\d+)", s, right_idx)

    if !isnothing(right_idx)
        right_rlt = string(parse(Int64, s[right_idx[1]:right_idx[2]]) + parse(Int64, m[2]))
        s = s[1:right_idx[1]-1] * right_rlt * s[right_idx[2]+1:end]
    end

    # left 
    left_idx = find_digit_index(s, p; option="left")
    shift = false
    if !isnothing(left_idx)
        left_rlt = string(parse(Int64, s[left_idx[1]:left_idx[2]]) + parse(Int64, m[1]))
        s = s[1:left_idx[1]-1] * left_rlt * s[left_idx[2]+1:end]
        
        original_length = left_idx[2] - left_idx[1] + 1
        shift = (original_length < length(left_rlt))
    end
    
    # replace the pair with 0
    u, v = shift ? (p[1] + 1, p[2] + 1) : p
    s = s[1:u-1] * "0" * s[v+1:end]

    return s
end
        

# explode the number 
function explode(s::String) 
    p = deepest_nested_pair(s)
    return isnothing(p) ? s : distribute(s, p)
end


# split the number for the 
# find the index for the double digits
function dd_index(s::String)
    idx = -1
    for (i, a) in enumerate(s)
        (i == 1) | (i == length(s)) ? continue : nothing
        
        if (a in DIGITS) && (s[i + 1] in DIGITS)
            idx = i
            break
        end
    end
    return idx
end


# split the string using the dd_index
function split(s::String)
    idx = dd_index(s)
    if idx == -1 
        return s
    end

    n = parse(Int64, s[idx:idx+1])
    left, right = string(Int(floor(n/2))), string(Int(ceil(n/2)))
    s = s[1:idx-1] * "[" * left * "," * right * "]" * s[idx+2:end]
    return s
end    


# reduce 
function reduce(s::String)
    rs = s
    i = 0
    while true
        i += 1
        # explode
        p = deepest_nested_pair(rs)
        if !isnothing(p) 
            rs = explode(rs)
            # println("explode", rs)
            continue
        end
        # break

        # split
        idx = dd_index(rs)
        if idx != -1
            # println("pre-split", rs)
            rs = split(rs)
            # println("post-split", rs)
            continue
        end
        
        break
    end
    return rs
end


function find_pair(s::String)

    left, right = 0, 0
    for (i, a) in enumerate(s)
        left = a == '[' ? i : left
        if a == ']'
            right = i
            break
        end
    end
    return left, right
end


# compute the magnitude using 
function magnitude(s::String)

    st = s
    
    i = 0
    while '[' in st
        
        # get the nested 
        left, right = find_pair(st)
        # get the m1 and m2
        m = match(r"\[(\d+),(\d+)\]", st[left:right])
        # calculation 
        num = string(3 * parse(Int, m[1]) + 2 * parse(Int, m[2]))
        # replace the bracket with calculated value
        st = st[1:left-1] * num * st[right+1:end]
    
    end
    return st
end

# add 2 strings
function add(s1::String, s2::String)
    return "[" * s1 * "," * s2 * "]"
end



##### part 1
rlt = lines[1]
for i in 2:length(lines)
    rlt = reduce(add(rlt, lines[i]))
end
print(magnitude(rlt))


##### part 2
M = 0
for i in 1:length(lines)
    for j in i+1:length(lines)
        si, sj = lines[i], lines[j]
        trial = max(parse(Int, magnitude(reduce(add(si, sj)))), parse(Int, magnitude(reduce(add(sj, si)))))
        M = trial > M ? trial : M
    end
end
print(M)        