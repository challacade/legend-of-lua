function love.load()

    require("source/startup/gameStart")
    gameStart()

    testWall = world:newRectangleCollider(282, -90, 198, 188)
    testWall:setType('static')

    testWall2 = world:newRectangleCollider(-486, -90, 198, 188)
    testWall2:setType('static')

end

function love.update(dt)

    player:update(dt)
    world:update(dt)

end

function love.draw()

    local debug = require "source/debug"

    cam:attach()

        -- Draw the background image
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(sprites.background, -1527, -900)

        player:draw()

        love.graphics.setLineWidth(5)
        world:draw()

    cam:detach()

end

function love.keypressed(k)
    
    -- Resets the player's position to (0, 0)
    if k == "r" then
        player.collider:setPosition(0, 0)
        player.collider:setLinearVelocity(0, 0)
    end

end
