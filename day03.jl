using Test

function get_priority(c::Char)
    if c >= 'a' && c <= 'z'
        return (c - 'a') + 1
    elseif c >= 'A' && c <= 'Z'
        return (c - 'A') + 27
    end
end

@test get_priority('a') == 1
@test get_priority('b') == 2
@test get_priority('c') == 3
@test get_priority('x') == 24
@test get_priority('y') == 25
@test get_priority('z') == 26
@test get_priority('A') == 27
@test get_priority('B') == 28
@test get_priority('C') == 29
@test get_priority('X') == 50
@test get_priority('Y') == 51
@test get_priority('Z') == 52

function load_input(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    rucksacks = []
    for line in lines
        s1, s2 = Set(), Set()
        for x in eachindex(line)
            if x <= length(line)/2
                s = s1
            else
                s = s2
            end
            push!(s, line[x])
        end
        push!(rucksacks, (s1, s2))
    end
    return rucksacks
end

function priority_overlap(rucksack)
    overlap = intersect(rucksack[1], rucksack[2])
    return sum(map(item->get_priority(item), collect(overlap)))
end

function part1(path)
    rucksacks = load_input(path)
    return sum(map(r->priority_overlap(r), rucksacks))
end

@test part1("test_input/day03.txt") == 157

function load_input_2(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    groups, group = [], []
    for line in lines
        push!(group, line)
        if length(group) == 3
            push!(groups, group)
            group = []
        end
    end
    return groups
end

function priority_overlap_2(group)
    overlap = intersect(group[1], group[2])
    overlap = intersect(overlap, group[3])
    return sum(map(item->get_priority(item), collect(overlap)))
end

function part2(path)
    groups = load_input_2(path)
    return sum(map(g->priority_overlap_2(g), groups))
end

@test part2("test_input/day03.txt") == 70

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    println(part2(ARGS[2]))
end

