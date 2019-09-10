pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- twi's magic test cart
-- by pixienop 2019

function _init()
		poke(0x5f2e,1) -- keep palette

		game_init()
		start_game()
end

function _update()
		update_game()
end

function _draw()
		draw_game()

		pal(4,132,1)
		pal(5,140,1)
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

board_height = 8
board_width = 5
group_length = 3
board_offset_v = 10

-- game state

-- x,y array of piece ids.
--  0 is empty
board = {}

game_cursor_on_board = true
game_cursor = {1,1}
game_cursor_dragging = false
game_drag_cursor = {3,2}

collected_pieces = {}

in_falling_mode = false
falling_pieces = {}

function enter_falling_mode()
		in_falling_mode = true

		for x=1,#board do
				local fallin = false
				local new_needed = 0
				for iy=1,board_height do
						local y = board_height+1-iy
						if board[x][y] == 0 then
								fallin = true
								new_needed += 1
						end
						
						if fallin and board[x][y] != 0 then
								local new_fp = {}
								new_fp.id = board[x][y]
								new_fp.x = x
								new_fp.initial_y = y
								new_fp.initial_time = t()
								falling_pieces[x][#falling_pieces[x]+1] = new_fp
								
								board[x][y] = 0
						end
				end
		end
end

function update_falling_mode()
		-- do nothing
end

function new_piece()
		-- lazy lol
		return flr(rnd((#pieces)-.1))+1
end

function dupe_board(a)
		local new_board = {}

		for x=1,#board do
				new_board[x] = {}
				for y=1,#a[x] do
						new_board[x][y] = a[x][y]
				end
		end

		return new_board
end

function list_board_matches(oldx, oldy, newx, newy)
		-- get this_board
		local this_board = {}
		if 0 < oldx and 0 < oldy and 0 < newx and 0 < newy then
				-- do copy and replacement
				this_board = dupe_board(board)
				local new_id = board[newx][newy]
				this_board[newx][newy] = board[oldx][oldy]
				this_board[oldx][oldy] = new_id
		else
				this_board = board
		end
		
		-- collect matches
		local matches = {}
		
		for x=1,board_width do
				local this_id = 0
				local same_id = 1
				local group_found = false
				-- since p8 doesn't care about
				--  invalid table accesses here
				--  just doing this is fine
				--  ♥♥♥
				for y=1,board_height+1 do
						if this_board[x][y] == this_id then
								same_id += 1
						else
								if group_found then
										group_found = false
										if this_id != 0 then -- dont match empty
												for i=1,same_id do
														matches[#matches+1] = {x,y-i}
												end
										end
								end
								same_id = 1
								this_id = this_board[x][y]
						end
								
						if group_length <= same_id then
								group_found = true
						end
				end
		end
		
		for y=1,board_height do
				local this_id = 0
				local same_id = 1
				local group_found = false
				for x=1,board_width+1 do
						if this_board[x] != nil and this_board[x][y] == this_id then
								same_id += 1
						else
								if group_found then
										group_found = false
										if this_id != 0 then -- dont match empty
												for i=1,same_id do
														matches[#matches+1] = {x-i,y}
												end
										end
								end
								same_id = 1
								if this_board[x] != nil then
										this_id = this_board[x][y]
								end
						end
								
						if group_length <= same_id then
								group_found = true
						end
				end
		end
		
		return matches
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
				
				falling_pieces[x] = {}
		end
		
		-- regenerate lines as needed
		local board_ok = false
		while not board_ok do
				local ok_this_run = true
				local ok_this_line = true
				local this_id = 0
				local same_id = 1
				
				for x=1,board_width do
						same_id = 1
						this_id = 0
						ok_this_line = true

						for y=1, board_height do
								if board[x][y] == this_id then
										same_id += 1
								else
										same_id = 1
										this_id = board[x][y]
								end
								
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

				for y=1,board_height do
						same_id = 1
						this_id = 0
						ok_this_line = true

						for x=1, board_width do
								if board[x][y] == this_id then
										same_id += 1
								else
										same_id = 1
										this_id = board[x][y]
								end
								
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
		if in_falling_mode then
				update_falling_mode()
				return
		end

		if game_cursor_on_board then
				if btnp(🅾️) then
						game_cursor_dragging = not game_cursor_dragging
						if game_cursor_dragging then
								game_drag_cursor[1] = game_cursor[1]
								game_drag_cursor[2] = game_cursor[2]
						else
								--todo: only allow changing
								-- if item 'affects play'
								local matches = list_board_matches(game_drag_cursor[1], game_drag_cursor[2], game_cursor[1], game_cursor[2])
								if 0 < #matches then
										local old_item = board[game_cursor[1]][game_cursor[2]]
										board[game_cursor[1]][game_cursor[2]] = board[game_drag_cursor[1]][game_drag_cursor[2]]
										board[game_drag_cursor[1]][game_drag_cursor[2]] = old_item
										
										local new_board = dupe_board(board)
										
										for i=1,#matches do
												local id = board[matches[i][1]][matches[i][2]]
												new_board[matches[i][1]][matches[i][2]] = 0
												if collected_pieces[id] == nil then
														collected_pieces[id] = 1
												else
														collected_pieces[id] += 1
												end
										end
										board = new_board
										
										enter_falling_mode()
								end
						end
				end
				local old_game_cursor = {game_cursor[1],game_cursor[2]}
		
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
				
				-- force same x or y
				if game_cursor_dragging then
						if game_cursor[1] != game_drag_cursor[1] and game_cursor[2] != game_drag_cursor[2] then
								game_cursor = old_game_cursor
						end
				end
		end
end

function draw_game()
		local st = t()
		cls(4)
		
		rect(8,board_offset_v+7,12*board_width+11,board_offset_v+12*board_height+12,9)
		rectfill(8,board_offset_v+8,12*board_width+11,board_offset_v+12*board_height+11,0)

		for x=1,#board do
				for y=1,#board[x] do
						local piece = board[x][y]
						
						local c = 0
						if x == game_cursor[1] and y == game_cursor[2] then
								c = 7
						end
						print(piece, 100+x*4, 70+y*6, c)
						
						if piece != 0 then
								local inf = pieces[piece]
								spr(inf.s, x*12, board_offset_v+y*12)
						end
				end
		end

		for x=1,#falling_pieces do
				for i=1,#falling_pieces[x] do
						local inf = falling_pieces[x][i]

						local moved = ((t()-inf.initial_time) * 9.9)
						moved *= moved
						moved *= 0.5
						spr(pieces[inf.id].s, inf.x*12,board_offset_v+inf.initial_y*12 + moved)
				end
		end
		
		if game_cursor_dragging then
				pal(10,0)
				pal(9,0)
				pal(8,0)
				if (st)%1>0.333 then
						pal(10,2)
				end
				if (st+0.333)%1>0.333 then
						pal(9,2)
				end
				if (st+0.666)%1>0.333 then
						pal(8,2)
				end
				spr(16, game_drag_cursor[1]*12-2, board_offset_v+game_drag_cursor[2]*12-2, 2,2)
				pal()
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
				spr(16, game_cursor[1]*12-2, board_offset_v+game_cursor[2]*12-2, 2,2)
				pal()
		end
		
		-- new piece direction marker
		pal(7,0)
		spr(8, 36,9)
		pal()
		
		-- piece counts
		rectfill(76,6,100,53,0)
		for i=1,#pieces do
				spr(pieces[i].s,78,9*i-1)
				local c = 0
				if collected_pieces[i] != nil then
						c = collected_pieces[i]
				end
				print(c, 91,9*i+1, 7)
		end
		
		-- twi
		palt(0, false)
		pal(15,12)
		local sp = 18
		if (st % 1) > 0.5 then
				sp = 24
		end
		spr(sp, 80,56, 2,2)
		palt()
		pal()
		rect(79,55, 80+16,56+16, 13)
		
		-- celly
		palt(0, false)
		pal(15,1)
		spr(20, 80,76, 2,2)
		palt()
		pal()
		rect(79,75, 80+16,76+16, 7)

		-- luna
		palt(0, false)
		pal(15,12)
		spr(22, 80,96, 2,2)
		palt()
		pal()
		rect(79,95, 80+16,96+16, 1)
end

__gfx__
0999999000011000000002000030000000000000000600000077770000e000000000000000000000000000000000000000000000000000000000000000000000
09000090001551000000220003b30000000200f0000060000e66667007000e000000000000770000000000000000000000000000000000000000000000000000
00900900015c5510000e22000030003000020ff0000600000e6ee670000700700700007000077000000000000000000000000000000000000000000000000000
000990000155c5100022e200000003b300ff277f077777700e6ee67000e000000770077000007700000000000000000000000000000000000000000000000000
0009900001c5551002e22200000000300f772ff0077777070e66667000000e000077770000007700000000000000000000000000000000000000000000000000
00900900015c5510022ee200000300000f7f0000077777700e677670070070000007700000077000000000000000000000000000000000000000000000000000
09aaaa900015510000222200003b300000f00000007770000e66667000e000700000000000770000000000000000000000000000000000000000000000000000
0999999000011000000220000003000000000000666666600077770000000e000000000000000000000000000000000000000000000000000000000000000000
0098a98a98000000fff1111dfffffffffffcccc79a9ccffffffff551d0d55ffffff1111dffffffff000000000000000000000000000000000000000000000000
0a00000000a00000fff1111ddfffddffffccccc77aac77ffff575551100511fffff1111ddfffddff000000000000000000000000000000000000000000000000
8000000000090000fff1111dd821ddfffcccccc779aa77a9ff5555511d00110dfff1111dd821ddff000000000000000000000000000000000000000000000000
9000000000080000ff11111d8211dddffcccbbb7bb99777ffff5575155dd111fff11111d8211dddf000000000000000000000000000000000000000000000000
a0000000000a0000ff11111182111ddffccbbbbbbbbbb77fffff55555555511fff11111182111ddf000000000000000000000000000000000000000000000000
8000000000090000ff111f77d77d1ddffcbbbb777777b77fffff551511115115ff111f77d77d1ddf000000000000000000000000000000000000000000000000
9000000000080000ffffff07d07ddddffcbbbb077077777cfff5550510111115ffffff07d07ddddf000000000000000000000000000000000000000000000000
a0000000000a0000ffffff07d07ddddfccbbbb077077777cf555550110111115ffffff07d07ddddf000000000000000000000000000000000000000000000000
8000000000090000ffffddddddddd1ffcbbb7777777c7ccc5555111111111155ffffddddddddd1ff000000000000000000000000000000000000000000000000
9000000000080000ffffddddded1d1ffbbbb7777777ccccb575511111111155fffffddddded1d1ff000000000000000000000000000000000000000000000000
0a00000000a00000fffffdddeedd11ffbbbb77766777ccbb555511100111155ffffffdddeedd11ff000000000000000000000000000000000000000000000000
0089a89a89000000ffffffddddddd1ffbbbbd77777777cbb55555111111115ffffffffddddddd1ff000000000000000000000000000000000000000000000000
0000000000000000ffffff11dddd11ffbbdddddd777799bb5f5555551111ddffffffff11dddd11ff000000000000000000000000000000000000000000000000
0000000000000000fffff88ddd1111ffdddddddd7799aa9dff55575511dd00dffffff88ddd1111ff000000000000000000000000000000000000000000000000
0000000000000000ffff222ddd111fffddddeee999aaa9ddff57555ddd000dffffff222ddd111fff000000000000000000000000000000000000000000000000
0000000000000000ffff111ddd11dfffdddeee92aaaa977ef55555d70000d11fffff111ddd11dfff000000000000000000000000000000000000000000000000
