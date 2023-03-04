Settlement = Class{}

function Settlement:init(def)
    self.x = def.x
    self.y = def.y
    self.type = def.type
    self.width = SETTLEMENT_TYPES[self.type].width --returns a number of tiles
    self.height = SETTLEMENT_TYPES[self.type].height --returns a number of tiles
    self.tileMap = def.tileMap
    self.canvas = love.graphics.newCanvas(self.width * TILE_SIZE, self.height * TILE_SIZE)
    self:generateCanvas()
    self.tiles = {}
    
end

function Settlement:update(dt)

end

function Settlement:render()
    love.graphics.draw(self.canvas, (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
end

function Settlement:generateCanvas()
    love.graphics.setCanvas(self.canvas)
    if self.type == 'house' then
        local t = math.random(6) --number of types of 1-tiled houses
        love.graphics.draw(gTextures[self.texture], gFrames[SETTLEMENT_TYPES[self.type][t]],
        0, 0)
    else
        local textureCounter = 0
        for y = 0,  self.height - 1 do
            for x = 0, self.width - 1 do
            
                love.graphics.draw(gTextures[self.texture], 
                gFrames[SETTLEMENT_TYPES[self.type]['startTile'] + textureCounter],
                x * TILE_SIZE, y * TILE_SIZE)
                
                textureCounter = textureCounter + 1
                


            end  
        
            textureCounter = textureCounter + 27 - self.width --26 tiles in a row on the assembly sheet, offset by one
        end
    end 
    love.graphics.setCanvas()
end

