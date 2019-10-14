-- All sprites (images)
sprites = {}
sprites.background = love.graphics.newImage('images/palaceRoom2.png')
sprites.linkTest = love.graphics.newImage('images/linkTest.png')
sprites.linkWalkSheet = love.graphics.newImage('images/link_walk.png')
sprites.chestClosed = love.graphics.newImage('images/chestClosed.png')
sprites.chestOpen = love.graphics.newImage('images/chestOpen.png')
sprites.hello = love.graphics.newImage('images/hello.png')
sprites.lampFire = love.graphics.newImage('images/lampFire.png')
sprites.torch_unlit = love.graphics.newImage('images/torch_unlit.png')
sprites.torch_lit = love.graphics.newImage('images/torch_lit.png')
sprites.bomb = love.graphics.newImage('images/bomb_sheet.png')
sprites.explosion = love.graphics.newImage('images/explosion_sheet.png')

sprites.items = {}
sprites.items.key = love.graphics.newImage('images/key.png')
sprites.items.bombs = love.graphics.newImage('images/bombs.png')
sprites.items.heartPiece = love.graphics.newImage('images/heartPiece.png')
sprites.items.rupees50 = love.graphics.newImage('images/rupees50.png')

-- All fonts
fonts = {}
fonts.title = love.graphics.newFont("fonts/russoone/RussoOne-Regular.ttf", 42)
fonts.debug = love.graphics.newFont("fonts/vt323/VT323-Regular.ttf", 90)
fonts.origin = love.graphics.newFont("fonts/vt323/VT323-Regular.ttf", 78)