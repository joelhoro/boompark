Progressbar = class()

function Progressbar:init(x,y,w,h,style)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.life = 1
    self.style = style
end

function Progressbar:draw()
    if self.life == 1 or self.life == 0 then
        return
    end
    pushStyle()
    if self.style == 1 then
        fill(102, 231, 41, 255)
    elseif self.style == 2 then
        fill(217, 210, 210, 81)
                
    end
    local totalwidth = self.width
    local width = self.life*totalwidth
    rect(self.x-totalwidth/2,self.y,totalwidth,self.height)
    fill(255, 255, 255, 255)
    rect(self.x+width-totalwidth/2,self.y,totalwidth-width,self.height)
    popStyle()
end

