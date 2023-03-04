TileMap = Class{}

function TileMap:init(def)
    self.width = def.width
    self.height = def.height
    self.layers = def.layers
    self.tiles = {}
    self.windField = {}
    self.canvas = love.graphics.newCanvas(WORLD_WIDTH * TILE_SIZE, WORLD_HEIGHT * TILE_SIZE)

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

            local surroundingGrass = {['N'] = false,
                ['E'] = false,
                ['S'] = false,
                ['W'] = false}
            --print_r(self:getTopTile(x, y))
            if table.contains(LAND_TILE_VALUES, self:getTopTile(x, y).frame) then
                --check the tile on each side:
                --North
                local tile = self:getTopTile(x, y-1)
                if tile and table.contains(LAND_TILE_VALUES, tile.frame) then
                    surroundingLand['N'] = true
                    if table.contains(GRASS_TILE_VALUES, tile.frame) then
                        surroundingGrass['N'] = true
                    end
                    
                end

                

                --East
                tile = self:getTopTile(x+1, y)
                if tile and table.contains(LAND_TILE_VALUES, tile.frame) then
                    surroundingLand['E'] = true
                    if table.contains(GRASS_TILE_VALUES, tile.frame) then
                        surroundingGrass['E'] = true
                    end
                end

                --South
                tile = self:getTopTile(x, y+1)
                if tile and table.contains(LAND_TILE_VALUES, tile.frame) then
                
                    surroundingLand['S'] = true
                    if table.contains(GRASS_TILE_VALUES, tile.frame) then
                        surroundingGrass['S'] = true
                    end
                end

                --West
                tile = self:getTopTile(x-1, y)
                if tile and table.contains(LAND_TILE_VALUES, tile.frame) then
                    surroundingLand['W'] = true
                    if table.contains(GRASS_TILE_VALUES, tile.frame) then
                        surroundingGrass['W'] = true
                    end
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
            local hasGrass = false
            if surroundingGrass['N'] or surroundingGrass['E'] or 
                surroundingGrass['S'] or surroundingGrass['W'] then
                
                hasGrass = true
            end

            if hasGrass then
                autoTileFrame = autoTileFrame + 16
            end



            self:getTopTile(x, y).autoTileFrame = autoTileFrame
            self:getTopTile(x, y).surroundingLand = surroundingLand
            self:getTopTile(x, y).surroundingGrass = surroundingGrass

            
            end
            
        end
        
        
    end
    



function TileMap:applyAutoTile()
    for z = 1, self.layers do
        for y = 1, self.height do
            for x = 1, self.width do
                if self.tiles[z][y][x] then
                    if self.tiles[z][y][x].frame ~= 73 then --if it's not water, change its frame according to the autotile algorithm
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


