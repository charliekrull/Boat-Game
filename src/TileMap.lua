TileMap = Class{}

function TileMap:init(def)
    self.width = def.width
    self.height = def.height
    self.tiles = {}
end

function TileMap:update(dt)

end

function TileMap:render()
    for y = 1, self.height do
        for x = 1, self.width do
            self.tiles[y][x]:render()
        end
    end
end

--output the tile that the point (x, y) is on
function TileMap:pointToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil

    else
        return self.tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
    end
end

function TileMap:getAutoTileValues()
    
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            local surroundingLand = {['N'] = false,
                ['E'] = false,
                ['S'] = false,
                ['W'] = false}
            
            if self.tiles[y][x].frame == 18 then
                --check the tile on each side:
                --North
                if self.tiles[math.max(1, y-1)][x].frame == 18 then
                    surroundingLand['N'] = true
                end

                

                --East
                if self.tiles[y][math.min(#self.tiles[y], x + 1)].frame == 18 then
                    surroundingLand['E'] = true
                end

                --South

                if self.tiles[math.min(#self.tiles, y + 1)][x].frame == 18 then
                    surroundingLand['S'] = true
                end

                --West
                if self.tiles[y][math.max(1, x - 1)].frame == 18 then
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

            self.tiles[y][x].autoTileFrame = autoTileFrame
            self.tiles[y][x].surroundingLand = surroundingLand

    
        end
    
    end

end

function TileMap:applyAutoTile()
    for i = 1, #self.tiles do
        for j = 1, #self.tiles[i] do
            self.tiles[i][j].frame = gAutoTileDict[self.tiles[i][j].autoTileFrame]
        end
        
    end
end