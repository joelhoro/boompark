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
    self.cheat = Dummy()
    self:Restart()
end

function Game:SetParameters()
    parameter.clear()
    if self.status == STATUS_LEVELEDITOR then
        parameter.integer("attackers",1,15,self.map.attackers, function(a) self.map.attackers = a end )
        parameter.action("Load level", function() self.map:LoadLevel() end )
        parameter.action("Save level", function() self.map:SaveLevel() end )
        parameter.action("Add launcharea", function() self.map:CreateNewLaunchArea() end )
        parameter.action("Add building", function() self.map:CreateNewDefense() end )
        parameter.action("Test level", function() self:TestLevel() end )
        parameter.action("Back to game", function() self:SetStatus(STATUS_DEPLOYMENT) end)
    else
        SavedBooleanParameter("TIMELIMIT",true)
        SavedBooleanParameter("DEBUGMODE",true,function(m) self.cheat=Cheatmode(m) end )    
  --      parameter.integer("Level",1,NumberOfMaps(),self.level,function(l) self:ChangeLevel(l) end)
  --      parameter.action("Go to next status", function() self:GoToNextStatus() end )
        parameter.action("Level editor", function() self:SetStatus(STATUS_LEVELEDITOR) end)
    end
end

function Game:ChangeLevel(l)
    self.gameresults = nil
    self.level = l
    print("Loading level ",l)
    saveLocalData("level",l)
    self.map = GetMap(l)
    self.progress = Progressbar(500,730,900,15,2)
    self:SetStatus(STATUS_DEPLOYMENT)
end

function Game:TestLevel()
    -- to be implemented
end

function Game:SetStatus(status)
    if self.status ~= status then
        self.status = status
        self:SetParameters()
    end
    for i,d in ipairs(self.map.defense) do
        d.isdraggable = (status == STATUS_LEVELEDITOR )
    end
    for i,d in ipairs(self.map.launchareas) do
        d.isdraggable = (status == STATUS_LEVELEDITOR )
    end
    
    
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

    if game.map:DefenseAlive()==0 then
        self.map:CollectStars()
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

function Game:IncreaseLevel()
    local level = self.level+1
    if level > NumberOfMaps() then
        level = 1
    end
    self:ChangeLevel(level)  
end

function Game:Restart()
    self:ChangeLevel(self.level)
end

function Game:UpdateProgress()
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
    self:UpdateProgress()
    self.progress:draw()
    if self.gameresults then
        self.gameresults:draw()
    end
    popMatrix()
    
    self.cheat:draw()
end

function Game:keyboard(key)
    self.cheat:keyboard(key)
end


function Game:touched(touch)
    self.map:touched(touch)
    self.cheat:touched(touch)
end
