sti = require 'lib/sti'
Timer = require 'lib/knife/timer'
Event = require 'lib/knife/event'
Class = require 'lib/class'

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


require 'src/states/BaseState'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'

gTextures = {['tilesheet'] = love.graphics.newImage('graphics/Tilesheet/tiles_sheet.png')
    }

gFrames = {['tilesheet'] = GenerateQuads(gTextures['tilesheet'], 64, 64)
    

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
    [15] = 68}

        
        

gAutoTileDict[73] = 73

gSounds = {['crash'] = love.audio.newSource('sounds/Crash.wav', 'static')}
