WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 960
TILE_SIZE = 32

MAX_TILES_X = math.floor(WINDOW_WIDTH / TILE_SIZE)-1
MAX_TILES_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE)-1

LEFT = {-1, 0}
RIGHT = {1, 0}
UP = {0, -1}
DOWN = {0, 1}

-- time the snake moves one tile
SNAKE_SPEED = 0.1

local snakeBody, score, snakeTimer, apple, direction, endingTimer = nil
local ending = false
math.randomseed(os.time())

function gameReset()
    love.graphics.setFont(love.graphics.newFont(32))
    -- randomly generate the snake
    snakeBody = {{math.random(MAX_TILES_X), math.random(MAX_TILES_Y)}}
    score = 0
    snakeTimer = 0
    apple = {}
    direction = {0, 0}
    ending = false
    endingTimer = 0
    -- create an apple
    createApple()
end

function appleInSnake()
    for i = 1, #snakeBody do
        if table.concat(snakeBody[i]) == table.concat(apple) then
            return true
        end
    end
    return false
end

function createApple()
    while true do
        -- check if the apple is inside the snake
        apple = {math.random(MAX_TILES_X), math.random(MAX_TILES_Y)}
        if not appleInSnake() then
            break
        end
    end
end

function moveSnake()
    for i = 1, #snakeBody-1 do
        snakeBody[i] = snakeBody[i+1]
    end
    snakeBody[#snakeBody] = {snakeBody[#snakeBody][1]+direction[1], snakeBody[#snakeBody][2]+direction[2]}
    for i = 1, #snakeBody do
        -- check if the snake is out of the boundaries
        if snakeBody[i][1] > MAX_TILES_X then
            snakeBody[i][1] = 0
        elseif snakeBody[i][1] < 0 then
            snakeBody[i][1] = MAX_TILES_X
        end
        if snakeBody[i][2] > MAX_TILES_Y then
            snakeBody[i][2] = 0
        elseif snakeBody[i][2] < 0 then
            snakeBody[i][2] = MAX_TILES_Y
        end
    end

end

-- check if the snake bump into itself
function snakeCollide()
    for i = 1, #snakeBody-2 do
        if table.concat(snakeBody[i]) == table.concat(snakeBody[#snakeBody]) then
            return true
        end
    end
    return false
end

function drawSnake()
    love.graphics.setColor(0, 1, 0)
    -- draw the snake
    for i = 1, #snakeBody do
        love.graphics.rectangle('fill', snakeBody[i][1]*TILE_SIZE, snakeBody[i][2]*TILE_SIZE,
                                TILE_SIZE, TILE_SIZE)
    end
end

function drawApple()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', apple[1]*TILE_SIZE, apple[2]*TILE_SIZE,
                            TILE_SIZE, TILE_SIZE)
end

-- show the score
function drawScore()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Score: ' .. tostring(score), 10, 10)
end

function drawEnding()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(48))
    love.graphics.print('Final Score: ' .. tostring(score), math.floor(WINDOW_WIDTH/2)-100, math.floor(WINDOW_HEIGHT/2)-100)
end


function love.load()
    love.window.setTitle('Snake')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    gameReset()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'left' and (#snakeBody == 1 or table.concat(direction) ~= table.concat(RIGHT)) then
        direction = LEFT
    elseif key == 'right' and (#snakeBody == 1 or table.concat(direction) ~= table.concat(LEFT)) then
        direction = RIGHT
    elseif key == 'up' and (#snakeBody == 1 or table.concat(direction) ~= table.concat(DOWN)) then
        direction = UP
    elseif key == 'down' and (#snakeBody == 1 or table.concat(direction) ~= table.concat(UP)) then
        direction = DOWN
    end
end

function love.update(dt)
    if not snakeCollide() then
        snakeTimer = snakeTimer + dt
        if snakeTimer >= SNAKE_SPEED then
            if table.concat(snakeBody[#snakeBody]) == table.concat(apple) then
                score = score + 1
                -- update the snake
                table.insert(snakeBody, 1, {snakeBody[1][1]-direction[1], snakeBody[1][2]-direction[2]})
                -- create an new apple
                createApple()
            end
            -- moving
            moveSnake()
            -- reset the timer
            snakeTimer = 0
        end
    else
        -- create a timer for ending
        endingTimer = endingTimer + dt
        if endingTimer >= 3 then
            gameReset()
        end
    end
end

function love.draw()
    if not snakeCollide() then
        drawScore()
        drawApple()
        drawSnake()
    else
        drawEnding()
    end
end
