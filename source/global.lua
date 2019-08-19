-- Returns the x, y position that is in front of Link
-- "dist" number of pixels away
function getLinkFrontPosition(dist)

    local px, py = player.collider:getPosition()

    if player.dir == "right" then
        px = px + dist
    elseif player.dir == "left" then
        px = px - dist
    elseif player.dir == "up" then
        py = py - dist
    elseif player.dir == "down" then
        py = py + dist
    end

    return px, py

end
