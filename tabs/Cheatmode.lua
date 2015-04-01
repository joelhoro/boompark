Cheatmode = class(Dummy)

function Cheatmode:init(active)
    self.active = active
    self.x = 50
    self.y = 700
end

function Cheatmode:draw()
    if self.active then
        text(math.floor(game.level),self.x,self.y)
        local time = math.floor((1-game.progress.life)*game.map.time)
        text("Time: "..time,600,700)
    end
end
