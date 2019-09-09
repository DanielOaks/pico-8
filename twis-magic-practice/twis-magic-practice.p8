pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- twi's magic test cart
-- by pixienop 2019

function _init()
		game_init()
		start_game()
end

function _update()
		update_game()
end

function _draw()
		draw_game()
end
-->8
-- main game code

-- static stuff

pieces = {
		{name='finesse', s=2, typ=1},
		{name='power', s=1, typ=1},
		{name='style', s=3, typ=1},
		{name='skill', s=4, typ=1},
		{name='focus', s=0, typ=2},
}

board_height = 5
board_width = 5
group_length = 3

-- game state

-- x,y array of piece ids.
--  0 is empty
board = {}

game_cursor_on_board = true
game_cursor = {1,1}

collected_pieces = {}

function new_piece()
		-- lazy lol
		return flr(rnd((#pieces)-1.1))+1
end

function game_init()
		-- we're gonna make a random
		--  game here because testlol
		board = {}
		
		for x=1,board_width do
				board[x] = {}
				for y=1,board_height do
						board[x][y] = new_piece()
				end
		end
		
		-- regenerate lines as needed
		local board_ok = false
		while not board_ok do
				local ok_this_run = true
				local ok_this_line = true
				local this_id = 0
				local same_id = 1
				
				for x=1,board_width do
						this_id = 0
						ok_this_line = true

						for y=1, board_height do
								if board[x][y] == this_id then
										same_id += 1
								else
										same_id = 1
								end
								this_id = board[x][y]
								
								if group_length <= same_id then
										-- line found
										ok_this_line = false
								end
						end

						if not ok_this_line then
								for y=1, board_height do
										board[x][y] = new_piece()
								end
								
								ok_this_run = false
						end
				end

				for y=1,board_width do
						this_id = 0
						ok_this_line = true

						for x=1, board_width do
								if board[x][y] == this_id then
										same_id += 1
								else
										same_id = 1
								end
								this_id = board[x][y]
								
								if group_length <= same_id then
										-- line found
										ok_this_line = false
								end
						end

						if not ok_this_line then
								for x=1, board_width do
										board[x][y] = new_piece()
								end
								
								ok_this_run = false
						end
				end
				
				if ok_this_run then
						board_ok = true
				end
		end
end

function start_game()
		-- reset all state
		game_cursor_on_board = true
		game_cursor = {1,1}
		
		collected_pieces = {}
end

function update_game()
		if game_cursor_on_board then
				if btnp(➡️) then
						game_cursor[1] += 1
				elseif btnp(⬅️) then
						game_cursor[1] -= 1
				end
				
				if btnp(⬆️) then
						game_cursor[2] -= 1
				elseif btnp(⬇️) then
						game_cursor[2] += 1
				end
				
				if game_cursor[1] < 1 then
						game_cursor[1] = board_width
				elseif board_width < game_cursor[1] then
						game_cursor[1] = 1
				end
				
				if game_cursor[2] < 1 then
						game_cursor[2] = board_height
				elseif board_height < game_cursor[2] then
						game_cursor[2] = 1
				end
		end
end

function draw_game()
		cls(0)
		local st = t()

		for x=1,#board do
				for y=1,#board[x] do
						local piece = board[x][y]
						
						print(piece, 90+x*5, y*7)
						
						if piece != 0 then
								local inf = pieces[piece]
								spr(inf.s, x*12, y*12)
						end
				end
		end
		
		if game_cursor_on_board then
				pal(10,0)
				pal(9,0)
				pal(8,0)
				if (st)%1>0.333 then
						pal(10,7)
				end
				if (st+0.333)%1>0.333 then
						pal(9,7)
				end
				if (st+0.666)%1>0.333 then
						pal(8,7)
				end
				spr(16, game_cursor[1]*12-2, game_cursor[2]*12-2, 2,2)
				pal()
		end
end

__gfx__
0999999000011000000002000030000000000000000500000077770000e000000000000000000000000000000000000000000000000000000000000000000000
09000090001001000000220003b30000000200f0000050000e00007007000e000000000000000000000000000000000000000000000000000000000000000000
00900900010c0010000202000030003000020ff0000500000e0ee070000700700000000000000000000000000000000000000000000000000000000000000000
000990000100c0100020e200000003b300ff200f077777700e0ee07000e000000000000000000000000000000000000000000000000000000000000000000000
0009900001c0001002e00200000000300f002ff0070007070e00007000000e000000000000000000000000000000000000000000000000000000000000000000
00900900010c0010020ee200000300000f0f0000070007700e077070070070000000000000000000000000000000000000000000000000000000000000000000
09aaaa900010010000200200003b300000f00000007770000e00007000e000700000000000000000000000000000000000000000000000000000000000000000
0999999000011000000220000003000000000000666666600077770000000e000000000000000000000000000000000000000000000000000000000000000000
0098a98a980000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a00000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a00000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0089a89a890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
