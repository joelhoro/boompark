Map = class()

function Map:init(info)
    self.time = info.time
    self.defense = info.defense
    self.launchareas = info.launchareas
    self.attackers = info.attackers
    self.attack = {}
end

function Map:SaveLevel()
    saveLocalData("map",json.encode(self))
end

function Map:LoadLevel()
    local map = readLocalData("map")
    self = json.decode(map)
end

function Map:adddefense(obj)  
    self.defense[#self.defense+1] = obj
end

function Map:addattack(obj)  
    self.attack[#self.attack+1] = obj
    local x,y,size = obj.x,obj.y,obj.size
    obj.x = posx
    obj.y = posy
    obj.size = 45
    self.attackers = self.attackers - 1
    tween(1,obj,{x=x,y=y,size=size},tween.easing.cubicIn, function()
      obj:SetReady()
      if self:attackersReady() then
          game:SetStatus(STATUS_ATTACK)
      end
    end)
end

function Map:collectStars()
    local stars = #self.defense
    local space = 55
    local pos = WIDTH/2 - stars * space /2
    for i,d in ipairs(self.defense) do
        d.star:spiral(pos,400,50)
        pos = pos + space
    end
end

function Map:attackersReady()
    -- check if all the attackers have been deployed
    -- and if so, whether they are all ready
    if self.attackers > 0 then return false end
    for i,a in ipairs(self.attack) do
        if not a.ready then
            return false
        end
    end
    return true
end

function Map:addlauncharea(obj)  
    self.launchareas[#self.launchareas+1] = obj
end

function Map:defensealive()
    local alive = 0
    for i,defense in ipairs(self.defense) do
        if defense.alive then
            alive = alive +1
        end
    end
    return alive
end

function Map:touched(touch)
    for i,obj in ipairs(self.launchareas) do
        obj:touched(touch)
    end
    for i,obj in ipairs(self.defense) do
        obj:touched(touch)
    end
    
end


function Map:draw()
    fill(255, 255, 255, 255)
    strokeWidth(2)    
    sprite("SpaceCute:Planet",600,400,3200,2800)
    groups = {
        self.launchareas,
        self.defense,
        self.attack
    }
    for k,group in ipairs(groups) do
        for i,elt in ipairs(group) do
            elt:draw()
        end
    end
    
    posx = 1030
    posy = 740
    for i = 1, self.attackers do
        posx = posx - 40
        sprite("Planet Cute:Character Cat Girl",posx,posy,45)
    end
    
    
end