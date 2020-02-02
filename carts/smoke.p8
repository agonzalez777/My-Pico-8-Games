pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15


function _init() 
    smoke = {}
    cursorx = 50
    cursory = 50
    color = 7
end

function _update()
    foreach(smoke,move_smoke)
    if (btn(0)) then cursorx-=1 end
    if (btn(1)) then cursorx+=1 end
    if (btn(2)) then cursory-=1 end
    if (btn(3)) then cursory+=1 end
    if (btn(4)) then color = flr(rnd(16)) end
    make_smoke(cursorx,cursory,rnd(4),color)
end

function draw_smoke(sm) 
    circfill(sm.x,sm.y,sm.width_size,sm.col)    
end 

function _draw()
    cls()
    foreach(smoke,draw_smoke)
end

function make_smoke(x,y,init_size,col)
    local s = {}
    s.x = x
    s.y = y
    s.col = col
    s.width_size = init_size
    s.width_final = init_size+rnd(3)+1
    s.t = 0
    s.max_t = 30+rnd(10)
    s.dx=(rnd(0.8)-.4)
    s.dy=(rnd(0.5))
    s.ddy = 0.02
    add(smoke,s)
    return s
end

function move_smoke(sp)
    if (sp.t > sp.max_t) then
        del(smoke,sp)
    end
    if (sp.t < sp.max_t-15) then
        sp.width_size+=1
        sp.width_size=min(sp.width_size,sp.width_final)
    end
    sp.x+=sp.dx
    sp.y+=sp.dy
    sp.dy+=sp.ddy
    sp.t+=1
end
