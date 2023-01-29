sti = require 'lib/sti'
Timer = require 'lib/knife/timer'
Event = require 'lib/knife/event'
Class = require 'lib/class'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entityDefs'
require 'src/Player'
require 'src/StateMachine'
require 'src/Tile'
require 'src/tileDefs'
require 'src/TileMap'
require 'src/util'


require 'src/states/BaseState'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'

gTextures = {['tilesheet'] = love.graphics.newImage('graphics/Tilesheet/tiles_sheet.png')
    }

gFrames = {['tilesheet'] = GenerateQuads(gTextures['tilesheet'], 64, 64)
    

    }

gAutoTileDict = {}
for k = 0, 15 do
    if k == 3 then
        gAutoTileDict[k] = 33

    elseif k == 6 then
        gAutoTileDict[k] = 1

    elseif k == 7 then
        gAutoTileDict[k] = 17
    
    elseif k == 9 then
        gAutoTileDict[k] = 35
    
    elseif k == 11 then
        gAutoTileDict[k] = 34

    elseif k == 12 then
        gAutoTileDict[k] = 3

    elseif k == 13 then
        gAutoTileDict[k] = 19

    elseif k == 14 then
        gAutoTileDict[k] = 2
    
    elseif k == 15 then
        gAutoTileDict[k] = 68
        
    else
        gAutoTileDict[k] = 73
    
        
    end
        
        
end
gAutoTileDict[73] = 73
