GameResults = class()

function GameResults:init(message,color)
    -- you can accept and set parameters here
    self.x = 0
    self.y = 0
    self.r = 0
    self.fontsize = 1
    self.active = true
    self.message = message
    self.color = color
    tween(1.5,self,{x = 470,y=500,r=-360*4,fontsize=70},tween.easing.cubicInOut)
end

function GameResults:draw()
    if self.active then
        pushStyle()
        pushMatrix()
        font("Noteworthy-Bold")
        fontSize(self.fontsize)
        fill(self.color)
        translate(self.x,self.y)
        rotate(self.r)
        text3D(self.message,0,0)
        popMatrix()
        popStyle()
    end
end

function GameResults:touched(touch)
    -- Codea does not automatically call this method
end
