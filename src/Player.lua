Player = Class{__includes = Ship}

function Player:init(world, def, x, y, userData)
    Ship.init(self, world, def, x, y, userData)
    
end

function Player:update(dt)
    self.velX = 0
    self.velY = 0
   
    
    
    if love.keyboard.isDown('w') then
        --self.velY = -self.moveSpeed
        self.sailDeployed = math.min(100, self.sailDeployed + self.sailDeploySpeed  * dt)
    end
    if love.keyboard.isDown('a') then
        self.body:applyTorque(-1000)
        --self.rotation = self.rotation - self.rotationSpeed * dt
    end
    if love.keyboard.isDown('s') then
        --self.velY = self.moveSpeed
        self.sailDeployed = math.max(0, self.sailDeployed - self.sailDeploySpeed * dt)
    end
    if love.keyboard.isDown('d') then
        self.body:applyTorque(1000)
        --self.rotation = self.rotation + self.rotationSpeed * dt
    end

    
   
    --so it's not faster to go diagonally, divide by sqrt 2 if moving in both x and y dimensions
    -- if self.velX ~=0 and self.velY ~= 0 then
    --     self.velX = self.velX  / math.sqrt(2)
    --     self.velY = self.velY / math.sqrt(2)
    -- end

    -- self.x = self.x + self.velX * dt
    -- self.y = self.y + self.velY * dt
    Ship.update(self, dt)
end

function Player:render()
    Ship.render(self)
end