Push = require('./vendors/push/push')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage()

local ground = love.graphics.newImage()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Falpy Bird')

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,  {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    Push:resize(w,h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    Push:start()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 20)
    Push:finish()
end