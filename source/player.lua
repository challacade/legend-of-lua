-- Link's properties
player = {}
player.x = 0
player.y = 0
player.width = 96
player.height = 144
player.isMoving = false

player.grids = {}
player.grids.walk = anim8.newGrid(player.width, player.height, sprites.linkWalkSheet:getWidth(), sprites.linkWalkSheet:getHeight())

player.animations = {}
player.animations.walkDown = anim8.newAnimation(player.grids.walk('1-8', 1), 0.1)
player.animations.walkRight = anim8.newAnimation(player.grids.walk('1-8', 2), 0.1)
player.animations.walkLeft = anim8.newAnimation(player.grids.walk('1-8', 2), 0.1)
player.animations.walkUp = anim8.newAnimation(player.grids.walk('1-8', 3), 0.1)

-- This value stores the player's current animation
player.anim = player.animations.walkDown

function player:update(dt)

    -- Freeze the animation if the player isn't moving
    if player.isMoving then
        player.anim:update(dt)
    end

    local previousX = player.x
    local previousY = player.y

    -- Keyboard direction checks for movement
    if love.keyboard.isDown("left") then
        player.x = player.x - 5
        player.anim = player.animations.walkLeft
    end
    if love.keyboard.isDown("right") then
        player.x = player.x + 5
        player.anim = player.animations.walkRight
    end
    if love.keyboard.isDown("up") then
        player.y = player.y - 5
        player.anim = player.animations.walkUp
    end
    if love.keyboard.isDown("down") then
        player.y = player.y + 5
        player.anim = player.animations.walkDown
    end

    -- Check if player is moving
    -- (if player's previous position is different from current position)
    if previousX ~= player.x or previousY ~= player.y then
        player.isMoving = true
    else
        player.isMoving = false
        player.anim:gotoFrame(8) -- go to standing frame
    end

    if love.keyboard.isDown("h") then
        player.hello = true
    else
        player.hello = false
    end

end

function player:draw()

    local px = player.x
    local py = player.y

    -- sx represents the scale on the x axis for the player animation
    -- If it is -1, the animation will flip horizontally (for walking left)
    local sx = 1
    if player.anim == player.animations.walkLeft then
        sx = -1
    end

    -- Draw the player's walk animation
    love.graphics.setColor(1, 1, 1, 1)
    player.anim:draw(sprites.linkWalkSheet, px, py, nil, sx, 1, player.width/2, player.height/1.3)

    if player.hello then
        love.graphics.draw(sprites.hello, px, py - 182, nil, nil, nil, sprites.hello:getWidth()/2, sprites.hello:getHeight()/2)
    end

end