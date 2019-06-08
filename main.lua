function love.load()

    -- Load assets and resources
    require("source/resources")

    -- Currently assumes 1080p resolution
    love.window.setFullscreen(true)

    Camera = require "source/packages/camera"
    cam = Camera(0, 0)

    -- Link's properties
    player = {}
    player.x = 0
    player.y = 0

end

function love.update(dt)

    if love.keyboard.isDown("left") then
        player.x = player.x - 5
    end

    if love.keyboard.isDown("right") then
        player.x = player.x + 5
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - 5
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + 5
    end

    if love.keyboard.isDown("h") then
        player.hello = true
    else
        player.hello = false
    end

end

function love.draw()

    local debug = require "source/debug"

    cam:attach()

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(sprites.background, -1390, -2800)

        local px = player.x
        local py = player.y

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(sprites.linkTest, px, py, nil, nil, nil, sprites.linkTest:getWidth()/2, sprites.linkTest:getHeight()/1.3)

        if player.hello then
            love.graphics.draw(sprites.hello, px, py - 182, nil, nil, nil, sprites.hello:getWidth()/2, sprites.hello:getHeight()/2)
        end

    cam:detach()

end
