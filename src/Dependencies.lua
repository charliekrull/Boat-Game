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

gAutoTileDict = {[0] = 4,
    [1] = 106,
    [2] = 79,
    [3] = 105,
    [4] = 54,
    [5] = 80,
    [6] = 53,
    [7] = 79,
    [8] = 81,
    [9] = 107,
    [10] = 80,
    [11] = 106,
    [12] = 55,
    [13] = 81,
    [14] = 54,
    [15] = 80,
    [16] = 2,
    [17] = 3,
    [18] = 28,
    [19] = 29
}



gSounds = {['crash'] = love.audio.newSource('sounds/Crash.wav', 'static')}
