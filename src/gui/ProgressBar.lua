ProgressBar = Class{}

function ProgressBar:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    self.color = def.color

    self.value = def.value
    self.max = def.max
end

function ProgressBar:setMax(newMax)
    self.max = newMax
end

function ProgressBar:setValue(value)
    self.value = value
end

function ProgressBar:update(dt)

end

function ProgressBar:render()
    local renderWidth = (self.value/self.max) * self.width
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    
    if self.value > 0 then
        love.graphics.rectangle('fill', self.x, self.y, renderWidth, self.height)
    end

    --outline the bar
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end