using Test

struct Monkey
    items::Vector{Int}
    op::Function
    divisor::Int
    true_monkey::Int
    false_monkey::Int
end

get_operation(a::Int, op::Function, b::Int) = x -> op(a,b)
get_operation(a::String, op::Function, b::Int) = x -> op(x,b)
get_operation(a::Int, op::Function, b::String) = x -> op(a,x)
get_operation(a::String, op::Function, b::String) = x -> op(x,x)
function get_operation(s::String)::Function
    s = split(s, " ")
    if s[1] == "old"
        a = ""
    else
        a = parse(Int, s[1])
    end
    if s[2] == "+"
        b = +
    elseif s[2] == "*"
        b = *
    else
        throw(ArgumentError("illegal operator $s[2]"))
    end
    if s[3] == "old"
        c = ""
    else
        c = parse(Int, s[3])
    end
    return get_operation(a, b, c)
end

function load_monkeys(path)::Vector{Monkey}
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    monkeys = []
    while length(lines) >= 6
        items = map(x -> parse(Int,x), split(split(lines[2], ": ")[2], ", "))
        op = get_operation(string(split(lines[3], " = ")[2]))
        divisor = parse(Int, split(lines[4], " by ")[2])
        true_monkey, false_monkey = (parse(Int, split(line, " monkey ")[2]) for line in lines[5:6])
        push!(monkeys, Monkey(items, op, divisor, true_monkey, false_monkey))
        lines = lines[8:end]
    end
    return monkeys
end

function round(monkeys::Vector{Monkey}, reduce_worry::Bool)
    insp_counts = []
    for monkey in monkeys
        push!(insp_counts, length(monkey.items))
        while length(monkey.items) > 0
            item = popfirst!(monkey.items)
            item = monkey.op(item)
            if reduce_worry
                item ÷= 3
            end
            if item % monkey.divisor == 0
                next_monkey = monkey.true_monkey
            else
                next_monkey = monkey.false_monkey
            end
            push!(monkeys[next_monkey + 1].items, item)
        end
    end
    return insp_counts
end

function go(path, rounds, reduce_worry)
    monkeys = load_monkeys(path)
    insp_counts = [0 for _ in monkeys]
    for _ in 1:rounds
        insp_counts += round(monkeys, reduce_worry)
    end
    sort!(insp_counts, rev=true)
    return insp_counts[1] * insp_counts[2]
end

function part1(path)
    go(path, 20, true)
end

@test part1("test_input/day11.txt") == 10605

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    #println(part2(ARGS[2]))
end
