function gameStart()

    math.randomseed(os.time())
    love.graphics.setBackgroundColor(26/255, 26/255, 26/255)

    -- Initialize all global variables for the game
    initGlobals()

    -- Make pixels scale!
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- 3 parameters: fullscreen, width, height
    -- width and height are ignored if fullscreen is true
    fullscreen = true
    testWindow = false
    vertical = false
    if love.system.getOS() ~= "Web" then
        setWindowSize(fullscreen, 1920, 1080)
    else
        -- Web (love.js): canvas size is fixed by conf.lua. getWidth/Height
        -- returns 0 this early, so hardcode to avoid scale=0.
        windowWidth = 1920
        windowHeight = 1080
    end

    if vertical then
        fullscreen = false
        testWindow = true
        setWindowSize(fullscreen, 1360, 1920)
    end

    -- The game's graphics scale up, this method finds the right ratio
    setScale()

    vector = require "libraries/hump/vector"
    flux = require "libraries/flux/flux"
    require "libraries/tesound"
    require("libraries/show")

    anim8 = require("libraries/anim8/anim8")
    sti = require("libraries/Simple-Tiled-Implementation/sti")

    local windfield = require("libraries/windfield")
    world = windfield.newWorld(0, 0, false)
    world:setQueryDebugDrawing(true)

    -- This second world is for particles, and has downward gravity
    particleWorld = windfield.newWorld(0, 250, false)
    particleWorld:setQueryDebugDrawing(true)

    require("src/startup/require")
    requireAll()

end

function setWindowSize(full, width, height)
    if full then
        fullscreen = true
        love.window.setFullscreen(true)
        windowWidth = love.graphics.getWidth()
        windowHeight = love.graphics.getHeight()
    else
        fullscreen = false
        if width == nil or height == nil then
            windowWidth = 1920
            windowHeight = 1080
        else
            windowWidth = width
            windowHeight = height
        end
        love.window.setMode( windowWidth, windowHeight, {resizable = not testWindow} )
    end
end

function initGlobals()
    data = {} -- save data, will be loaded after game begins

    -- game state
    -- 0: main menu
    -- 1: gameplay
    gamestate = 0
    globalStun = 0
end

function setScale(input)
    scale = (7.3 / 1200) * windowHeight

    if vertical then
        scale = (7 / 1200) * windowHeight
    end

    if cam then
        cam:zoomTo(scale)
    end
end

function checkWindowSize()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    if width ~= windowWidth or height ~= windowHeight then
        reinitSize()
    end
end

function reinitSize()
    -- Reinitialize everything
    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
    setScale()
    pause:init()
    initFonts()
end
