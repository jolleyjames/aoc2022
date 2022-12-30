using Test

Instruction = Tuple{String, Vararg{Any}}

mutable struct Cpu
    x::Int
    cycle::Int
    instr::Int
    const program::Vector{Instruction}
    function Cpu(program::Vector{Instruction})
        return new(1, 0, 1, program)
    end
end

function str_to_instr(s::String)::Instruction
    if s == "noop"
        return ("noop",)
    elseif startswith(s, "addx ")
        return ("addx", parse(Int, split(s, " ")[2]))
    else
        throw(ArgumentError("Illegal instruction $s"))
    end
end

instr_cycle_dict = Dict("noop" => 1, "addx" => 2)

function cycle(cpu::Cpu)
    if cpu.instr <= length(cpu.program)
        cpu.cycle += 1
        if cpu.cycle == instr_cycle_dict[cpu.program[cpu.instr][1]]
            # perform instruction
            if cpu.program[cpu.instr][1] == "addx"
                cpu.x += cpu.program[cpu.instr][2]
            end
            cpu.instr += 1
            cpu.cycle = 0
        end
    end
end

function load_cpu(path)::Vector{Instruction}
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    return map(s -> str_to_instr(s), lines)
end

test_cpu = Cpu(load_cpu("test_input/day10_1.txt"))
test_registers = []
for _ in 1:5
    cycle(test_cpu)
    push!(test_registers, test_cpu.x)
end
@test test_registers == [1, 1, 4, 4, -1]

sig_strength(cpu::Cpu, cyc_count) = cyc_count * cpu.x

function part1(path)
    cpu = Cpu(load_cpu(path))
    sig_str_sum = 0
    for n in 1:220
        if n%40 == 20
            sig_str_sum += sig_strength(cpu, n)
        end
        cycle(cpu)
    end
    return sig_str_sum
end

@test part1("test_input/day10_2.txt") == 13140

function draw_line(cpu::Cpu)::String
    line = ""
    for n in 0:39
        if cpu.x-1 <= n <= cpu.x+1
            line *= '#'
        else
            line *= ' '
        end
        cycle(cpu)
    end
    return line
end

function part2(path)
    cpu = Cpu(load_cpu(path))
    lines = []
    for _ in 1:6
        push!(lines, draw_line(cpu))
    end
    return lines
end

test_lines = part2("test_input/day10_2.txt")
@test test_lines[1]=="##  ##  ##  ##  ##  ##  ##  ##  ##  ##  "
@test test_lines[2]=="###   ###   ###   ###   ###   ###   ### "
@test test_lines[3]=="####    ####    ####    ####    ####    "
@test test_lines[4]=="#####     #####     #####     #####     "
@test test_lines[5]=="######      ######      ######      ####"
@test test_lines[6]=="#######       #######       #######     "

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    for line in part2(ARGS[2])
        println(line)
    end
end
