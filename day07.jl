using Test

abstract type File end

struct RegularFile <: File
    name::String
    size::Int
end

struct Directory <: File
    name::String
    parent::Union{Directory,Nothing}
    children::Dict{String,File}
end

size(rf::RegularFile) = rf.size
size(d::Directory) = sum(size(f) for f in values(d.children))
size(f::File) = size(f)

function load_input(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    root = Directory("/", nothing, Dict())
    wd = root
    n = 1
    while n <= length(lines)
        if startswith(lines[n], "\$ cd")
            next_dir = split(lines[n], " ")[3]
            if next_dir == "/"
                wd = root
            elseif next_dir == ".."
                if isnothing(wd.parent)
                    wd = root
                else
                    wd = wd.parent
                end
            else
                wd = wd.children[next_dir]
            end
            n += 1
        elseif startswith(lines[n], "\$ ls")
            n += 1
            while n <= length(lines) && !startswith(lines[n], "\$")
                size_type, name = split(lines[n], " ")
                if size_type == "dir"
                    child = Directory(name, wd, Dict())
                else
                    child = RegularFile(name, parse(Int, size_type))
                end
                wd.children[name] = child
                n += 1
            end
        else
            throw(ArgumentError("line $n: invalid command: $(lines[n])"))
        end
    end
    return root
end

test_root = load_input("test_input/day07.txt")
test_a = test_root.children["a"]
test_d = test_root.children["d"]
test_e = test_a.children["e"]
@test size(test_e) == 584
@test size(test_a) == 94853
@test size(test_d) == 24933642
@test size(test_root) == 48381165

function part1(path)
    dir_queue = [load_input(path)]
    total_size = 0
    while length(dir_queue) > 0
        wd = popfirst!(dir_queue)
        for child in values(wd.children)
            if typeof(child) == Directory
                push!(dir_queue, child)
            end
        end
        wd_size = size(wd)
        if wd_size <= 100000
            total_size += wd_size
        end
    end
    return total_size
end

@test part1("test_input/day07.txt") == 95437

function part2(path)
    dir_queue = [load_input(path)]
    space_needed = -40000000+size(dir_queue[1])
    smallest_dir_size = nothing
    while length(dir_queue) > 0
        wd = popfirst!(dir_queue)
        for child in values(wd.children)
            if typeof(child) == Directory
                push!(dir_queue, child)
            end
        end
        wd_size = size(wd)
        if wd_size >= space_needed && (isnothing(smallest_dir_size) || wd_size < smallest_dir_size)
            smallest_dir_size = wd_size
        end
    end
    return smallest_dir_size
end

@test part2("test_input/day07.txt") == 24933642

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    println(part2(ARGS[2]))
end
