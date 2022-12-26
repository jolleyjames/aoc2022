using Test

function load_input(path)
    lines = open(path) do file
        lines = readlines(file)
        lines
    end
    return lines
end

function forest_size(forest)
    return (length(forest[1]), length(forest))
end

@test forest_size(load_input("test_input/day08.txt")) == (5,5)

function is_visible(forest, x, y)
    size = forest_size(forest)
    trees_between = [y - 1, size[1] - x, size[2] - y, x - 1] # top, right, bottom, left
    while true
        dirx = argmin(trees_between)
        if trees_between[dirx] == 0
            return true
        elseif trees_between[dirx] == typemax(Int)
            break
        end
        visible = true
        if dirx == 1 #top
            yn = 1
            while yn <= y-1 && visible
                if forest[yn][x] >= forest[y][x]
                    visible = false
                end
                yn += 1
            end
        elseif dirx == 2 #right
            xn = x+1
            while xn <= size[1] && visible
                if forest[y][xn] >= forest[y][x]
                    visible = false
                end
                xn += 1
            end
        elseif dirx == 3 #bottom
            yn = y+1
            while yn <= size[2] && visible
                if forest[yn][x] >= forest[y][x]
                    visible = false
                end
                yn += 1
            end
        else #left
            xn = 1
            while xn <= x-1 && visible
                if forest[y][xn] >= forest[y][x]
                    visible = false
                end
                xn += 1
            end
        end
        if visible
            return true
        else
            trees_between[dirx] = typemax(Int)
        end
    end
    return false
end

test_forest = load_input("test_input/day08.txt")
@test is_visible(test_forest, 2, 1)
@test is_visible(test_forest, 5, 2)
@test is_visible(test_forest, 4, 5)
@test is_visible(test_forest, 1, 3)
@test is_visible(test_forest, 2, 2)
@test is_visible(test_forest, 3, 2)
@test !is_visible(test_forest, 4, 2)
@test is_visible(test_forest, 2, 3)
@test !is_visible(test_forest, 3, 3)
@test is_visible(test_forest, 4, 3)
@test !is_visible(test_forest, 2, 4)
@test is_visible(test_forest, 3, 4)
@test !is_visible(test_forest, 4, 4)

function part1(path)
    forest = load_input(path)
    size = forest_size(forest)
    return sum(1 for x in 1:size[1] for y in 1:size[2] if is_visible(forest, x, y))
end

@test part1("test_input/day08.txt") == 21

function viewing_score(forest, x, y)
    size = forest_size(forest)
    trees_between = [y - 1, size[1] - x, size[2] - y, x - 1] # top, right, bottom, left
    score = 1
    for dirx in 1:4
        if trees_between[dirx] == 0
            return 0
        elseif trees_between[dirx] == typemax(Int)
            break
        end
        if dirx == 1 #top
            yn = y - 1
            while yn > 0
                if forest[yn][x] >= forest[y][x]
                    break
                else
                    yn -= 1
                end
            end
            if yn == 0
                yn = 1
            end
            score *= (y-yn)
            if score == 0
                return 0
            end
        elseif dirx == 2 #right
            xn = x + 1
            while xn <= size[1]
                if forest[y][xn] >= forest[y][x]
                    break
                else
                    xn += 1
                end
            end
            if xn > size[1]
                xn = size[1]
            end
            score *= (xn - x)
            if score == 0
                return 0
            end
        elseif dirx == 3 #bottom
            yn = y + 1
            while yn <= size[2]
                if forest[yn][x] >= forest[y][x]
                    break
                else
                    yn += 1
                end
            end
            if yn > size[2]
                yn = size[2]
            end
            score *= (yn - y)
            if score == 0
                return 0
            end
        else #left
            xn = x - 1
            while xn > 0
                if forest[y][xn] >= forest[y][x]
                    break
                else
                    xn -= 1
                end
            end
            if xn == 0
                xn = 1
            end
            score *= (x - xn)
            if score == 0
                return 0
            end
        end
    end
    return score
end

@test viewing_score(test_forest, 3, 2) == 4
@test viewing_score(test_forest, 3, 4) == 8

function part2(path)
    forest = load_input(path)
    size = forest_size(forest)
    return maximum(viewing_score(forest, x, y) for x in 2:size[1]-1 for y in 2:size[2]-1)
end

@test part2("test_input/day08.txt") == 8

if (ARGS[1] == "1")
    println(part1(ARGS[2]))
elseif (ARGS[1] == "2")
    println(part2(ARGS[2]))
end
