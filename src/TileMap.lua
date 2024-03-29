TileMap = Class{}

function TileMap:init(def)
    self.width = def.width
    self.height = def.height
    self.layers = def.layers
    self.tiles = {}
    self.windField = {}
    self.canvas = love.graphics.newCanvas(WORLD_WIDTH * TILE_SIZE, WORLD_HEIGHT * TILE_SIZE)
    self.settlements = {}
    
end

function TileMap:update(dt)
    
end

function TileMap:renderToCanvas()
    love.graphics.setCanvas(self.canvas)
    for z = 1, self.layers do
        for y = 1, self.height do
            for x = 1, self.width do
                if self.tiles[z][y][x] then
                    self.tiles[z][y][x]:render()
                end
            end
        end
    end 
    love.graphics.setCanvas()
end

function TileMap:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, 0, 0)
    for s, settlement in pairs(self.settlements) do
        settlement:render()
    end
end

--output the tile that the point (x, y) is on
function TileMap:pointToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil

    else
        return self.tiles[#self.tiles][math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
    end
end

function TileMap:getAutoTileValues()

    for y = 1, self.height do  
        for x = 1, self.width do
            local surroundingLand = {['N'] = false,
                ['E'] = false,
                ['S'] = false,
                ['W'] = false}

                
            --print_r(self:getTopTile(x, y))
            if table.contains(ISLAND_TILES, self:getTopTile(x, y).frame) then
                --check the tile on each side:
                --North
                local tile = self:getTopTile(x, y-1)
                if tile and table.contains(ISLAND_TILES, tile.frame) then
                    surroundingLand['N'] = true
                    
                   
                    
                end

                

                --East
                tile = self:getTopTile(x+1, y)
                if tile and table.contains(ISLAND_TILES, tile.frame) then
                    surroundingLand['E'] = true
                   
                end

                --South
                tile = self:getTopTile(x, y+1)
                if tile and table.contains(ISLAND_TILES, tile.frame) then
                
                    surroundingLand['S'] = true
                   
                end

                --West
                tile = self:getTopTile(x-1, y)
                if tile and table.contains(ISLAND_TILES, tile.frame) then
                    surroundingLand['W'] = true
                    
                end
            end
            
            local autoTileFrame = 0  
            
            if surroundingLand['N'] then
                autoTileFrame = autoTileFrame + 1
        
            end 

            if surroundingLand['E'] then
                autoTileFrame = autoTileFrame + 2
                
            end

            if surroundingLand['S'] then
                autoTileFrame = autoTileFrame + 4
                
            end

            if surroundingLand['W'] then
                autoTileFrame = autoTileFrame + 8
                
            end

            if autoTileFrame == 15 then
                if self:getTopTile(x + 1, y + 1) and self:getTopTile(x + 1, y+1).id == WATER_ID then
                    autoTileFrame = 16

                elseif self:getTopTile(x+1, y-1) and self:getTopTile(x+1, y-1).id == WATER_ID then
                    autoTileFrame = 18    
                
                elseif self:getTopTile(x-1, y-1) and self:getTopTile(x-1, y-1).id == WATER_ID then
                    autoTileFrame = 19

                elseif self:getTopTile(x-1, y+1) and self:getTopTile(x-1, y+1).id == WATER_ID then
                    autoTileFrame = 17    
                
                end
                                
            end
            



            self:getTopTile(x, y).autoTileFrame = autoTileFrame
            self:getTopTile(x, y).surroundingLand = surroundingLand
            
           

            
            end
            
        end
        
        
    end
    



function TileMap:applyAutoTile()
    for z = 1, self.layers do
        for y = 1, self.height do
            for x = 1, self.width do
                if self.tiles[z][y][x] then
                    if self.tiles[z][y][x].frame ~= WATER_ID then --if it's not water, change its frame according to the autotile value
                        self.tiles[z][y][x].frame = gAutoTileDict[self.tiles[z][y][x].autoTileFrame]
                    end
                end
            end
        end
    end
end

function TileMap:getTopTile(x, y)

    for z = self.layers, 1, -1 do
        if self.tiles[z] then
            if self.tiles[z][y] then
                if self.tiles[z][y][x] then    
                          
                    return self.tiles[z][y][x]

                end
            end
        end
    end
    
    
end


function TileMap:generateSettlements()
    
    for y = 1, WORLD_HEIGHT do
        for x = 1, WORLD_WIDTH do
            if self:getTopTile(x, y).land then
                if math.random(100) == 1 then
                    --get current width of land
                    local offX, offY = x, y
                    local w, h = 0, 0
                    while self:getTopTile(offX, offY).land do
                        offX = offX + 1
                        w = w + 1
                        
                    end
                    offX = x

                    --get height of land 
                    while self:getTopTile(offX, offY).land do
                        offY = offY + 1
                        h = h + 1
                    end

                    --get available types of settlement
                    local possibleTypes = {}
                    for t, type in pairs(SETTLEMENT_TYPES) do
                        if SETTLEMENT_TYPES[type].width <= w and SETTLEMENT_TYPES[type].height <= h then
                            table.insert(possibleTypes, type)
                        end
                    end

                    local type = table.randomChoice(possibleTypes)

                    local s = Settlement{x = x, y = y,
                    type = type, tileMap = self}

                    table.insert(self.settlements, s)
                end
            end
        end
    end
    
end
