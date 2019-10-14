function love.load()

    require("source/startup/gameStart")
    gameStart()

    score = 0

    spawnTorch(-480, 194, 0)
    spawnTorch(-480, -290, 0)
    spawnTorch(384, 194, 0)

end

function love.update(dt)

    player:update(dt)
    chests:update(dt)
    lampFires:update(dt)
    torches:update(dt)
    bombs:update(dt)
    explosions:update(dt)
    world:update(dt)

end

function love.draw()

    local debug = require "source/debug"

    cam:attach()

        -- Draw the background image
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(sprites.background, -1524, -742)

        chests:draw()
        torches:draw()
        lampFires:draw()
        bombs:draw()
        player:draw()
        explosions:draw()

        love.graphics.setLineWidth(5)
        --world:draw()

    cam:detach()

end

function love.keypressed(key)
    
    -- Resets the player's position to (0, 0)
    if key == "r" then
        player.collider:setPosition(0, 0)
        player.collider:setLinearVelocity(0, 0)
    end

    if key == 'space' then
        player:interact()
        player:useItem()
    end

end
