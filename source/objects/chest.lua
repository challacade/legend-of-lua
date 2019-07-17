chests = {}

function spawnChest(x, y, item)

    local chest = world:newRectangleCollider(x, y, 96, 96)
    chest:setCollisionClass('Chest')
    chest:setType('static')

    -- STATE
    -- 0: closed
    -- 1: opening
    -- 2: pause
    -- 3: finished
    chest.state = 0
    chest.item = item
    chest.timer = 0
    chest.itemY = 0

    function chest:update(dt)

        if self.timer > 0 then
            self.timer = self.timer - dt
            if self.timer < 0 then
                if self.state == 1 then
                    self.timer = 0.75
                    self.state = 2
                elseif self.state == 2 then
                    self.state = 3
                end
            end
        end

        if self.state == 1 then
            chest.itemY = chest.itemY + 2
        end

    end

    function chest:interact()

        if self.state == 0 then
            self.state = 1
            self.timer = 0.65
        end

    end

    table.insert(chests, chest)

end

function chests:update(dt)

    for i,chest in ipairs(self) do
      chest:update(dt)
    end
  
end

function chests:draw()

    for i,chest in ipairs(self) do
        local chestSprite = sprites.chestClosed
        if chest.state > 0 then
            chestSprite = sprites.chestOpen
        end

        love.graphics.setColor(1, 1, 1, 1)
        local cx, cy = chest:getPosition()
        love.graphics.draw(chestSprite, cx-48, cy-48)

        local itemWidth = sprites.items[chest.item]:getWidth()
        local itemHeight = sprites.items[chest.item]:getHeight()

        if chest.state == 1 or chest.state == 2 then
            love.graphics.draw(sprites.items[chest.item], cx, cy - chest.itemY, nil, nil, nil, itemWidth/2, itemHeight/2)
        end
    end

end
