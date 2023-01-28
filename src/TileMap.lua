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