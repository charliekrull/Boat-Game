CollisionRect = Class{}

function CollisionRect:init(def)
    self.entity = def.entity
    self.x = self.entity.x + 1
    self.y = self.entity.y + 1
    self.width = self.entity.width - 2
    self.height = self.entity.height - 2
end

function CollisionRect:update(dt)
    self.x = self.entity.x + 1
    self.y = self.entity.y + 1
    
end

function CollisionRect:render()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end

function CollisionRect:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end