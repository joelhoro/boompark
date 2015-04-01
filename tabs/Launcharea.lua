Launcharea = class(Draggable)

function Launcharea:init(x,y,r)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.r = r
    self.initialr = r
    self.attackers  = {}
    self.flatratio = 0.5
    self.isdraggable = false
    self.arrowshift = 0
end

function Launcharea:Serialize()
    return {x=self.x,y=self.y,r=self.r}
end


function Launcharea:draw()
    pushStyle()
--    fill(0, 0, 0, 255)
    fontSize(28)
    
    sprite("Small World:Base Large",self.x,self.y,self.r,self.r*self.flatratio)
    text(#self.attackers,self.x+self.r*0.4, self.y-self.r*self.flatratio*.5)
    popStyle()
    self:DragIcon(self.x+self.r/2,self.y+self.r*self.flatratio/2)
    if self.arrowshift > 0 then
        sprite("Cargo Bot:Command Grab",self.x,self.y + self.arrowshift)
    end
end


function Launcharea:StartDragging(touch)
    self.dragtween = tween.path(0.3,self,{{r=self.r},{r=self.r*1.2}},{loop=tween.loop.pingpong})
end

function Launcharea:IsInside(touch)
    return ((touch.x-self.x)/self.flatratio)^2+(touch.y-self.y)^2 < self.r^2
end

function Launcharea:IsDraggable()
    return self.isdraggable
end

function Launcharea:PointArrow()
     self.arrowshift = self.r*self.flatratio
    self.tween = tween(1,self,{arrowshift=0},{loop=tween.loop.forever})
end

function Launcharea:touched(touch)
    if game.status == STATUS_LEVELEDITOR then
        Draggable.touched(self,touch)
        return
    elseif touch.state == BEGAN and self:IsInside(touch) then
        if game.map.attackers > 0 then
            DoSound("Game Sounds One:Pop 2")
            sound(DATA, "ZgFARiYuQHIbQEBAcNBtPnqfYj5eKyc/RABAf0BKQFdAaEBA")
            local shift = 150 / #self.attackers
            local attacker = Attack(self.x,self.y)

            for i,a in ipairs(self.attackers) do
             --   local setReady = function() a:SetReady() end
                local destination = {x=self.x+(i-1-#self.attackers/2)*shift, y = self.y}
                SetTween(a, tween(0.5,a,destination,tween.easing.cubicInOut))
            end
            self.attackers[#self.attackers+1] = attacker
            game.map:AddAttack(attacker)
            local path = { {r=self.initialr*1.3},{r=self.initialr} }
            self.tween = tween.path(1,self,path,tween.easing.sineInOut)

            return true
        end        
    end
    return false
end
