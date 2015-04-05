DISPLAYMODE = STANDARD
--DISPLAYMODE = FULLSCREEN
SOUNDON = true
FPS = 60

function setup()
    
    saveProjectInfo("Author", "Joel Horowitz")
    saveProjectInfo("Description", "Boom park game")
    print(readProjectData("Company"))
--    img = readImage("Small World:Court")
--    saveImage("Project:Icon",img)
    supportedOrientations(LANDSCAPE_ANY)
    displayMode(DISPLAYMODE)
    game = Game()
--    game:SetStatus(STATUS_LEVELEDITOR)
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

