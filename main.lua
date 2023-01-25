local bird = {}
bird.x = 100
bird.y = 300
bird.speed = 0
local pipes = {}
local score = 0
local gameover = false
local jumpSound
local collisionSound
local gameOverSound
local gameOverSoundPlayed = false
local pointSound
local background = love.graphics.newImage("assets/images/expanded.png")

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flaffy Bird')
    bird.image = love.graphics.newImage("assets/sprites/bird.png")
    pipes.top = love.graphics.newImage("assets/sprites/pipeTop.png")
    pipes.bottom = love.graphics.newImage("assets/sprites/pipeBottom.png")
    jumpSound = love.audio.newSource("assets/sounds/bird-flap.wav", "static")
    collisionSound = love.audio.newSource("assets/sounds/bird-hurt.wav", "static")
    gameOverSound = love.audio.newSource("assets/sounds/game-over.mp3", "static")
    pointSound = love.audio.newSource("assets/sounds/point.mp3", "static")
    for i = 1, 3 do
        pipes[i] = {}
        pipes[i].x = love.graphics.getWidth() + (i - 1) * 200
        pipes[i].y = math.random(200, 300)
    end
    gameover = false
    score = 0
end

function CheckCollision(ax1, ay1, aw, ah, bx1, by1, bw, bh)
    local ax2, ay2, bx2, by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
    return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function love.update(dt)
    if gameover then
        if gameOverSoundPlayed == true then
            return
        end
        love.audio.play(gameOverSound)
        gameOverSoundPlayed = true
        return
    end

    if love.keyboard.isDown("space") then
        bird.speed = -220
    end

    bird.y = bird.y + bird.speed * dt
    bird.speed = bird.speed + 800 * dt

    if bird.y < 0 then
        bird.y = 0
    elseif bird.y + bird.image:getHeight() > love.graphics.getHeight() then
        bird.y = love.graphics.getHeight() - bird.image:getHeight()
    end

    for i = 1, #pipes do
        pipes[i].x = pipes[i].x - 200 * dt
        if pipes[i].x < -50 then
            pipes[i].x = love.graphics.getWidth()
            pipes[i].y = math.random(100, 400)
        end

        if CheckCollision(bird.x, bird.y, bird.image:getWidth(), bird.image:getHeight(), pipes[i].x, pipes[i].y,
            pipes.top:getWidth(), pipes.top:getHeight()) or
            CheckCollision(bird.x, bird.y, bird.image:getWidth(), bird.image:getHeight(), pipes[i].x,
                pipes[i].y - pipes.top:getHeight() - 100, pipes.bottom:getWidth(), pipes.bottom:getHeight()) then
            love.audio.play(collisionSound)
            gameover = true
        end
    end
end

function love.keypressed(key)
    if key == "r" and gameover then
        love.load()
    end

    if key == "space" and not gameover then
        love.audio.play(jumpSound)
    end

    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(),
        love.graphics.getHeight() / background:getHeight())
    love.graphics.draw(bird.image, bird.x, bird.y)
    for i = 1, #pipes do
        love.graphics.draw(pipes.bottom, pipes[i].x, pipes[i].y)
        love.graphics.draw(pipes.top, pipes[i].x, pipes[i].y - pipes.top:getHeight() - 100)
    end
    love.graphics.print("Score: " .. score, 10, 10)
    if gameover then
        love.graphics.print("Game Over", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 10)
        love.graphics.print("Press 'R' to restart", love.graphics.getWidth() / 2 - 75,
            love.graphics.getHeight() / 2 + 20)
    end
end
