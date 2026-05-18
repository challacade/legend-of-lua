shaders = {}

-- NOTE: These shaders are written using GLSL for Love2D

-- For web compatibility:
-- WebGL/GLES forbids initializers on uniform/extern declarations and
-- on file-scope 'number' (= mediump float). Use plain declarations and
-- 'const float' for compile-time constants.

-- Hole-punch light source
shaders.simpleLight = love.graphics.newShader[[
    extern number playerX;
    extern number playerY;

    const float radius = 400.0;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2.0) + pow(screen_coords.y - playerY, 2.0), 0.5);
        if (distance < radius) {
            return vec4(0, 0, 0, 0);
        }
        else {
            return vec4(0, 0, 0, 1);
        } 
    }
]]

-- Faded light source
shaders.trueLight = love.graphics.newShader[[
    extern number playerX;
    extern number playerY;

    const float radius = 900.0;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2.0) + pow(screen_coords.y - playerY, 2.0), 0.5);
        number alpha = distance / radius;
        return vec4(0, 0, 0, alpha);
    }
]]

-- White damage flash
shaders.whiteout = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        vec4 pixel = Texel(texture, texture_coords);
        if (pixel.a == 1.0) {
            return vec4(1, 1, 1, 1);
        } else {
            return vec4(0, 0, 0, 0);
        }
    }
]]

function shaders:update(dt)
    if gameMap.dark then
        local px, py = player:getPosition()

        -- Get width/height of background
        local mapW = gameMap.width * gameMap.tilewidth
        local mapH = gameMap.height * gameMap.tileheight

        local lightX = (windowWidth/2)
        local lightY = (windowHeight/2)

        -- Left border
        if cam.x < windowWidth/2 then
            lightX = px * scale
        end

        -- Top border
        if cam.y < windowHeight/2 then
            lightY = py * scale
        end

        -- Right border
        if cam.x > (mapW - windowWidth/2) then
            lightX = (px - cam.x) * scale + (windowWidth/2)
        end

        -- Bottom border
        if cam.y > (mapH - windowHeight/2) then
            lightY = (py - cam.y) * scale + (windowHeight/2)
        end

        shaders.simpleLight:send("playerX", lightX)
        shaders.simpleLight:send("playerY", lightY)
        shaders.trueLight:send("playerX", lightX)
        shaders.trueLight:send("playerY", lightY)
    end
end
