
datafile = joinpath(pwd(), "day1", "input.txt");
f = open(datafile, "r");
lines = readlines(f);
close(f);


# part 1
depths = parse.(Int64, lines);
ans = sum(diff(depths) .> 0);

println(ans)


# part 2: sliding window of 2
z = copy(depths)
for i in 2:length(depths) - 1
    z[i] = depths[i - 1] + depths[i] + depths[i + 1]
end
s = z[2:end-1]
ans2 = sum(diff(s) .> 0)
println(ans2)
