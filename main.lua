WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 1024
TILE_SIZE = 32

MAX_TILES_X = math.floor(WINDOW_WIDTH/TILE_SIZE)
MAX_TILES_Y = math.floor(WINDOW_HEIGHT/TILE_SIZE)

-- time the snake moves one tile
SNAKE_SPEED = 0.1

-- because index starts from 1 in Lua
local snakeX, snakeY = nil, nil -- unneccessary but nice practice to keep variables local
-- local tileGrid = {}
local snakeBody = {}
local score = 0
local snakeTimer = 0
local appleX, appleY = nil, nil -- unneccessary but nice practice to keep variables local


function love.load()
    love.window.setTitle('Snake')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.graphics.setFont(love.graphics.newFont(32))
    math.randomseed(os.time())
    -- randomly generate the snake
    snakeX = math.random(MAX_TILES_X-1)
    snakeY = math.random(MAX_TILES_Y-1)
    -- create an apple
    createApple()
end

function love.update(dt)
    snakeTimer = snakeTimer + dt

    if snakeTimer >= SNAKE_SPEED then
        if snakeX == appleX and snakeY == appleY then
            score = score + 1
            -- create an new apple
            createApple()
        end
        -- moving
        moveSnake()
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
        snakeMoving = 'left'
    elseif key == 'right' then
        snakeMoving = 'right'
    elseif key == 'up' then
        snakeMoving = 'up'
    elseif key == 'down' then
        snakeMoving = 'down'
    end
end

function createApple()
    appleX = math.random(MAX_TILES_X-1)
    appleY = math.random(MAX_TILES_Y-1)
end

function drawSnake()
    -- draw the head
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', snakeX*TILE_SIZE, snakeY*TILE_SIZE, TILE_SIZE, TILE_SIZE)
end

function drawApple()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', appleX*TILE_SIZE, appleY*TILE_SIZE, TILE_SIZE, TILE_SIZE)
end

-- show the score
function drawScore()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Score: ' .. tostring(score), 10, 10)
end

function moveSnake()
    if snakeMoving == 'left' then
        snakeX = snakeX - 1
    elseif snakeMoving == 'right' then
        snakeX = snakeX + 1
    elseif snakeMoving == 'up' then
        snakeY = snakeY - 1
    elseif snakeMoving == 'down' then
        snakeY = snakeY + 1
    end
    -- check if the snake is out of the boundaries
    if snakeX > MAX_TILES_X then
        snakeX = 1
    elseif snakeX < 1 then
        snakeX = MAX_TILES_X
    end
    if snakeY > MAX_TILES_Y then
        snakeY = 1
    elseif snakeY < 1 then
        snakeY = MAX_TILES_Y
    end
end