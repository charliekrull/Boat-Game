Tile = Class{}

function Tile:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.frame = def.frame
    self.land = def.land
    self.autoTileFrame = self.frame
    self.id = self.frame
    self.surroundingLand = {}
    self.width = TILE_SIZE
    self.height = TILE_SIZE
    
end

function Tile:update(dt)

end

function Tile:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], 
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
end

function Tile:isCoast()
    return not self.surroundingLand['N'] or not self.surroundingLand['E'] or
         not self.surroundingLand['S'] or not self.surroundingLand['W']
end
