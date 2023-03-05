Windicator = Class{}

function Windicator:init(def)
    self.x = def.x
    self.y = def.y
    self.size = def.size
    self.color = def.color
    self.player = def.player
    
    self.rotation = 0
    self.magnitude = 0

end

function Windicator:update(dt)
    self.rotation = self.player.tileMap.windField[math.floor(self.player.body:getY()/TILE_SIZE)][math.floor(self.player.body:getX()/TILE_SIZE)]['rotation']
    self.magnitude = self.player.tileMap.windField[math.floor(self.player.body:getY()/TILE_SIZE)][math.floor(self.player.body:getX()/TILE_SIZE)]['magnitude']
    
end

function Windicator:render()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.polygon('fill', -self.size/3, -self.size * 0.2, -self.size/3, self.size * 0.2, map(0, 10, 3, self.size, self.magnitude), 0)
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)


end