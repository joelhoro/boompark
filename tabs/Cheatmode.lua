Cheatmode = class()

function Cheatmode:init(active)
    self.active = active
    self.x = 50
    self.y = 700
    self.button = Button(50,100,50,"M",function(b) game:GoToNextStatus() end)
end

function Cheatmode:draw()
    if self.active then
        text(math.floor(game.level),self.x,self.y)
        local time = math.floor((1-game.progress.life)*game.map.time)
        text("Time: "..time,600,700)
        self.button:draw()
    end
end


function Cheatmode:keyboard(key)
    if self.active then
        if key == "l" then
            game:increaselevel()
        end
    end
end

function Cheatmode:touched(touch)
    local inside = math.abs(touch.x-self.x)+math.abs(touch.y-self.y)<100
    if inside then
        game:increaselevel()
    end
    self.button:touched(touch)
end
