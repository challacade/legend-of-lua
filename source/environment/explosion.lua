explosions = {}

function spawnExplosion(x, y)

    local explosion = {}
    explosion.x, explosion.y = x, y
    explosion.timer = 1
    explosion.dead = false

    -- explosion animation
    explosion.grid = anim8.newGrid(270, 276, sprites.explosion:getWidth(), sprites.explosion:getHeight())
    explosion.animation = anim8.newAnimation(explosion.grid('1-10', 1), 0.1)

    function explosion:update(dt)

        self.animation:update(dt)

        if self.timer > 0 then
            self.timer = self.timer - dt
            if self.timer < 0 then
                self.dead = true
            end
        end

        -- Iterate through all explosions in reverse to remove dead ones
        for i=#explosions,1,-1 do
            if explosions[i].dead then
                table.remove(explosions, i)
            end
        end

    end

    table.insert(explosions, explosion)

end

function explosions:update(dt)

    for i,explosion in ipairs(self) do
        explosion:update(dt)
    end
  
end

function explosions:draw()

    for i,explosion in ipairs(self) do
        love.graphics.setColor(1, 1, 1, 1)
        explosion.animation:draw(sprites.explosion, explosion.x, explosion.y, nil, nil, nil, 135, 138)
    end

end
