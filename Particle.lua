local Particle = {}

function Particle:create(x, y, angle, r, g, b, radius)
    self.__index = self

    return setmetatable({
        x = x,
        y = y,
        angle,
        radius = radius,
        rads = angle * (math.pi / 180),
        spd = 100,
        alpha = 1,
        destroy = false,
        r = r,
        g = g,
        b = b
    }, self)
end

function Particle:update(dt)
    self.x = self.x + (self.spd * math.cos(self.rads) * dt)
    self.y = self.y + (self.spd * math.sin(self.rads) * dt) + 0.1
    self.alpha = self.alpha - (0.5 * dt)

    if self.alpha <= 0 and not self.destroy then
        self.destroy = true
    end
end

function Particle:draw()
    love.graphics.setColor(self.r, self.g, self.b, self.alpha)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Particle
