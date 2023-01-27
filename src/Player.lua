Player = Class{__includes = Entity}

function Player:update(dt)
    if love.keyboard.isDown('w') then
        self.velY = -self.moveSpeed
    end
    if love.keyboard.isDown('a') then
        self.velX = -self.moveSpeed
    end
    if love.keyboard.isDown('s') then
        self.velY = self.moveSpeed
    end
    if love.keyboard.isDown('d') then
        self.velX = self.moveSpeed
    end
    --so it's not faster to go diagonally, divide by sqrt 2 if moving in both x and y dimensions
    if self.velX ~=0 and self.velY ~= 0 then
        self.velX = self.velX / math.sqrt(2)
        self.velY = self.velY / math.sqrt(2)
    end

    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt
end