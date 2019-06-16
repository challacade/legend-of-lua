function love.load()

    -- Currently assumes 1080p resolution
    love.window.setFullscreen(true)

    Camera = require "source/packages/camera"
    cam = Camera(0, 0)

    anim8 = require("source/packages/anim8")

    -- Load assets and resources
    require("source/resources")
    require("source/player")

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
