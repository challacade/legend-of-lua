bombs = {}

function spawnBomb()

    local bomb = {}
    bomb.x, bomb.y = getLinkFrontPosition(94)
    bomb.state = 0
    bomb.timer = 1.5
    bomb.dead = false

    -- Bomb animation
    bomb.grid = anim8.newGrid(270, 276, sprites.bomb:getWidth(), sprites.bomb:getHeight())
    bomb.animation = anim8.newAnimation(bomb.grid('1-16', 1), 0.05)

    function bomb:update(dt)

        if self.state == 1 then
            self.animation:update(dt)
        end

        if self.timer > 0 then
            self.timer = self.timer - dt
            if self.timer < 0 then
                if self.state == 0 then
                    self.state = 1
                    self.timer = 0.8
                else
                    self.dead = true
                    spawnExplosion(self.x, self.y)
                end
            end
        end

        -- Iterate through all bombs in reverse to remove dead ones
        for i=#bombs,1,-1 do
            if bombs[i].dead then
                table.remove(bombs, i)
            end
        end

    end

    table.insert(bombs, bomb)

end

function bombs:update(dt)

    for i,bomb in ipairs(self) do
      bomb:update(dt)
    end

end

function bombs:draw()

    for i,bomb in ipairs(self) do
        love.graphics.setColor(1, 1, 1, 1)
        bomb.animation:draw(sprites.bomb, bomb.x, bomb.y, nil, nil, nil, 135, 138)
    end

end
