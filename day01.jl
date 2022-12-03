function load_input(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    elves, elf = [], []
    for line in lines
        if line == ""
            push!(elves, elf)
            elf = []
        else
            push!(elf, parse(Int, line))
        end
    end
    push!(elves, elf)
    return elves
end

function part1(path)
    elves = load_input(path)
    return sum(elves[argmax(map((elf)->sum(elf), elves))])
end

function part2(path)
    elves = load_input(path)
    sort!(elves, by=elf->sum(elf), rev=true)
    return sum(map(elf->sum(elf), elves[begin:3]))
end

using Test
@test part1("test_input/day01.txt") == 24000
@test part2("test_input/day01.txt") == 45000


if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    println(part2(ARGS[2]))
end
