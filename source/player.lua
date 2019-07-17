-- Link's properties
player = {}
player.width = 96  -- width of the animation frames
player.height = 144  -- height of the animation frames
player.isMoving = false
player.dir = "down"

-- Physics properties
player.collider = world:newCircleCollider(0, 0, 40)
player.collider:setCollisionClass("Player")

player.grids = {}
player.grids.walk = anim8.newGrid(player.width, player.height, sprites.linkWalkSheet:getWidth(), sprites.linkWalkSheet:getHeight())

player.animations = {}
player.animations.walkDown = anim8.newAnimation(player.grids.walk('1-8', 1), 0.075)
player.animations.walkRight = anim8.newAnimation(player.grids.walk('1-8', 2), 0.075)
player.animations.walkLeft = anim8.newAnimation(player.grids.walk('1-8', 2), 0.075)
player.animations.walkUp = anim8.newAnimation(player.grids.walk('1-8', 3), 0.075)

-- This value stores the player's current animation
player.anim = player.animations.walkDown

function player:update(dt)

    -- Freeze the animation if the player isn't moving
    if player.isMoving then
        player.anim:update(dt)
    end

    local vectorX = 0
    local vectorY = 0

    -- Keyboard direction checks for movement
    if love.keyboard.isDown("left") then
        vectorX = -1
        player.anim = player.animations.walkLeft
        player.dir = "left"
    end
    if love.keyboard.isDown("right") then
        vectorX = 1
        player.anim = player.animations.walkRight
        player.dir = "right"
    end
    if love.keyboard.isDown("up") then
        vectorY = -1
        player.anim = player.animations.walkUp
        player.dir = "up"
    end
    if love.keyboard.isDown("down") then
        vectorY = 1
        player.anim = player.animations.walkDown
        player.dir = "down"
    end

    player.collider:setLinearVelocity(vectorX * 300, vectorY * 300)

    -- Check if player is moving
    if vectorX == 0 and vectorY == 0 then
        player.isMoving = false
        player.anim:gotoFrame(8) -- go to standing frame
    else
        player.isMoving =  true
    end

    if love.keyboard.isDown("h") then
        player.hello = true
    else
        player.hello = false
    end

end

function player:draw()

    local px = player.collider:getX()
    local py = player.collider:getY()

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

function player:interact()

    local px, py = player.collider:getPosition()

    if player.dir == "right" then
        px = px + 60
    elseif player.dir == "left" then
        px = px - 60
    elseif player.dir == "up" then
        py = py - 60
    elseif player.dir == "down" then
        py = py + 60
    end

    local colliders = world:queryCircleArea(px, py, 40, {"Button", "Chest"})
    for i,c in ipairs(colliders) do
        c:interact()
    end

end