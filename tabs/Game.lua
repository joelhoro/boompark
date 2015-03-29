Game = class()

-- game statuses
STATUS_DEPLOYMENT = 1
STATUS_ATTACK = 2
STATUS_OVER = 3
STATUS_SIMULATION = 4
STATUS_LEVELEDITOR = 5

function Game:init()
    self.level = readLocalData("level",1)
    self.speed = 20
    self:restart()
end

function Game:changeLevel(l)
    self.gameresults = nil
    self.level = l
    print("Loading level ",l)
    saveLocalData("level",l)
    self.map = GetMap(l)
    self.progress = Progressbar(500,730,900,15,2)
    self:SetStatus(STATUS_DEPLOYMENT)
end

function Game:SetStatus(status)
    self.status = status

    if status == STATUS_DEPLOYMENT then
        music("Game Music One:Nothingness")
    elseif status == STATUS_ATTACK then
        music("Game Music One:Jungle Rampage")
    elseif status == STATUS_OVER then
        music.stop()
        self:Finish()
    end
end

function Game:GoToNextStatus()
    self:SetStatus(self.status+1)
end

function Game:Finish()
    tween.stopAll()

    if game.map:defensealive()==0 then
        self.map:collectStars()
        music("Game Music One:Happy Song")
        message = "You won!"
        messageColor = color(241, 230, 44, 255)
    else
        music("Game Music One:Toy Land")
        message = "Lost..."
        messageColor = color(255, 0, 0, 255)
    end
    self.gameresults = GameResults(message,messageColor)
end

function Game:increaselevel()
    local level = self.level+1
    if level > NumberOfMaps() then
        level = 1
    end
    self:changeLevel(level)  
end

function Game:restart()
    self:changeLevel(self.level)
end

function Game:updateProgress()
    if self.status ~= STATUS_ATTACK or not TIMELIMIT then
        return
    end
    local dt = 0.03
    self.progress.life = math.max(0,self.progress.life - self.speed*dt/self.map.time)
    if self.progress.life==0 then
        self:SetStatus(STATUS_OVER)
    end
end

function Game:draw()
    pushMatrix()
   -- scale(0.5,0.5)

    self.map:draw()
    self:updateProgress()
    self.progress:draw()
    if self.gameresults then
        self.gameresults:draw()
    end
    popMatrix()
end

function Game:touched(touch)
    self.map:touched(touch)
end
