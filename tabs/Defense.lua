Defense = class(Draggable)

function Defense:types()
    return {
         { sprite = "Small World:House White",  health = 300    },
         { sprite = "Small World:Mine",         health = 500    },
         { sprite = "Small World:Windmill",     health = 700    },
         { sprite = "Small World:Observatory",  health = 1000   },
         { sprite = "Small World:Court",        health = 1500   },
         { sprite = "Small World:Church",       health = 2500   }
            }
end

function Defense:init(x,y,type,mapposition)
    self.x = x
    self.y = y
    self.mapposition = mapposition
    self.dx = 0
    self.dy = 0

    self.alive = true
    self.isdraggable = false

    
    if type == nil then
        type=math.random(#types)
    end
    
    self.type = type
    
    local def = Defense.types()[type]
    self.sprite = def.sprite
    self.health = def.health
    local size = vec2( spriteSize(self.sprite))
    self.width = size.x 
    self.height = size.y
    self.currenthealth = self.health
    self.star = Dummy()
    self.underattack = false
    self.smoke = Dummy()
end

function Defense:ActivateStar()
    self.star = Star(self.x,self.y,self.width,0)
    self.star:activate()
end

function Defense:Destroy()
    tween.stop(self.shaketween)
    self.alive = false
    self.underattack = false
    self:ActivateStar()
    sound(SOUND_POWERUP, 45464)
    if game.map:defensealive()==0 then
        game:SetStatus(STATUS_OVER)
    end
end

function Defense:hit(damage)
    if not self.underattack then -- if this is the first hit
        self.shaketween = tween(0.2,self,{dx=10},
            {loop=tween.loop.pingpong, easing=tween.easing.sineInOut })
        self.smoke = Smoke(self.x,self.y+self.height/3)
    end
    self.currenthealth = math.max( self.currenthealth - damage/FPS*game.speed,0)
    self.underattack = true
    --sound(SOUND_PICKUP, 45472)
    --DoSound("Game Sounds One:Land Hay",3,0.2)
    if self.currenthealth==0 then
        self:Destroy()
    end  
end

function Defense:StartDragging(touch)
    self.dragtween = tween.path(0.3,self,{{dx=10},{dx=-10}},{loop=tween.loop.pingpong})
end

function Defense:IsDraggable()
    return self.isdraggable
end

function Defense:IsInside(touch)
    return (touch.x-self.x)^2+(touch.y-self.y)^2 < self.width^2
end

function Defense:touched(touch)
    if self.isdraggable and touch.tapCount > 1 and touch.state==BEGAN and self:IsInside(touch) then
        local nexttype = self.type+1
        print(nexttype)
        if nexttype > #(Defense.types()) then nexttype = 1 end
        local defense = Defense(self.x,self.y,nexttype,self.mapposition)
        defense.isdraggable = true
        game.map.defense[self.mapposition] = defense
    else
        Draggable.touched(self,touch)
    end
end

function Defense:draw()
    sprite(self.sprite,self.x+self.dx,self.y+self.dy)
    self.smoke:draw()
 
   if self.alive then
        local progress = Progressbar(self.x,self.y+self.height/1.5,self.width,10,1)
        progress.life = self.currenthealth/self.health
        progress:draw() 
        text(math.floor(self.currenthealth),self.x-self.width/2,self.y-self.height/2)
    else
        self.star:draw()
    end

end
