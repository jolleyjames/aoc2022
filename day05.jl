using Test

function load_input(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    stacks, instructions = [], []
    for line in lines
        if occursin("[", line)
            if length(stacks) == 0
                stacks = [[] for x in 1:(length(line)+1)/4]
            end
            for i in 2:4:length(line)
                if line[i] != ' '
                    pushfirst!(stacks[(i+2)÷4], line[i])
                end
            end
        elseif length(line) >= 4 && line[1:4] == "move"
            s = split(line, " ")
            push!(instructions, map(x -> parse(Int, x), [s[2],s[4],s[6]]))
        end
    end
    
    return stacks, instructions
end

function rearrange(stacks, instruction, version)
    if version == 2
        poploc = length(stacks[instruction[2]]) - instruction[1] + 1
    end
    for _ in 1:instruction[1]
        if version == 1
            poploc = length(stacks[instruction[2]])
        end
        c = popat!(stacks[instruction[2]], poploc)
        push!(stacks[instruction[3]], c)
    end
end

function go(path, part)
    stacks, instructions = load_input(path)
    for instr in instructions
        rearrange(stacks, instr, part)
    end
    return join(map(stack -> last(stack), stacks), "")

end

@test go("test_input/day05.txt", 1) == "CMZ"
@test go("test_input/day05.txt", 2) == "MCD"

println(go(ARGS[2], parse(Int, ARGS[1])))

