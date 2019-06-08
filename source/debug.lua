-- This file contains several functions for displaying debug data

local debug = {}

function debug:playerPosition()

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 16, 16, 660, 220)

    local px = player.x
    local py = player.y

    if px >= 0 then
        px = " " .. px
    end

    if py >= 0 then
        py = " " .. py
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts.debug)
    love.graphics.print("player.x: " .. px, 50, 32)
    love.graphics.print("player.y: " .. py, 50, 118)

end

function debug:origin()

    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.circle("fill", 0, 0, 20)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(4)
    love.graphics.circle("line", 0, 0, 20)

    love.graphics.setFont(fonts.origin)
    love.graphics.print("(0, 0)", -92, 20)

end

return debug