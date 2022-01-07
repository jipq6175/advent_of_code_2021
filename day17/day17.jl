# day17

# part 2
tx = [211, 232]
ty = [-124, -69]

function hit(x::Int64, y::Int64, tx::Vector{Int64}=tx, ty::Vector{Int64}=ty)
    return tx[1] <= x <= tx[2] && ty[1] <= y <= ty[2]
end

function miss(x::Int64, y::Int64, vx::Int64, vy::Int64, tx::Vector{Int64}=tx, ty::Vector{Int64}=ty)
    return (x - tx[2]) * vx > 0 || (y - ty[1]) < 0
end

function trial(vx::Int64, vy::Int64, tx::Vector{Int64}=tx, ty::Vector{Int64}=ty)
    x, y = 0, 0
    while true
        # println((x, y))
        x += vx
        y += vy
        if hit(x, y, tx, ty)
            return true
        end

        vx = sign(vx) * (abs(vx) - 1)
        vy -= 1
        if miss(x, y, vx, vy, tx, ty)
            return false
        end
    end
end


trial(7, 0, [20, 30], [-10,-5])

ans2 = 0
@elapsed for vx in 20:232
    for vy in -124:123
        if trial(vx, vy, tx, ty)
            ans2 += 1
        end
    end
end
println(ans2)
