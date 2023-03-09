Settlement = Class{}

function Settlement:init(def)
    self.x = def.x
    self.y = def.y
    self.type = def.type
    self.texture = 'overworld'
    self.width = SETTLEMENT_TYPES[self.type].width --returns a number of tiles
    self.height = SETTLEMENT_TYPES[self.type].height --returns a number of tiles
    self.tiles = {}
    self:generateTiles()
end

function Settlement:update(dt)

end

function Settlement:render()
    for t, tile in pairs(self.tiles) do
        tile:render()
    end
end

function Settlement:generateTiles()
    
    if self.type == 'house' then
        local f = table.randomChoice(SETTLEMENT_TYPES[self.type]['tiles']) -- pick a random house tiles
        local tile = Tile{x = self.x, y = self.y,
        texture = self.texture,
        frame = f, land = true}
        
        table.insert(self.tiles, tile)
    else
        local textureCounter = 0
        for y = 0,  self.height - 1 do
            for x = 0, self.width - 1 do
                
                local tile = Tile{x = self.x + x, y = self.y + y,
                texture = self.texture, frame =  SETTLEMENT_TYPES[self.type]['startTile'] + textureCounter,
                land = true}
                
                table.insert(self.tiles, tile)
                
                textureCounter = textureCounter + 1
                


            end  
        
            textureCounter = textureCounter + 26 - self.width --26 tiles in a row on the assembly sheet
        end
    end 
    
end


