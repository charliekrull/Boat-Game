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

        
    
    self.currentMap:renderToCanvas()

    --self.player.tileMap = self.currentMap

    
    
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
    

    self.player = Player(self.world, SHIPS['player'], 10 * TILE_SIZE, 10 * TILE_SIZE, 'Player')
    table.insert(self.ships, self.player)
    for k, ship in pairs(self.ships) do
        ship.tileMap = self.currentMap
    end
    
end

function PlayState:update(dt) 
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
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
   
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    self.currentMap:render()
    love.graphics.setColor(1, 1, 1, 1)
    for k, ship in pairs(self.ships) do
        ship:render()
        
    end
    self:drawWindField()

    -- for k, fix in pairs(self.landFixtures) do
    --     love.graphics.rectangle('line', fix:getBody():getX(), fix:getBody():getY(),
    --     TILE_SIZE, TILE_SIZE)
    -- end

    local x, y = self.player.body:getLinearVelocity()
    local playerSpeed = math.sqrt(x^2 + y^2)
    love.graphics.pop()
    self.player.healthBar:render()
    love.graphics.setColor(0, 0, 0, 1) --black
    love.graphics.print('sailDeployed: '..self.player.sailDeployed, 4, WINDOW_HEIGHT - 64)
    love.graphics.print('vel: '..math.floor(playerSpeed), 4, WINDOW_HEIGHT - 44)
    
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

                    if roll >= 0.85 then
                        
                        local t = Tile{
                            x = x,
                            y = y,
                            texture = 'tilesheet',
                            frame = 18,
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


            cells[y][x] = rotation
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
            (y-1) * TILE_SIZE, self.currentMap.windField[y][x], 1, 1, TILE_SIZE/2, TILE_SIZE/2)

        end
    end
            
    
end