torches = {}

function spawnTorch(x, y, state)

    local torch = world:newRectangleCollider(x, y, 96, 96)
    torch:setType('static')
    torch:setCollisionClass('Torch')

    -- STATE
    -- 0: unlit
    -- 1: lit
    torch.state = state

    -- Animation
    torch.grid = anim8.newGrid(96, 96, sprites.torch_lit:getWidth(), sprites.torch_lit:getHeight())
    torch.animation = anim8.newAnimation(torch.grid('1-4', 1), 0.1)

    function torch:update(dt)

        if self.state == 1 then
            torch.animation:update(dt)
        end

    end

    table.insert(torches, torch)

end

function torches:update(dt)

    for i,torch in ipairs(self) do
      torch:update(dt)
    end
  
end

function torches:draw()

    local spritesheet = sprites.torch_lit

    for i,torch in ipairs(self) do
        love.graphics.setColor(1, 1, 1, 1)
        if torch.state == 0 then
            love.graphics.draw(sprites.torch_unlit, torch:getX(), torch:getY(), nil, nil, nil, 48, 48)
        else
            torch.animation:draw(spritesheet, torch:getX(), torch:getY(), nil, nil, nil, 48, 48)
        end
    end

end
