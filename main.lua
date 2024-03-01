local Firework = require 'Firework'

SCREEN_WIDTH, SCREEN_HEIGHT = 600, 400;
Fullscreen = false

local prevTime = love.timer.getTime()
local threshold = 0.3
Fireworks = {}

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
end

function love.update(dt)
    local elapsed = love.timer.getTime() - prevTime

    if elapsed >= threshold then
        createFirework()
        prevTime = love.timer.getTime();
    end

    for key, value in pairs(Fireworks) do
        if Fireworks[key].canDelete == true then
            table.remove(Fireworks, key)
        else
            Fireworks[key]:update(dt)
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    if key == "f11" then
        Fullscreen = not Fullscreen
        love.window.setFullscreen(Fullscreen)
    end

    if key == "space" then
        createFirework()
    end
end

function love.draw()
    for key, value in pairs(Fireworks) do
        Fireworks[key]:draw()
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press spacebar to shoot a firework!", 10, 10)
end

function createFirework()
    local x, y, seconds, spd = math.random(30, SCREEN_WIDTH),
        SCREEN_HEIGHT + 32,
        math.random(1, 1.5),
        math.random(200, 300)
    local newFirework = Firework:create(x, y, seconds, spd)

    table.insert(Fireworks, newFirework)
end