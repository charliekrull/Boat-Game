PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.player = Player(ENTITIES['player'])

    self.entities = {}
    self.currentMap = TileMap{
        width = WORLD_WIDTH,
        height = WORLD_HEIGHT,
        layers = 2 
    }
    self.currentMap.tiles = self:generateWorld(self.currentMap.width, self.currentMap.height, self.currentMap.layers)

    self.currentMap:getAutoTileValues()
    self.currentMap:applyAutoTile()
    table.insert(self.entities, self.player)
end

function PlayState:update(dt) 
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    for k, click in pairs(love.mouse.buttonsPressed()) do
        print_r(self.currentMap:pointToTile(click.x + self.camX, click.y + self.camY))
    end
    
    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end

    self:updateCamera()
   
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    self.currentMap:render()
    love.graphics.setColor(1, 1, 1, 1)
    for k, entity in pairs(self.entities) do
        entity:render()
    end
    love.graphics.pop()
    
end

function PlayState:updateCamera()
    self.camX = math.max(0, math.min(TILE_SIZE * self.currentMap.width - WINDOW_WIDTH,
        self.player.x - (WINDOW_WIDTH / 2 - (TILE_SIZE/2))))

    self.camY = math.max(0, math.min(TILE_SIZE * self.currentMap.height - WINDOW_HEIGHT,
        self.player.y - (WINDOW_HEIGHT / 2 - (TILE_SIZE/2))))
end

function PlayState:generateWorld(width, height, layers)
    local returnedTiles = {}
    local frequency = 2 * math.random() + 1
    local amplitude = math.random() * 0.7 + 0.9
    

    for z = 1, layers do
        returnedTiles[z] = {}
        for y = 1, height do
            returnedTiles[z][y] = {}
            for x = 1, width do

                if z == 1 then

                    local t = Tile{
                        x = x,
                        y = y,
                        texture = 'tilesheet',
                        frame = 73
                    }
                    returnedTiles[z][y][x] = t

                elseif z == 2 then
                
                    local roll = love.math.noise(((x/width) - 0.5) * frequency, 
                        ((y/height) - 0.5) * frequency) * amplitude

                    if roll >= 0.85 then
                        
                        local t = Tile{
                            x = x,
                            y = y,
                            texture = 'tilesheet',
                            frame = 18
                        }

                        returnedTiles[z][y][x] = t
                    end
                end
            end
        end
    end

    --insert the function that assigns the right tiles based on surrounding tiles
    return returnedTiles
end
