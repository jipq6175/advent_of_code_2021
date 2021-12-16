
# load the data
datafile = joinpath(pwd(), "day2/", "input.txt");
f = open(datafile, "r");
lines = readlines(f);
close(f)


# part 1
horizontal = 0
depth = 0
for line in lines
    direction, val = split(line)
    v = parse(Int32, val)
    if direction == "forward"
        horizontal += v
    elseif direction == "up"
        depth -= v
    elseif direction == "down"
        depth += v
    else
        error("Unknown direction $direction")
    end
end

ans = horizontal * depth
println(ans)


# part 2
horizontal, depth, aim = 0, 0, 0
for line in lines
    direction, val = split(line)
    v = parse(Int32, val)
    if direction == "forward"
        depth += aim * v
        horizontal += v
    elseif direction == "up"
        aim -= v
    elseif direction == "down"
        aim += v
    else
        error("unknown direction $direction")
    end
end

ans2 = horizontal * depth
println(ans2)
