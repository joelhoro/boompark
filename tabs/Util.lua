function DoSound(file,volume,freq)
    if freq==nil then freq=1 end
    if SOUNDON and math.random()<freq then
        sound(file)
    end
end

function SavedBooleanParameter(name,default,cb)
    updateFn = function(v) 
        saveLocalData(name,v) 
        if cb ~= nil then
            cb(v)
        end
    end
    parameter.boolean(name,readLocalData(name,default),updateFn)
end

function SavedIntegerParameter(name,default,min,max,cb)
    updateFn = function(v) 
        saveLocalData(name,v) 
        if cb ~= nil then
            cb(v)
        end
    end
    parameter.integer(name,min,max,updateFn)
    -- x = readLocalData(name,default)
end


function SetTween(obj,t)
    if obj.tween ~= nil then
        tween.stop(obj.tween)
    end
    obj.tween = t
end
