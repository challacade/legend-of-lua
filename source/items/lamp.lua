lampFires = {}

function spawnLampFire()

    local lx, ly = getLinkFrontPosition(94)
    local lampFire = world:newCircleCollider(lx, ly, 42)
    lampFire:setCollisionClass('Fire')
    lampFire:setType('static')
    lampFire.timer = 0.3
    lampFire.dead = false

    -- Fire animation
    lampFire.grid = anim8.newGrid(72, 96, sprites.lampFire:getWidth(), sprites.lampFire:getHeight())
    lampFire.animation = anim8.newAnimation(lampFire.grid('1-3', 1), 0.1)

    function lampFire:update(dt)

        lampFire.animation:update(dt)

        if self.timer > 0 then
            self.timer = self.timer - dt
            if self.timer < 0 then
                self.dead = true
            end
        end

        local colliders = world:queryCircleArea(self:getX(), self:getY(), 42, {"Torch"})
        for i,c in ipairs(colliders) do
            c.state = 1
        end

        -- Iterate through all fires in reverse to remove dead ones
        for i=#lampFires,1,-1 do
            if lampFires[i].dead then
                lampFires[i]:destroy()
                table.remove(lampFires, i)
            end
        end

    end

    table.insert(lampFires, lampFire)

end

function lampFires:update(dt)

    for i,lampFire in ipairs(self) do
      lampFire:update(dt)
    end
  
end

function lampFires:draw()

    for i,lampFire in ipairs(self) do
        love.graphics.setColor(1, 1, 1, 1)
        lampFire.animation:draw(sprites.lampFire, lampFire:getX(), lampFire:getY(), nil, nil, nil, 36, 58)
    end

end
