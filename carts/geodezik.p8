pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

frame = 0
function _draw()
    rectfill(0,0,127,127,black)
    i=0
    while (i<20) do
        
        e = (i*0.5)
        line(0,(frame*e),127-(frame*e),0,7) -- (0,0,127,0) - (0,10,117,0)
        line((frame*e),127,0,(frame*e),7)   -- (0,127,0,0) - (127,127,0,10)
        line(127,127-(frame*e),(frame*e),127,7) -- (127,127,0,127) - (127,117,10,127)
        line(127,127-(frame*e),127-(frame*e),0,7)  -- (127,127,127,0) - (127,127,127,10)
        i+=1
    end

end

function _update()
    frame+=1
    if frame > 127 then
        frame = 0
    end
end

function _init()


end