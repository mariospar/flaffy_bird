-- Initialize game variables
local bird = {}
bird.x = 100
bird.y = 300
bird.dy = 0
local pipes = {}
local gameover = false
local last_pipe = 0
local pipe_interval = 1

score = 0
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Load assets
local birdImage = love.graphics.newImage("assets/sprites/bird.png")
local pipeImage = love.graphics.newImage("assets/sprites/pipe.png")
local background = love.graphics.newImage("assets/images/expanded.png")

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Falpy Bird')
    table.insert(pipes, {
        x = 300,
        y = 0
    })
end

local function check_collision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Game loop
function love.update(dt)
    local current_time = love.timer.getTime()
    if current_time - last_pipe > pipe_interval then
        last_pipe = current_time
        table.insert(pipes, {
            x = love.graphics.getWidth(),
            y = math.random(0, love.graphics.getHeight() - pipeImage:getHeight())
        })
    end

    -- Update bird position
    bird.dy = bird.dy + 9.8 * dt
    bird.y = bird.y + bird.dy

    -- Handle user input
    if love.keyboard.isDown("space") then
        bird.dy = -4
    end

    -- update pipes
    for i = 1, #pipes do
        pipes[i].x = pipes[i].x - 100 * dt
    end

    -- Check for collisions
    for i = 1, #pipes do
        if check_collision(bird.x, bird.y, birdImage:getWidth(), birdImage:getHeight(), pipes[i].x, pipes[i].y,
            pipeImage:getWidth(), pipeImage:getHeight()) then
            gameover = true
        end

        if bird.x > pipes[i].x + pipeImage:getWidth() then
            score = score + 1
        end
    end
    if gameover then
        if love.keyboard.isDown("r") then
            -- reset game
            gameover = false
            score = 0
            bird.x = 100
            bird.y = 300
            bird.dy = 0
            for i = 1, 3 do
                pipes[i] = {}
                pipes[i].x = 300 + (i - 1) * 200
                pipes[i].y = math.random(200, 400)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- Draw bird
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(),
        love.graphics.getHeight() / background:getHeight())

    love.graphics.draw(birdImage, bird.x, bird.y)

    -- Draw pipes
    for i, pipe in ipairs(pipes) do
        love.graphics.draw(pipeImage, pipe.x, pipe.y)
    end

    if gameover then
        love.graphics.print("Game Over", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 2, 2)
        love.graphics.print("Press R to restart", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + 20, 0,
            2, 2)
    end

    love.graphics.print("Score: " .. score, 10, 10)
end
