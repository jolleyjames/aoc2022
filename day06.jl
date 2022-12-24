using Test

function load_input(path)
    line = open(path) do file
        line = readline(file)
        line
    end
    return line
end

function find_unique(s::String, window::Int)
    for n in 1:length(s)+1-window
        if length(Set(c for c in s[n:n+window-1])) == window
            return n+window-1
        end
    end
    return nothing
end

function part1(path)
    s = load_input(path)
    return find_unique(s, 4)
end

@test part1("test_input/day06_1.txt") == 7
@test part1("test_input/day06_2.txt") == 5
@test part1("test_input/day06_3.txt") == 6
@test part1("test_input/day06_4.txt") == 10
@test part1("test_input/day06_5.txt") == 11

function part2(path)
    s = load_input(path)
    return find_unique(s, 14)
end

@test part2("test_input/day06_1.txt") == 19
@test part2("test_input/day06_2.txt") == 23
@test part2("test_input/day06_3.txt") == 23
@test part2("test_input/day06_4.txt") == 29
@test part2("test_input/day06_5.txt") == 26

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    println(part2(ARGS[2]))
end
