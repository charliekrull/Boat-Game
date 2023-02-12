PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    

    self.ships = {}
    self.currentMap = TileMap{
        width = WORLD_WIDTH,
        height = WORLD_HEIGHT,
        layers = 2 
    }
    self.currentMap.tiles = self:generateWorld(self.currentMap.width, self.currentMap.height, self.currentMap.layers)

    self.currentMap:getAutoTileValues()
    self.currentMap:applyAutoTile()
    self.currentMap.windField = self:generateWindField()
    self.windDirCanvas = love.graphics.newCanvas(TILE_SIZE, TILE_SIZE)
    love.graphics.setCanvas(self.windDirCanvas)
    love.graphics.line(TILE_SIZE/4, TILE_SIZE/4,
        TILE_SIZE - TILE_SIZE/4, TILE_SIZE/2,
        TILE_SIZE/4, TILE_SIZE - TILE_SIZE/4) 

    self.windicator = love.graphics.newCanvas(TILE_SIZE, TILE_SIZE)
    

        
    
    self.currentMap:renderToCanvas()
    
    --physics world
    self.world = love.physics.newWorld(0, 0, WORLD_WIDTH * TILE_SIZE, WORLD_HEIGHT * TILE_SIZE)

    function beginContact(a, b, coll)
        local types = {}

        types[a:getUserData()] = true
        types[b:getUserData()] = true

        if types['Player'] and types['Land'] then
            local playerFixture = a:getUserData() == 'Player' and a or b
            local landFixture = a:getUserData() == 'Land' and a or b
            self.player.velX = 0
            self.player.velY = 0
            self.player.fixture:getBody():setLinearVelocity(0, 0)
            self.player:takeDamage(20)
            self.player.beached = true
            gSounds['crash']:stop()
            gSounds['crash']:play()
        end
    end

    function endContact(a, b, coll)

    end
    
    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)
        
    end

    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    self.landFixtures = self:addLandFixtures()
    
    --place the player so we're not on land
    local waterTiles = {}
    for z, layer in pairs(self.currentMap.tiles) do
        for y, row in pairs(layer) do
            for x, cell in pairs(row) do
                if self.currentMap:getTopTile(x, y).frame == 73 then
                    waterTiles[#waterTiles+1] = cell

                end
            end
        end
    end
    
    local chosenTile = table.randomChoice(waterTiles)

    

    self.player = Player(self.world, SHIPS['player'],( chosenTile.x -1 )* TILE_SIZE, (chosenTile.y - 1) * TILE_SIZE, 'Player')
    table.insert(self.ships, self.player)
    for k, ship in pairs(self.ships) do
        ship.tileMap = self.currentMap
    end
    
end

function PlayState:update(dt) 
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    for k, click in pairs(love.mouse.buttonsPressed()) do
        if click.button == 1 then
            local clickedTile = self.currentMap:pointToTile(click.x+ self.camX, click.y + self.camY)
            if clickedTile and clickedTile.autoTileFrame then
                print(clickedTile.autoTileFrame)
            else
                print(nil)
            end

        end
    end
    
    for k, ship in pairs(self.ships) do
        ship:update(dt)
    end

    self.world:update(dt)

    self:updateCamera()

    if love.keyboard.wasPressed('b') then
        if self.player.beached then
            self.player.beached = false
        end
    end

    if love.keyboard.wasPressed('f') then
        print(self.currentMap.windField[math.floor(self.player.body:getY()/TILE_SIZE)][math.floor(self.player.body:getX()/TILE_SIZE)]['magnitude'])
    end
   
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    self.currentMap:render()
    love.graphics.setColor(1, 1, 1, 1)
    for k, ship in pairs(self.ships) do
        ship:render()
        
    end
    --draw the wind direction arrows
    self:drawWindField()

    -- outline land fixtures, for debugging
    -- for k, fix in pairs(self.landFixtures) do
    --     love.graphics.rectangle('line', fix:getBody():getX(), fix:getBody():getY(),
    --     TILE_SIZE, TILE_SIZE)
    -- end

    local x, y = self.player.body:getLinearVelocity()
    local playerSpeed = math.sqrt(x^2 + y^2)
    love.graphics.pop()
    self.player.healthBar:render()
    self.player.sailDeployedBar:render()
    self:drawWindicator()
    --love.graphics.setColor(0, 0, 0, 1) --black
    
    --love.graphics.print('vel: '..math.floor(playerSpeed), 4, WINDOW_HEIGHT - 44)
    
    love.graphics.setColor(1, 1, 1, 1)
    
end

function PlayState:updateCamera()
    local centerOfMassX, centerOfMassY = self.player.body:getWorldCenter()
    self.camX = math.max(0, math.min(TILE_SIZE * self.currentMap.width - WINDOW_WIDTH,
        centerOfMassX - (WINDOW_WIDTH / 2 - (TILE_SIZE/2))))

    self.camY = math.max(0, math.min(TILE_SIZE * self.currentMap.height - WINDOW_HEIGHT,
        centerOfMassY - (WINDOW_HEIGHT / 2 - (TILE_SIZE/2))))
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
                        frame = 73,
                        land = false
                    }
                    returnedTiles[z][y][x] = t

                elseif z == 2 then
                
                    local roll = love.math.noise(((x/width) - 0.5) * frequency, 
                        ((y/height) - 0.5) * frequency) * amplitude

                    if (roll >= 0.85 and roll <= 0.95) or x == 1 or x == WORLD_WIDTH or y == 1 or y == WORLD_HEIGHT then
                        
                        local t = Tile{
                            x = x,
                            y = y,
                            texture = 'tilesheet',
                            frame = 18,
                            land = true
                        }
                        

                        returnedTiles[z][y][x] = t

                    elseif roll > 0.95 then
                        local t = Tile{
                            x = x,
                            y = y,
                            texture = 'tilesheet',
                            frame = 23,
                            land = true
                        }    
                        returnedTiles[z][y][x] = t
                    end
                end
            end
        end
    end

    return returnedTiles
end

function PlayState:addLandFixtures()
    local returnedFixtures = {}
    for y = 1, WORLD_HEIGHT do
        for x = 1, WORLD_WIDTH do
            local id = self.currentMap:getTopTile(x, y).frame
            local isLand = false --assume it's water to start
            for i = 1, #LAND_TILE_VALUES do
                if LAND_TILE_VALUES[i] == id then
                    isLand = true
                    break
                end
            end
            if isLand then
                local bod = love.physics.newBody(self.world, (x-1) * TILE_SIZE, (y - 1) * TILE_SIZE, 'static')
                local shape = love.physics.newRectangleShape(32, 32, TILE_SIZE, TILE_SIZE)
                local fix = love.physics.newFixture(bod, shape)
                fix:setUserData('Land')
                table.insert(returnedFixtures, fix)
            end
        end
    end
    return returnedFixtures
end

function PlayState:generateWindField()
    local cells = {}
    local frequency = math.random()/20
    for y = 1, WORLD_HEIGHT do
        cells[y] = {}
        for x = 1, WORLD_WIDTH do
            --get the rotation of the "wind vector" in this cell
            local rotation = love.math.noise(x  * frequency, y  * frequency) * math.pi * 2
            local magnitude = love.math.noise(x/2 * frequency, y/2 * frequency) * 300

            cells[y][x] = {['rotation'] = rotation,
                ['magnitude'] = magnitude}
        end
    end

    return cells
end

function PlayState:drawWindField()
    
    for y, tbl in pairs(self.currentMap.windField) do
        for x, cell in pairs(tbl) do
            love.graphics.setColor(1, 0, 0, 1)
            --draw the wind arrow canvas, rotate appropriately
            love.graphics.draw(self.windDirCanvas, (x-1) * TILE_SIZE,
            (y-1) * TILE_SIZE, self.currentMap.windField[y][x]['rotation'], 
            self.currentMap.windField[y][x]['magnitude'] / 300, self.currentMap.windField[y][x]['magnitude'] / 300,
             TILE_SIZE/2, TILE_SIZE/2)

        end
    end
            
    
end

function PlayState:drawWindicator()
    local currentWindCellRotation = self.currentMap.windField[math.floor(self.player.body:getY()/TILE_SIZE)][math.floor(self.player.body:getX()/TILE_SIZE)]['rotation']
    local currentWindCellMagnitude = self.currentMap.windField[math.floor(self.player.body:getY()/TILE_SIZE)][math.floor(self.player.body:getX()/TILE_SIZE)]['magnitude']
    love.graphics.setCanvas(self.windicator)
    love.graphics.clear(0, 0, 0, 0) --clear to transparency
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.polygon('fill', 0, self.windicator:getPixelHeight()/2.5,
        map(0, 1, 5, 64, currentWindCellMagnitude/300), self.windicator:getPixelHeight()/2,
        0, self.windicator:getPixelHeight() * 0.6)
    
    love.graphics.setCanvas()
    love.graphics.draw(self.windicator, TILE_SIZE, WINDOW_HEIGHT - TILE_SIZE,
    currentWindCellRotation, 1, 1, map(0, 300, 5, TILE_SIZE, currentWindCellMagnitude/300), TILE_SIZE/2)

    
end