GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.image = def.image
    self.frame = def.frame

end

function GameObject:update(dt)

end

function GameObject:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.textures][self.frame])
end