pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

-- Game Settings
user_control = true
cell_size = 4 -- Must be a factor of 120
board_width = 128/cell_size
board_height = 120/cell_size
alive_color = white

-- Initialize Board
function _init()
    generation = 0
    boards = {{}, {}}
    board_index=1
    next_board_index=2
    cursor_location = {x=1,y=1}
-- Initialize the Board with all dead cells
    reset_board(boards[1])
    reset_board(boards[2])
-- Generate Starting Pattern
    --generate_random_seed(5)
    generate_pentomino()
end


-- Reset Board to all Dead Cells
function reset_board(brd) 
    for i=1,board_width do
        brd[i]={}
        for j=1,board_height do
            brd[i][j] = 0
        end    
    end
end

-- These Functions Generate the various types of patterns 

function generate_random_seed(percent) 
    for i=1,(flr(board_width*board_height*(percent/100))) do
        xrand=flr(rnd(board_width)+1)
        yrand=flr(rnd(board_height)+1) 
        boards[board_index][xrand][yrand] = 1
    end
end

function generate_pentomino()
    boards[1][56/cell_size][64/cell_size] = 1
    boards[1][56/cell_size][64/cell_size+1] = 1
    boards[1][56/cell_size+1][64/cell_size-1] = 1
    boards[1][56/cell_size+1][64/cell_size] = 1
    boards[1][56/cell_size+2][64/cell_size] = 1
end

-- Utility Functions

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

-- Draw Functions
function _draw()
    if (not user_control) then
        calculate_next_board()
        goto_next_board()
    end
    draw_board(boards[board_index])    
    draw_status_bar()
    draw_cursor(cursor_location.x,cursor_location.y,cell_size,red)
end
 
-- Draw the Status Bar
function draw_status_bar() 
    rectfill(0,121,128,128,white)
    print("Gen:"..generation.." X-next Z-"..status_user_control,0,122,black)
end

function draw_cursor(x,y,size,color)
    local i,j
    for i=0,size-1 do
        for j=0,size-1 do
            pset(((x-1)*cell_size)+i,((y-1)*cell_size)+j,color)
        end
    end
end

-- Draw the Board
function draw_board(brd)
    cls()
    local i = 1
    for i=0,board_width-1 do
        for j=0,board_height-1 do
                if (brd[i+1][j+1] == 1) then
                    draw_cell(i+(i*(cell_size-1)),j+(j*(cell_size-1)),cell_size,white)
                end    
        end
    end
end

-- Draw an indvidual Cell
function draw_cell(x,y,size,color)
    local i,j
    for i = 0,size-1 do
        for j=0,size-1 do
            pset(x+i,y+j,color)
        end
    end
end

function _update()
    get_input()
    update_status_bar()
end

function get_input()
        if (btnp(fire2)) then
            if (user_control) then
             calculate_next_board()
             goto_next_board()
            end
        end
        if (btnp(fire1)) then
            user_control = not user_control
        end
        if (btnp(up)) then
            cursor_location.y -= 1
            if (cursor_location.y<1) then cursor_location.y=1 end
        end
        if (btnp(down)) then
            cursor_location.y += 1
            if (cursor_location.y>board_height) then cursor_location.y = board_height end
        end
        if (btnp(left)) then
            cursor_location.x -= 1
            if (cursor_location.x<1) then cursor_location.x=1 end
        end
        if (btnp(right)) then
            cursor_location.x += 1
            if (cursor_location.x>board_width) then cursor_location.x = board_width end
        end
end

function update_status_bar()
 if (user_control == true) then
     status_user_control = "Auto"
 else
     status_user_control = "Manual"
 end
end
    

function goto_next_board()
    x = board_index
    board_index = next_board_index
    next_board_index = x
    generation+=1
end