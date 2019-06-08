function love.load()

    -- Load assets and resources
    require("source/resources")

    -- Currently assumes 1080p resolution
    love.window.setFullscreen(true)

    Camera = require "source/packages/camera"
    cam = Camera(0, 0)

end

function love.update(dt)

end

function love.draw()

    local debug = require "source/debug"

    cam:attach()
    cam:detach()

end
