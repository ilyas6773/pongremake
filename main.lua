--[[
    2022
    Pong Remake
    pong-0
    "The Day-0 Update"
    -- Main Program --
    Author: Tolegenov Ilias
    mister.tolegenov@gmail.com
    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.
    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- speed at which we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
    -- and graphics; try removing this function to see the difference!
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf',8)

    -- larger font for drawing the score on the screen
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set LÖVE2D's active font ro 'smallFont' object
    love.graphics.setFont(smallFont)

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions; replaces our love.window.setMode
    -- form the last example
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizeable = false,
        vsync = true
    })

    -- initialize score variables, used for rendering on the screen and keeping
    -- track of the winner
    player1Score = 0
    player2Score = 0

    -- paddle positions on the Y axis (they can only move up or down)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

--[[
    Runs every frame, with "dt" passed in, our delta in seconds
    since the last frame, which LÖVE2D supplies us
]]
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

--[[
    Keyboard handling, called by LÖVE2D each frame;
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
    --keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate the application
        love.event.quit()
    end
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- clear the screen with specific color; in this case, a color similar
    -- to some versions of the orginal Pong
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- condensed onto one line from last example
    -- note we are now using virtual width and height for text placement
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- draw score on the left and right center of the screen
    -- need to switch front to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    --
    -- paddles are simply rectangles we draw on the screen at certain points,
    -- as is the ball
    --

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- render ball (center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    
    -- end rendering at virtual resolution
    push:apply('end')
end