Entity = Class{}

function Entity:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.image = def.image
    self.moveSpeed = def.moveSpeed
    self.velX = 0
    self.velY = 0
    

end

function Entity:update(dt)
    
    if self.velX ~=0 and self.velY ~= 0 then
        self.velX = self.velX / math.sqrt(2)
        self.velY = self.velY / math.sqrt(2)
    end
    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt
end

function Entity:render()
    love.graphics.draw(self.image, self.x, self.y)
end