Entity = Class{}

function Entity:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.image = def.image
    self.moveSpeed = def.moveSpeed
    self.tileMap = def.tileMap
    self.velX = 0
    self.velY = 0
    self.collisionRect = CollisionRect{entity = self}
    
    

end

function Entity:update(dt)
    --make sure it's not faster to go diagonally than horizontally/vertically
    if self.velX ~=0 and self.velY ~= 0 then
        self.velX = self.velX / math.sqrt(2)
        self.velY = self.velY / math.sqrt(2)
    end
    --update position based on speed
    self.x = self.x + self.velX * dt
    self.y = self.y + self.velY * dt
    --move collision rect with entity
    self.collisionRect.x = self.x
    self.collisionRect.y = self.y

    if self:checkTileCollisionsLeft() or self:checkTileCollisionsRight() then
        self.x = self.x - self.velX * dt
    end

    if self:checkTileCollisionsUp() or self:checkTileCollisionsDown() then
        self.y = self.y - self.velY * dt
    end

        
   
    
    

end

function Entity:render()
    love.graphics.draw(self.image, self.x, self.y)
    self.collisionRect:render()
end

function Entity:checkTileCollisionsUp()
    local tileTopLeft = self.tileMap:pointToTile(self.collisionRect.x, self.collisionRect.y)
    local tileTopRight = self.tileMap:pointToTile(
        self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y)


   return (((tileTopLeft ~= nil) and (tileTopLeft.land)) or (tileTopRight ~= nil) and tileTopRight.land)
    
end

function Entity:checkTileCollisionsRight()
    local tileTopRight = self.tileMap:pointToTile(self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y)
    local tileBottomRight = self.tileMap:pointToTile(
        self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y + self.collisionRect.height)

        return (((tileTopRight ~= nil) and (tileTopRight.land)) or (tileBottomRight ~= nil) and tileBottomRight.land)
    
end

function Entity:checkTileCollisionsDown()
    local tileBottomLeft = self.tileMap:pointToTile(self.collisionRect.x, self.collisionRect.y + self.collisionRect.height)
    local tileBottomRight = self.tileMap:pointToTile(
        self.collisionRect.x + self.collisionRect.width,
        self.collisionRect.y + self.collisionRect.height)

        return (((tileBottomLeft ~= nil) and (tileBottomLeft.land)) or (tileBottomRight ~= nil) and tileBottomRight.land)
    
end

function Entity:checkTileCollisionsLeft()
    local tileTopLeft = self.tileMap:pointToTile(self.collisionRect.x, self.collisionRect.y)
    local tileBottomLeft = self.tileMap:pointToTile(
        self.collisionRect.x,
        self.collisionRect.y + self.collisionRect.height)

        return (((tileTopLeft ~= nil) and (tileTopLeft.land)) or (tileBottomLeft ~= nil) and tileBottomLeft.land)
    
end