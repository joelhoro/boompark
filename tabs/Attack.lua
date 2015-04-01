Attack = class()

function Distance(o1,o2)
    return norm(vec2(o1.x,o1.y)-vec2(o2.x,o2.y))
end

function norm(v)
    return math.sqrt(v.x^2+v.y^2)
end

function Attack:init(x,y,type)
    self.x = x
    self.y = y
    self.size = 70
    self.speed = 0.25
    self.damage = 20
    self.ready = false
    self.id = math.random(1e6)
    
    sprites = {
     "Planet Cute:Character Cat Girl",
--        "Planet Cute:Character Horn Girl",
--        "Planet Cute:Character Boy",
    }
    
    self.sprite = sprites[math.random(#sprites)]
    self.wiggle=-1
end

function Attack:SetReady()
    print("Ready")
    self.ready = true
    SetTween(self,tween(0.3,self,{wiggle=1},{loop = tween.loop.pingpong}))
end

function Attack:draw()
    if game.status == STATUS_ATTACK then
        self:move()
    end
    pushMatrix()
    translate(self.x,self.y)
    rotate(self.wiggle*15)
    sprite(self.sprite,0,0,self.size)
    popMatrix()
end


function Closest(obj,objects)
    closest = nil
    dist = 999999
    for i,o in ipairs(objects) do
        if o.alive then
            d = Distance(obj,o)
            if d < dist then
                dist = d
                closest = o
            end
        end
    end
    return closest
end

function Attack:keepdistance()
    local minimumDistance = 50
    for i,a in ipairs(game.map.attack) do
        if a.id ~= self.id then 
            local distance = Distance(self,a)
            if distance < minimumDistance then
                factor = 1.1
                self.x = self.x*factor+a.x*(1-factor) 
                self.y = self.y*factor+a.y*(1-factor) 
            end
        end
    
    end  
end

function Attack:move()
    closest = Closest(self,game.map.defense)
    if closest == nil then
        return
    end
    diff = vec2(closest.x,closest.y)-vec2(self.x,self.y)
    local minimumDistance = closest.width/2
    if norm(diff) > minimumDistance then
        diff = diff / norm(diff)
        self.x = self.x + self.speed*diff.x*game.speed
        self.y = self.y + self.speed*diff.y*game.speed
      --  DoSound("A Hero's Quest:Swing 1",5,0.3)
    else
        closest:Hit(self.damage)
    end
    self:keepdistance()
end