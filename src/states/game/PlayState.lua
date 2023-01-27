PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player(ENTITIES['player'])

    self.entities = {}

    table.insert(self.entities, self.player)
end

function PlayState:update(dt) 
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    
    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
   
end

function PlayState:render()
    love.graphics.clear(0, 0, 1, 1)
    love.graphics.setColor(1, 1, 1, 1)
    for k, entity in pairs(self.entities) do
        entity:render()
    end
end