Ship = Class{}

function Ship:init(world, def, x, y, userData)
    self.world = world
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.image = def.image
    self.moveSpeed = def.moveSpeed
    self.tileMap = def.tileMap
    self.velX = 0
    self.velY = 0
    self.rotation = 0
    self.rotationSpeed = def.rotationSpeed
    
    self.sailDeployed = 0 --0 to 100
    self.sailDeploySpeed = def.sailDeploySpeed

    self.beached = false

    self.body = love.physics.newBody(self.world, x + self.width / 2, y + self.height / 2,
        'dynamic')

    self.shape = love.physics.newPolygonShape(0, 4, self.width, 4, self.width/2, self.height)
    
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.fixture:setUserData(userData)
    

end

function Ship:update(dt)
    --make sure it's not faster to go diagonally than horizontally/vertically
    -- if self.velX ~=0 and self.velY ~= 0 then
    --     self.velX = self.velX / math.sqrt(2)
    --     self.velY = self.velY / math.sqrt(2)
    -- end
    if not self.beached then
        self.velX = math.cos(self.rotation + math.pi/2) * (self.sailDeployed/100) * self.moveSpeed
        self.velY = math.sin(self.rotation + math.pi/2) * (self.sailDeployed/100) * self.moveSpeed
    else
        self.velX = 0
        self.velY = 0
        self.sailDeployed = 0
    end
    --update position based on speed
    self.body:setLinearVelocity(self.velX, self.velY)
    self.x = self.body:getX() - self.width/2
    self.y = self.body:getY() - self.height/2
    --move collision rect with Ship
    
    -- self.collisionRect:update(dt)

    -- if self:checkTileCollisionsLeft() or self:checkTileCollisionsRight() then
    --     self.x = self.x - self.velX * dt
    -- end

    -- if self:checkTileCollisionsUp() or self:checkTileCollisionsDown() then
    --     self.y = self.y - self.velY * dt
    -- end

        
   
    
    

end

function Ship:render()
    love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, 
    self.width/2, self.height/2)
    --self.collisionRect:render()
end

function Ship:checkTileCollisionsUp()
    local tileTopLeft = self.tileMap:pointToTile(self.collisionRect.x, self.collisionRect.y)
    local tileTopRight = self.tileMap:pointToTile(
        self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y)


   return (((tileTopLeft ~= nil) and (tileTopLeft.land)) or (tileTopRight ~= nil) and tileTopRight.land)
    
end

function Ship:checkTileCollisionsRight()
    local tileTopRight = self.tileMap:pointToTile(self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y)
    local tileBottomRight = self.tileMap:pointToTile(
        self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y + self.collisionRect.height)

        return (((tileTopRight ~= nil) and (tileTopRight.land)) or (tileBottomRight ~= nil) and tileBottomRight.land)
    
end

function Ship:checkTileCollisionsDown()
    local tileBottomLeft = self.tileMap:pointToTile(self.collisionRect.x, self.collisionRect.y + self.collisionRect.height)
    local tileBottomRight = self.tileMap:pointToTile(
        self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y + self.collisionRect.height)

        return (((tileBottomLeft ~= nil) and (tileBottomLeft.land)) or (tileBottomRight ~= nil) and tileBottomRight.land)
    
end

function Ship:checkTileCollisionsLeft()
    local tileTopLeft = self.tileMap:pointToTile(self.collisionRect.x, self.collisionRect.y)
    local tileBottomLeft = self.tileMap:pointToTile(
        self.collisionRect.x,
        self.collisionRect.y + self.collisionRect.height)

        return (((tileTopLeft ~= nil) and (tileTopLeft.land)) or (tileBottomLeft ~= nil) and tileBottomLeft.land)
    
end