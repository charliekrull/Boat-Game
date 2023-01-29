Tile = Class{}

function Tile:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.frame = def.frame
    self.autoTileFrame = self.frame
    self.surroundingLand = {}

end

function Tile:update(dt)

end

function Tile:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], 
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
end

