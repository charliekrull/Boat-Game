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