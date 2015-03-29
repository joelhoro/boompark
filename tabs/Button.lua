Button = class()

function Button:init(x,y,r,text,cb)
    self.x = x
    self.y = y
    self.r = r
    self.text = text
    self.ontouch = cb
end

function Button:draw()
    text(self.text,self.x,self.y)
end

function Button:touched(touch)
    if math.abs(self.x-touch.x)+math.abs(self.y-touch.y)<self.r then
        self.ontouch(self)
    end 
end
