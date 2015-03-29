DISPLAYMODE = STANDARD
DISPLAYMODE = FULLSCREEN
SOUNDON = true
FPS = 60

function setup()
    supportedOrientations(LANDSCAPE_ANY)
    displayMode(DISPLAYMODE)
    SavedBooleanParameter("TIMELIMIT",true)
    SavedBooleanParameter("DEBUGMODE",true,function(m) cheat=Cheatmode(m) end )    
    game = Game()
    cheat = Cheatmode(DEBUGMODE)
    game:SetStatus(STATUS_LEVELEDITOR)
    parameter.action("Save level", function() game.map:SaveLevel() end )
    font("AmericanTypewriter-Bold")
end

function keyboard(key)
    cheat:keyboard(key)
end

function touched(touch)
    game:touched(touch)
    cheat:touched(touch)
end

function draw()
    game:draw()
    cheat:draw()
end

