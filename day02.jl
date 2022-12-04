@enum Throw rock paper scissors

function shape_score(throw::Throw)
    if throw == rock
        return 1
    elseif throw == paper
        return 2
    else
        return 3
    end
end

using Test
@test shape_score(rock) == 1
@test shape_score(paper) == 2
@test shape_score(scissors) == 3

function round_scores(throw1::Throw, throw2::Throw)
    if throw1 == throw2
        return [3,3]
    elseif throw1 == rock
        if throw2 == scissors
            return [6,0]
        else
            return [0,6]
        end
    elseif throw1 == paper
        if throw2 == rock
            return [6,0]
        else
            return [0,6]
        end
    else
        if throw2 == paper
            return [6,0]
        else
            return [0,6]
        end
    end
end

@test round_scores(rock, rock) == [3,3]
@test round_scores(rock, paper) == [0,6]
@test round_scores(rock, scissors) == [6,0]
@test round_scores(paper, rock) == [6,0]
@test round_scores(paper, paper) == [3,3]
@test round_scores(paper, scissors) == [0,6]
@test round_scores(scissors, rock) == [0,6]
@test round_scores(scissors, paper) == [6,0]
@test round_scores(scissors, scissors) == [3,3]

function load_input(path, d)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    return map(line->map(c->d[c], split(line, " ")), lines)
end

function part1(path)
    d = Dict("A"=>rock, "B"=>paper, "C" => scissors, "X"=>rock, "Y"=>paper, "Z"=>scissors)
    throws = load_input(path, d)
    results = get_results_from_throws(throws)
    return sum(results)[2]
end

function get_results_from_throws(throws)
    return map(throw->round_scores(throw[1],throw[2])+[shape_score(throw[1]),shape_score(throw[2])], throws)
end

@test part1("test_input/day02.txt") == 15

@enum Result win draw loss

function generate_result(opp_throw::Throw, result::Result)
    if result == win
        if opp_throw == rock
            return paper
        elseif opp_throw == paper
            return scissors
        else
            return rock
        end
    elseif result == draw
        return opp_throw
    else
        if opp_throw == rock
            return scissors
        elseif opp_throw == paper
            return rock
        else
            return paper
        end
    end
end

@test generate_result(rock, loss) == scissors
@test generate_result(rock, draw) == rock
@test generate_result(rock, win) == paper
@test generate_result(paper, loss) == rock
@test generate_result(paper, draw) == paper
@test generate_result(paper, win) == scissors
@test generate_result(scissors, loss) == paper
@test generate_result(scissors, draw) == scissors
@test generate_result(scissors, win) == rock

function part2(path)
    d = Dict("A"=>rock, "B"=>paper, "C" => scissors, "X"=>loss, "Y"=>draw, "Z"=>win)
    games = load_input(path, d)
    throws = map(game->[game[1], generate_result(game[1],game[2])], games)
    results = get_results_from_throws(throws)
    return sum(results)[2]
end

@test part2("test_input/day02.txt") == 12

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    println(part2(ARGS[2]))
end
