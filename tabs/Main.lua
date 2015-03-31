DISPLAYMODE = STANDARD
DISPLAYMODE = FULLSCREEN
SOUNDON = true
FPS = 60

function setup()
--    img = readImage("Small World:Court")
--    saveImage("Project:Icon",img)

    supportedOrientations(LANDSCAPE_ANY)
    displayMode(DISPLAYMODE)
    game = Game()
    font("AmericanTypewriter-Bold")
end

function keyboard(key)
    game:keyboard(key)
end

function touched(touch)
    game:touched(touch)
end

function draw()
    game:draw()
end

