Map = class()

function Map:init(info)
    self.time = info.time
    self.defense ={}
    for i,defense in ipairs(info.defense) do
        self:AddDefense(defense)
    end
    self.launchareas = info.launchareas
    self.attackers = info.attackers
    self.attack = {}
end

function Map:CreateNewLaunchArea()
end

function Map:CreateNewDefense()
end

function Map:SerializingFields()
    return { "time", "attackers" }
end

function Map:Serialize()
    local out = {}
    for i,v in ipairs(self:SerializingFields()) do
        out[v] = self[v]
    end
    out.defense = {}
    out.launchareas = {}
    for i, d in ipairs(self.defense) do
        out.defense[i] = d:Serialize()
    end
    for i, d in ipairs(self.launchareas) do
        out.launchareas[i] = d:Serialize()
    end
    return out
end

function Map:DeSerialize(t)
    local data = json.decode(t)
    for i,v in ipairs(self:SerializingFields()) do
        self[v] = data[v]
    end
end

function Map:SaveLevel()
    sprite()
    print("Level saved")
    local output = json.encode(self:Serialize())
    print(output)
    saveText("Dropbox:map.txt",output)
end

function Map:LoadLevel()
    self:DeSerialize(readText("Dropbox:map.txt"))
end


function Map:LoadLevel()
    local map = readLocalData("map")
    self = json.decode(map)
end

function Map:AddDefense(obj)  
    self.defense[#self.defense+1] = obj
    obj.mapposition = #self.defense
end

function Map:AddAttack(obj)  
    self.attack[#self.attack+1] = obj
    local x,y,size = obj.x,obj.y,obj.size
    obj.x = posx
    obj.y = posy
    obj.size = 45
    self.attackers = self.attackers - 1
    tween(1,obj,{x=x,y=y,size=size},tween.easing.cubicIn, function()
      obj:SetReady()
      if self:AttackersReady() then
          game:SetStatus(STATUS_ATTACK)
      end
    end)
end

function Map:CollectStars()
    local stars = #self.defense
    local space = 55
    local pos = WIDTH/2 - stars * space /2
    for i,d in ipairs(self.defense) do
        d.star:spiral(pos,400,50)
        pos = pos + space
    end
end

function Map:AttackersReady()
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

function Map:AddLauncharea(obj)  
    self.launchareas[#self.launchareas+1] = obj
end

function Map:DefenseAlive()
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
        if touch.state == BEGAN then
            obj:PointArrow()
        end
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
