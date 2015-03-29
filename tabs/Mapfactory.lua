function MapFactory()
    return {
        { 
            attackers = 1, 
            time = 90, 
            defense = { Defense(950,600,1) }, 
            launchareas = { Launcharea(500,300,150), Launcharea(200,500,150) }
        },
        { 
            attackers = 3, 
            time = 160, 
            defense = { Defense(150,600,1), Defense(900,150,6) },
            launchareas = { Launcharea(500,600,150), Launcharea(500,150,150) }
        },
        { 
            attackers = 3, 
            time = 227, 
            defense = { Defense(150,600,4), Defense(900,100,4), Defense(900,400,6) },
            launchareas = { Launcharea(500,100,150), Launcharea(500,350,150), Launcharea(500,600,150) }
        },  
        { 
            attackers = 6, 
            time = 98, 
            defense = { Defense(700,650,1), Defense(700,300,1), Defense(900,500,2), Defense(200,300,2), Defense(200,500,5) }, 
            launchareas = { Launcharea(200,100,150), Launcharea(700,475,150) }
        },
        { 
            attackers = 8, 
            time = 188, 
            defense = { Defense(700,650,1), Defense(500,300,1), Defense(900,500,2), Defense(200,300,2), Defense(200,500,5), Defense(450,670,3), Defense(900,150,6) }, 
            launchareas = { Launcharea(200,100,150), Launcharea(700,475,150), Launcharea(700,100,150) }
        },
        { 
            attackers = 4, 
            time = 227, 
            defense = { Defense(150,600,4), Defense(900,100,4), Defense(900,400,4) },
            launchareas = { Launcharea(500,100,150), Launcharea(500,350,150), Launcharea(500,600,150) }
        }
    
    
           }
end

function NumberOfMaps()
    return #MapFactory()
end

function GetMap(level)    
    info = MapFactory()[level]
    return Map(info)
end


