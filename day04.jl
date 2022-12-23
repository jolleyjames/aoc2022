using Test

function load_input(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    return map(line -> map(pair -> map(s -> parse(Int, s), split(pair, "-")), split(line, ",")) , lines)
end

function is_subset(assignments)
    if assignments[1][1] >= assignments[2][1] && assignments[1][2] <= assignments[2][2]
        return 1
    elseif assignments[2][1] >= assignments[1][1] && assignments[2][2] <= assignments[1][2]
        return 2
    else
        return 0
    end
end

function is_overlap(assignments)
    return assignments[1][2] >= assignments[2][1] && assignments[2][2] >= assignments[1][1]
end

function part1(path)
    subsets = [is_subset(asgnmt) for asgnmt in load_input(path)]
    return length(filter(x -> x != 0, subsets))
end

@test part1("test_input/day04.txt") == 2

function part2(path)
    subsets = [is_overlap(asgnmt) for asgnmt in load_input(path)]
    return length(filter(x -> x, subsets))
end

@test part2("test_input/day04.txt") == 4

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    println(part2(ARGS[2]))
end
