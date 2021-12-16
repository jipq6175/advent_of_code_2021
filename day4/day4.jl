# day 4

# load data
datafile = joinpath(pwd(), "day4", "input.txt")
f = open(datafile, "r")
lines = readlines(f)
close(f)

# organize data
draws = parse.(Int64, split(lines[1], ","));
boards = Dict{Int64, Matrix{Int64}}()
for i in 1:100
    ix = 6 * (i - 1) + 2
    board = Matrix{Int64}(undef, 5, 5)
    for j in 1:5
        board[j, :] = parse.(Int64, split(lines[ix + j]))
    end
    boards[i] = copy(board)
end


# utils
function check_bingo(bingo::BitMatrix)
    num_bingo_cols = sum(sum(bingo, dims=1) .== 5)
    num_bingo_rows = sum(sum(bingo, dims=2) .== 5)
    return (num_bingo_rows + num_bingo_cols) > 0
end


function bingo_at(board::Matrix{Int64}, draws::Vector{Int64})

    bingo = BitMatrix(undef, 5, 5)
    for i in 1:length(draws)

        draw = draws[i]
        bingo .|= (board .== draw)
        if check_bingo(bingo)
            return i
        end
    end
    return length(draws)
end


# part 1: first win
@time b = [bingo_at(boards[i], draws) for i in 1:length(boards)]

rd, board_idx = findmin(b)
draw = draws[rd]
bingo .= false
for i in 1:rd
    bingo .|= (boards[board_idx] .== draws[i])
end

ans = sum(boards[board_idx][.!bingo]) * draw
println(ans)


# part 2: last win
rd, board_idx = findmax(b)
draw = draws[rd]
bingo .= false
for i in 1:rd
    bingo .|= (boards[board_idx] .== draws[i])
end

ans2 = sum(boards[board_idx][.!bingo]) * draw
println(ans2)
