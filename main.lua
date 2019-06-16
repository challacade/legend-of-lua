function love.load()

    require("source/startup/gameStart")
    gameStart()

end

function love.update(dt)

    player:update(dt)

end

function love.draw()

    local debug = require "source/debug"

    cam:attach()

        -- Draw the background image
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(sprites.background, -1390, -2800)

        player:draw()

    cam:detach()

end
