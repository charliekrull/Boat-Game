StartState = Class{__includes = BaseState}

function StartState:init(def)
    

end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function StartState:render()
    love.graphics.clear(0, 0, 1, 1)
    
    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Placeholder', 0, WINDOW_HEIGHT/2 - 30, WINDOW_WIDTH, 'center')
    love.graphics.setFont(gFonts['ui'])
    love.graphics.printf('Press Enter to Start', 0, WINDOW_HEIGHT/2 + 80, WINDOW_WIDTH, 'center')
end