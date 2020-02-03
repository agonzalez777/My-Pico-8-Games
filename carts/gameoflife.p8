pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

board_width = 128
board_height = 128
alive_color = white
generation = 0
boards = {{}, {}}
board_index=1
next_board_index=2
function reset_board(brd) 
    for i=1,board_width do
        brd[i]={}
        for j=1,board_height do
            brd[i][j] = 0
        end    
    end
end

function draw_board(brd)
    cls()
    local i = 1
    for i=1,board_width do
        for j=1,board_height do
                if (brd[i][j] == 1) then
                    pset(i,j,white)
                end    
        end
    end
end

function _init()
-- Initialize the Board with all dead cells
    reset_board(boards[1])
    reset_board(boards[2])
-- Randomly Select about 5% of the Board to Populate with live cells
--[[    local i = 1
    for i=1,(flr(board_width*board_height*.05)) do
        xrand=flr(rnd(board_width)+1)
        yrand=flr(rnd(board_height)+1) 
        boards[1][xrand][yrand] = 1
    end]]
-- draw an r pentomino
boards[1][60][64] = 1
boards[1][60][65] = 1
boards[1][61][63] = 1
boards[1][61][64] = 1
boards[1][62][64] = 1

end

function calculate_next_board() 
    local i = 1
    local j = 1
    for i=1,board_width do
        for j=1,board_height do
            local count = count_neighbors(boards[board_index],i,j)
            if (boards[board_index][i][j] == 1 and (count == 2 or count == 3)) then
                boards[next_board_index][i][j] = 1
            elseif (boards[board_index][i][j]==0 and count==3) then
                boards[next_board_index][i][j] = 1
            else 
                boards[next_board_index][i][j] = 0
            end
        end
    end
end

function count_neighbors(brd,x,y)
    local ncount = 0
    -- to the west
    if (x>1 and brd[x-1][y] == 1) then ncount+=1 end
    -- to the northwest
    if (x>1 and y>1 and brd[x-1][y-1] == 1) then ncount+=1 end
    -- to the north
    if (y>1 and brd[x][y-1] == 1) then ncount+=1 end
    -- to the northeast
    if (x<board_width and y>1 and brd[x+1][y-1] == 1) then ncount+=1 end
    -- to the east
    if (x<board_width and brd[x+1][y] == 1) then ncount+=1 end
    -- to the southeast
    if (x<board_width and y<board_height and brd[x+1][y+1] == 1) then ncount+=1 end
    -- to the south
    if (y<board_height and brd[x][y+1] == 1) then ncount+=1 end
    -- to the southwest
    if (x>1 and y<board_height and brd[x-1][y+1] == 1) then ncount+=1 end
    return ncount
end

function _update()
    
end


function _draw()
    draw_board(boards[board_index])    
    calculate_next_board()
    x = board_index
    board_index = next_board_index
    next_board_index = x
    print("Generation: "..generation,0,115)
    generation+=1
end