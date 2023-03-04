--[[
    Can't do much without a main.lua file
]]

require 'src/Dependencies'

--runs once when the game starts
function love.load()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {fullscreen = false,
    resizable = true,   
    vsync = true})

    love.window.setTitle('Game Title')
 
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('linear', 'linear')

    gFonts = {
        ['title'] = love.graphics.newFont('fonts/Antique Quest St.ttf', 32),
        ['ui'] = love.graphics.newFont('fonts/CalligraphyFLF.ttf', 16)
    }

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }

    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
    love.mouse.clicks = {}


end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    table.insert(love.mouse.clicks, {x = x, y = y, button = button})

end

function love.mouse.buttonsPressed()

    return love.mouse.clicks
    
end

function love.resize(w, h)
    push:resize(w,h)
end



--called every frame
function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.clicks = {}
end

function love.draw()
    push:apply('start') 

    
    gStateMachine:render()
    
    push:apply('end')
end