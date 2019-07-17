function gameStart()

    -- Currently assumes 1080p resolution
    love.window.setFullscreen(true)

    Camera = require "source/packages/camera"
    cam = Camera(0, 0)

    anim8 = require("source/packages/anim8")

    local windfield = require("source/packages/windfield")
    world = windfield.newWorld()
    world:setQueryDebugDrawing(true)

    require("source/startup/collisionClasses")
    createCollisionClasses()

    -- Load assets and resources
    require("source/startup/resources")
    require("source/player")
    require("source/objects/chest")

end