using Test

function load_input(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    return map(line -> line_to_instruction(line), lines)
end

function line_to_instruction(line)
    s = split(line, " ")
    return [s[1], parse(Int, s[2])]
end

function move_lead(direction, lead)
    if direction == "R"
        lead[2] += 1
    elseif direction == "L"
        lead[2] -= 1
    elseif direction == "U"
        lead[1] -= 1
    elseif direction == "D"
        lead[1] += 1
    else
        throw(ArgumentError("illegal direction $direction"))
    end
end

function distance(a, b)
    y_dist = a[1] - b[1]
    x_dist = a[2] - b[2]
    return y_dist*y_dist + x_dist*x_dist
end

function move_follower(follower, leader)
    d = distance(follower, leader)
    if d == 0 || d == 1 || d == 2
        #don't move
    elseif d == 4
        if follower[1] < leader[1]
            follower[1] = leader[1]-1
        elseif follower[1] > leader[1]
            follower[1] = leader[1]+1
        elseif follower[2] < leader[2]
            follower[2] = leader[2]-1
        else
            follower[2] = leader[2]+1
        end
    elseif d == 5 || d == 8
        if follower[1] < leader[1]
            follower[1] += 1
        else
            follower[1] -= 1
        end
        if follower[2] < leader[2]
            follower[2] += 1
        else
            follower[2] -= 1
        end        
    else
        throw(ArgumentError("unexpected distance $d between follower $follower, leader $leader"))
    end
end

#=
function part1(path)
    movements = load_input(path)
    head, tail = [0,0], [0,0]
    tail_positions = Set()
    while length(movements) > 0
        if movements[1][2] == 0
            popfirst!(movements)
        else
            move_head(movements[1][1], head)
            move_tail(tail, head)
            push!(tail_positions, (tail[1], tail[2]))
            movements[1][2] -= 1
        end
    end
    return length(tail_positions)
end

@test part1("test_input/day09.txt") == 13
=#

function go(path, rope_length)
    movements = load_input(path)
    rope = [[0,0] for _ in 1:rope_length]
    tail_positions = Set()
    while length(movements) > 0
        if movements[1][2] == 0
            popfirst!(movements)
        else
            move_lead(movements[1][1], rope[1])
            for n in 1:length(rope)-1
                move_follower(rope[n+1], rope[n])
            end
            tail_position = (rope[length(rope)][1], rope[length(rope)][2])
            push!(tail_positions, tail_position)
            movements[1][2] -= 1
        end
    end
    return length(tail_positions)
end

@test go("test_input/day09_1.txt", 2) == 13
@test go("test_input/day09_1.txt", 10) == 1
@test go("test_input/day09_2.txt", 10) == 36


if (ARGS[1] == "1")
    println(go(ARGS[2], 2))
elseif (ARGS[1] == "2")
    println(go(ARGS[2], 10))
end
