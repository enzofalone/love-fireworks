local Particle = require 'Particle'
local Firework = {}

function Firework:create(x, y, seconds, spd)
    self.__index = self

    return setmetatable({
        x = x,
        y = y,
        w = 8,
        h = 16,
        duration = seconds,
        spd = spd,
        startTime = love.timer.getTime(),
        alpha = 1,
        particles = {},
        canDelete = false,
        hasExploded = false
    }, self)
end

function Firework:update(dt)
    local elapsed = love.timer.getTime() - self.startTime

    if elapsed >= self.duration then
        -- create firework particles
        if not self.hasExploded then
            self:explode(self.particles)
            self.hasExploded = true
            self.alpha = 0
        end

        if #self.particles == 0 and self.hasExploded then
            self.canDelete = true
        end
    else
        self:fly(dt)
    end

    for key, value in pairs(self.particles) do
        if self.particles[key].destroy then
            table.remove(self.particles, key)
        else
            self.particles[key]:update(dt)
        end
    end
end

function Firework:draw()
    love.graphics.setColor(0, 0, 1, self.alpha)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    for key, value in pairs(self.particles) do
        self.particles[key]:draw()
    end
end

function Firework:fly(dt)
    local timeLeft = self.duration - (love.timer.getTime() - self.startTime)
    self.y = self.y - (self.spd * timeLeft * dt)
end

function Firework:explode(particles)
    -- Create particles in different groups
    self:createParticles(particles, 10, 6)
    self:createParticles(particles, 15, 3)
    self:createParticles(particles, 20, 1)
end

function Firework:createParticles(particles, amount, radius)
    local r = math.random(0.2, 1)
    local g = math.random(0.2, 1)
    local b = math.random(0.2, 1)
    local variation = math.random(10, 20)

    for i = 0, 360, (360 / amount) do
        local newParticle = Particle:create(self.x + (self.w / 2), self.y + (self.h / 2), i + variation, r,
            g, b, radius)
        table.insert(particles, newParticle)
    end
end

return Firework
