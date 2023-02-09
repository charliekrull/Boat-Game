Player = Class{__includes = Ship}

function Player:init(world, def, x, y, userData)
    Ship.init(self, world, def, x, y, userData)
    self.healthBar = ProgressBar{
        x = 4,
        y = 6,
        width = WINDOW_WIDTH/4,
        height = 24,
        max = self.maxHealth,
        value = self.health,
        color = {['r'] = 1,
            ['g'] = 0,
            ['b'] = 0,
            ['a'] = 1}
    }
    
end

function Player:update(dt)
    self.velX = 0
    self.velY = 0
   
    
    
    if love.keyboard.isDown('w') then
        --self.velY = -self.moveSpeed
        self.sailDeployed = math.min(100, self.sailDeployed + self.sailDeploySpeed  * dt)
    end
    if love.keyboard.isDown('a') then
        self.body:applyTorque(-self.steerForce)
        --self.rotation = self.rotation - self.rotationSpeed * dt
    end
    if love.keyboard.isDown('s') then
        --self.velY = self.moveSpeed
        self.sailDeployed = math.max(0, self.sailDeployed - self.sailDeploySpeed * dt)
    end
    if love.keyboard.isDown('d') then
        self.body:applyTorque(self.steerForce)
        --self.rotation = self.rotation + self.rotationSpeed * dt
    end

    
    if love.keyboard.isDown('down') then
        self.body:applyForce(-math.cos(self.rotation + math.pi/2) * self.strafeForce, -math.sin(self.rotation + math.pi/2) * 10000)
    end
    if love.keyboard.isDown('up') then
        self.body:applyForce(math.cos(self.rotation + math.pi/2) * self.strafeForce, 
            math.sin(self.rotation + math.pi/2) * 10000)
    end
    if love.keyboard.isDown('right') then
        self.body:applyForce(math.cos(self.rotation + math.pi) * self.strafeForce,
        math.sin(self.rotation + math.pi) * self.strafeForce)
    end
    if love.keyboard.isDown('left') then
        self.body:applyForce(math.cos(self.rotation) * self.strafeForce,
        math.sin(self.rotation) * self.strafeForce)
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