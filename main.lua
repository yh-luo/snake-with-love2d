WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 1024
TILE_SIZE = 32

MAX_TILES_X = math.floor(WINDOW_WIDTH / TILE_SIZE)
MAX_TILES_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE)

-- time the snake moves one tile
SNAKE_SPEED = 0.1
math.randomseed(os.time())
-- randomly generate the snake
local snakeBody = {{math.random(MAX_TILES_X-1), math.random(MAX_TILES_Y-1)}}
local score = 0
local snakeTimer = 0
local apple = {}
local direction = {0, 0}

function love.load()
    love.window.setTitle('Snake')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setFont(love.graphics.newFont(32))

    -- create an apple
    createApple()
end

function love.update(dt)
    snakeTimer = snakeTimer + dt

    if snakeTimer >= SNAKE_SPEED then
        -- moving
        moveSnake()
        if snakeBody[#snakeBody][1] == apple[1] and snakeBody[#snakeBody][2] == apple[2] then
            score = score + 1
            -- update the snake
            table.insert(snakeBody, 1, {snakeBody[1][1]-direction[1], snakeBody[1][2]-direction[2]})
            -- create an new apple
            createApple()
        end

        -- reset the timer
        snakeTimer = 0
    end

end

function love.draw()
    drawScore()
    drawApple()
    drawSnake()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'left' then
        direction = {-1, 0}
    elseif key == 'right' then
        direction = {1, 0}
    elseif key == 'up' then
        direction = {0, -1}
    elseif key == 'down' then
        direction = {0, 1}
    end
end

function appleInSnake()
    for _, value in ipairs(snakeBody) do
        if value[1] == apple[1] and value[2] == apple[2] then
            return true
        end
    end
    return false
end

function createApple()
    while true do
        -- check if the apple is inside the snake
        apple = {math.random(MAX_TILES_X-1), math.random(MAX_TILES_Y-1)}
        if not appleInSnake() then
            break
        end
    end
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

function moveSnake()
    snakeBody[#snakeBody] = {snakeBody[#snakeBody][1]+direction[1], snakeBody[#snakeBody][2]+direction[2]}
    -- FIXME: when the score is 1, the snake does not increament its length
    for i = 1, #snakeBody-1 do
        snakeBody[i] = snakeBody[i+1]
    end
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

-- TODO: check if the snake bump into itself