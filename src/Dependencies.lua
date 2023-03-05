sti = require 'lib/sti'
Timer = require 'lib/knife/timer'
Event = require 'lib/knife/event'
Class = require 'lib/class'
push = require 'lib/push'

require 'src/Animation'
require 'src/constants'
require 'src/GameObject'
require 'src/gameObjectDefs'
require 'src/Player'
require 'src/Ship'
require 'src/shipDefs'
require 'src/StateMachine'
require 'src/Tile'
require 'src/tileDefs'
require 'src/TileMap'
require 'src/util'

require 'src/gui/ProgressBar'
require 'src/gui/Windicator'

require 'src/world/Settlement'

require 'src/states/BaseState'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'

gTextures = {['tilesheet'] = love.graphics.newImage('graphics/Tilesheet/tiles_sheet.png'),
            ['overworld'] = love.graphics.newImage('graphics/LPC Overworld/LPC_overworld_assembly.png'),

    }

gFrames = {['tilesheet'] = GenerateQuads(gTextures['tilesheet'], 64, 64),
        ['overworld'] = GenerateQuads(gTextures['overworld'], 16, 16)
    
    }

gAutoTileDict = {[0] = 69,
    [1] = 69,
    [2] = 69,
    [3] = 33,
    [4] = 69,
    [5] = 69,
    [6] = 1,
    [7] = 17,
    [8] = 69,
    [9] = 35,
    [10] = 69,
    [11] = 34,
    [12] = 3,
    [13] = 19,
    [14] = 2,
    [15] = 68,
    [16] = 23,
    [17] = 55,
    [18] = 38,
    [19] = 37,
    [20] = 7,
    [21] = 23,
    [22] = 53,
    [23] = 23,
    [24] = 41,
    [25] = 36,
    [26] = 23,
    [27] = 23,
    [28] = 52,
    [29] = 23,
    [30] = 23,
    [31] = 23
  
        }

        
        

gAutoTileDict[73] = 73


gSounds = {['crash'] = love.audio.newSource('sounds/Crash.wav', 'static')}
