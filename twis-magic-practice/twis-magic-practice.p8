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
		pal(6,141,1)
end
-->8
-- main game code

-- static stuff

bg_pattern_1 = {
		0b1001110001100011,
		0b1100011000111001,
		0b0110001110011100,
		0b0011100111000110,
}

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

turns = 0

-- x,y array of piece ids.
--  0 is empty
board = {}

game_cursor_on_board = true
game_cursor = {1,1}
game_cursor_dragging = false
game_drag_cursor = {3,2}

collected_pieces = {}
chaos_tokens = 0 -- specials >:o

in_falling_mode = false
falling_pieces = {}

function collect_matches(matches)
		local new_board = dupe_board(board)
		
		local new_piece_pos = {}
		for x=1,board_width do
				new_piece_pos[x] = 0
		end
		
		for i=1,#matches do
				local id = board[matches[i][1]][matches[i][2]]
				local x = matches[i][1]
				
				-- add to falling list
				local new_fp = {}
				new_fp.id = new_piece()
				new_fp.x = x
				new_fp.initial_y = new_piece_pos[x]
				new_fp.initial_time = t()
				falling_pieces[x][#falling_pieces[x]+1] = new_fp								
				new_piece_pos[x] -= 1

				new_board[x][matches[i][2]] = 0
				if collected_pieces[id] == nil then
						collected_pieces[id] = 1
				else
						collected_pieces[id] += 1
				end
		end
		board = new_board
end

function calc_y_of(position, initial_time)
		local moved = 0
		if initial_time != nil then
				moved = ((t()-initial_time) * 9.9)
				moved *= moved
				moved *= 0.5
		end
		return board_offset_v+position*12 + moved
end

function enter_falling_mode()
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

		in_falling_mode = true
end

function update_falling_mode()
		local num_falling_pieces = 0
		for x=1,#falling_pieces do
				num_falling_pieces += #falling_pieces[x]
		end
		if num_falling_pieces == 0 then
				local matches = list_board_matches()
				if 0 < #matches then
						collect_matches(matches)
						enter_falling_mode()
				else
						in_falling_mode = false
				end
				return
		end

		local stop_at = {}
		for x=1,board_width do
				stop_at[x] = calc_y_of(board_height)
				for i=1,board_height do
						local y = board_height+1-i
						
						if board[x][y] == 0 then
								break
						end
						stop_at[x] = calc_y_of(y-1)
				end
		end
		
		local dead_fps = 0
		for x=1,#falling_pieces do
				for i=1,#falling_pieces[x] do
						local fp = falling_pieces[x][i]
						local fp_y = calc_y_of(fp.initial_y, fp.initial_time)
						if stop_at[x] <= fp_y then
								dead_fps += 1
								fp.dead = true
						end
				end
		end
		if 0 < dead_fps then
				local new_fps = {}
				for x=1,board_width do
						new_fps[x] = {}
						for i=1,#falling_pieces[x] do
								if falling_pieces[x][i].dead then
										-- re-add to board
										for j=1,board_height do
												local y = board_height+1-j
												
												if board[x][y] == 0 then
														board[x][y] = falling_pieces[x][i].id
														break
												end
										end
								else
										new_fps[x][#new_fps[x]+1] = falling_pieces[x][i]
								end
						end
				end
				falling_pieces = new_fps
		end
end

function new_piece()
		-- lazy lol
		local p = 0
		while true do
				p = flr(rnd((#pieces)-.1))+1
				if pieces[p].typ == 2 then
						-- time piece
						if rnd(100) < 8 then
								break
						end
				else
						break
				end
		end
		return p
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
		if oldx != nil and oldy != nil and newx != nil and newy != nil then
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
		turns = 0
		
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
										--board = exchange_pieces(board, game_drag_cursor, game_cursor)
										local old_item = board[game_cursor[1]][game_cursor[2]]
										board[game_cursor[1]][game_cursor[2]] = board[game_drag_cursor[1]][game_drag_cursor[2]]
										board[game_drag_cursor[1]][game_drag_cursor[2]] = old_item
		
										turns += 1
										collect_matches(matches)
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

		-- clip hides new falling pieces
		clip(8,board_offset_v+8,12*board_width+4,board_offset_v+12*board_height-6)
		-- scrolling bg pattern
		--local pat = min(flr(st*5 % #bg_pattern_1)+1, 4)
		--fillp(bg_pattern_1[pat]+.1)
		rectfill(0,0,128,128,0)

		for x=1,#board do
				for y=1,#board[x] do
						local piece = board[x][y]
						
						local c = 0
						if x == game_cursor[1] and y == game_cursor[2] then
								c = 7
						end
						--print(piece, 100+x*4, 70+y*6, c)
						local inf = pieces[piece]
						
						if piece != 0 then
								spr(inf.s, x*12, board_offset_v+y*12)
						end
				end
		end

		for x=1,#falling_pieces do
				for i=1,#falling_pieces[x] do
						local inf = falling_pieces[x][i]

						local y = calc_y_of(inf.initial_y, inf.initial_time)
						if inf.dead then
								rectfill(inf.x*12, y, inf.x*12+8, y+8, 8)
						end
						spr(pieces[inf.id].s, inf.x*12, y)
				end
		end
		
		clip()
		
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
		spr(18, 80,56, 2,2)
		palt()
		pal()
		rect(79,55, 80+16,56+16, 14)
		
		-- cadey
		palt(0, false)
		pal(8,5)
		spr(24, 100,56, 2,2)
		palt()
		pal()
		rect(79+20,55, 80+36,56+16, 10)
		
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
		
		-- cpu usage
		print(stat(1),1,122,7)
		
		-- colour scheme
		local lsize = 4
		local l = 0
		for i=0,15 do
				l = flr(i/lsize)
				pset(i-l*lsize,l,i)
		end
		
		-- turns lol
		print(turns, 112,10, 7)
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
0098a98a98000000fff1111dffffffffaafcccc79a9ccffffffff551d0d55fff88188f8881888888000000000000000000000000000000000000000000000000
0a00000000a00000fff1111ddfffffffaaccccc77aac77ffff575551100511ff88888ff888888881006666666600000000000000000000000000000000000000
8000000000090000fff1111dd8211fffacccccc779aa77a9ff5555511d00110d8888affaaaafa8c8066666666660000000000000000000000000000000000000
9000000000080000ff11111d82111d1facccbbb7bb99777ffff5575155dd111f8aeeefeeeefffa8c066666666660000000000000000000000000000000000000
a0000000000a0000ff1111118211dddffccbbbbbbbbbb77fffff55555555511f8e22222222fffeca066666666660000000000000000000000000000000000000
8000000000090000ff111f77d77ddddffcbbbb777777b77fffff551511115115e288fffffffff2ce066666666660000000000000000000000000000000000000
9000000000080000ffffff07d07ddddffcbbbb077077777cfff555051011111588880ff0fffff282066666666660000000000000000000000000000000000000
a0000000000a0000ffffff07d07ddd1fccbbbb077077777cf55555011011111588880ff0ffff2e88066666666660000000000000000000000000000000000000
8000000000090000ffffddddddddd11fcbbb7777777c7ccc555511111111115588fffffffff2eea8066666666660000000000000000000000000000000000000
9000000000080000ffffddddded1d1ffbbbb7777777ccccb575511111111155f88ffffff2ff2eea8066666666660000000000000000000000000000000000000
0a00000000a00000fffffdddeedd11ffbbbb77766777ccbb5555111001111553888ffff22ff2eaa8006666666600000000000000000000000000000000000000
0089a89a89000000ffffffddddddd1f3bbbbd77777777cbb55555111111115338888fffffff2ea8f000000000000000000000000000000000000000000000000
000000000000000033ffff11dddd1133bbdddddd777799bb5f5555551111dd33188888fffff2e8ff000000000000000000000000000000000000000000000000
0000000000000000333ff88ddd1111dddddddddd7799aa9df355575511dd00d3888888fffff288ff000000000000000000000000000000000000000000000000
00000000000000003333222ddd111dddddddeee999aaa9dd3357555ddd000d3388818fffffffffff000000000000000000000000000000000000000000000000
00000000000000003333111ddd11dddddddeee92aaaa977e355555d70000d11381888fffffffffff000000000000000000000000000000000000000000000000
__label__
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000200000000000000000fffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000002200000000000000000fffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000e2200000007770000000fffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffff0ffff0fffffffffffffffffffffffffffffffff000022e200000007070000000fffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffff00ff00fffffffffffffffffffffffffffffffff0002e22200000007070000000fffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffff0000ffffffffffffffffffffffffffffffffff00022ee200000007070000000fffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff00fffffffffffffffffffffffffffffffffff0000222200000007770000000fffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000022000000000000000000fffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff9999999999999999999999999999999999999999999999999999999999999999ffff0000011000000000000000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff00001ff100000000000000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff0001fcff10000007770000000fffffffffffffffffffffffffff
ffffffff0000077077070000000000000000000000000000000000000000000000000000ffff0001ffcf10000007070000000fffffffffffffffffffffffffff
ffffffff0007000000007000000000000000000000000000000000000000000000000000ffff0001cfff10000007070000000fffffffffffffffffffffffffff
ffffffff0070099999900000003000000000099999900000000110000000000000000000ffff0001fcff10000007070000000fffffffffffffffffffffffffff
ffffffff000009000090070003b300000000090000900000001ff1000000000200f00000ffff00001ff100000007770000000fffffffffffffffffffffffffff
ffffffff007000900900070000300030000000900900000001fcff10000000020ff00000ffff0000011000000000000000000fffffffffffffffffffffffffff
ffffffff0070000990000000000003b3000000099000000001ffcf10000000ff277f0000ffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff000000099000070000000030000000099000000001cfff1000000f772ff00000ffff0000300000000000000000000fffffffffffffffffffffffffff
ffffffff007000900900070000030000000000900900000001fcff1000000f7f00000000ffff0003b30000000000000000000fffffffffffffffffffffffffff
ffffffff007009aaaa900000003b3000000009aaaa900000001ff100000000f000000000ffff0000300030000007770000000fffffffffffffffffffffffffff
ffffffff0000099999900700000300000000099999900000000110000000000000000000ffff00000003b3000007070000000fffffffffffffffffffffffffff
ffffffff0007000000007000000000000000000000000000000000000000000000000000ffff0000000030000007070000000fffffffffffffffffffffffffff
ffffffff0000707707700000000000000000000000000000000000000000000000000000ffff0000030000000007070000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff00003b3000000007770000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff0000030000000000000000000fffffffffffffffffffffffffff
ffffffff0000000002000000003000000000000000000000000110000000000002000000ffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff000000002200000003b300000000000200f00000001ff1000000000022000000ffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff0000000e2200000000300030000000020ff0000001fcff100000000e22000000ffff00000200f0000000000000000fffffffffffffffffffffffffff
ffffffff00000022e2000000000003b3000000ff277f000001ffcf1000000022e2000000ffff0000020ff0000007770000000fffffffffffffffffffffffffff
ffffffff000002e2220000000000003000000f772ff0000001cfff10000002e222000000ffff0000ff277f000007070000000fffffffffffffffffffffffffff
ffffffff0000022ee20000000003000000000f7f0000000001fcff100000022ee2000000ffff000f772ff0000007070000000fffffffffffffffffffffffffff
ffffffff0000002222000000003b3000000000f000000000001ff1000000002222000000ffff000f7f0000000007070000000fffffffffffffffffffffffffff
ffffffff0000000220000000000300000000000000000000000110000000000220000000ffff0000f00000000007770000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff0009999990000000000000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffff0009000090000000000000000fffffffffffffffffffffffffff
ffffffff0000000002000000000110000000000000000000000002000000000000000000ffff0000900900000007770000000fffffffffffffffffffffffffff
ffffffff0000000022000000001ff1000000000200f00000000022000000000200f00000ffff0000099000000007070000000fffffffffffffffffffffffffff
ffffffff0000000e2200000001fcff10000000020ff00000000e2200000000020ff00000ffff0000099000000007070000000fffffffffffffffffffffffffff
ffffffff00000022e200000001ffcf10000000ff277f00000022e200000000ff277f0000ffff0000900900000007070000000fffffffffffffffffffffffffff
ffffffff000002e22200000001cfff1000000f772ff0000002e2220000000f772ff00000ffff0009aaaa90000007770000000fffffffffffffffffffffffffff
ffffffff0000022ee200000001fcff1000000f7f00000000022ee20000000f7f00000000ffff0009999990000000000000000fffffffffffffffffffffffffff
ffffffff0000002222000000001ff100000000f00000000000222200000000f000000000ffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff0000000220000000000110000000000000000000000220000000000000000000ffff0000000000000000000000000fffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffffddddddddddddddddddfffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffffdccc1111dccccccccdfffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffffdccc1111ddcccddccdfffffffffffffffffffffffffffffff
ffffffff0000003000000000099999900000000110000000003000000000003000000000fffffffdccc1111dd821ddccdfffffffffffffffffffffffffffffff
ffffffff000003b300000000090000900000001ff100000003b30000000003b300000000fffffffdcc11111d8211dddcdfffffffffffffffffffffffffffffff
ffffffff000000300030000000900900000001fcff100000003000300000003000300000fffffffdcc11111182111ddcdfffffffffffffffffffffffffffffff
ffffffff0000000003b3000000099000000001ffcf100000000003b30000000003b30000fffffffdcc111c77d77d1ddcdfffffffffffffffffffffffffffffff
ffffffff000000000030000000099000000001cfff100000000000300000000000300000fffffffdcccccc07d07ddddcdfffffffffffffffffffffffffffffff
ffffffff000000030000000000900900000001fcff100000000300000000000300000000fffffffdcccccc07d07ddddcdfffffffffffffffffffffffffffffff
ffffffff0000003b3000000009aaaa900000001ff1000000003b30000000003b30000000fffffffdccccddddddddd1ccdfffffffffffffffffffffffffffffff
ffffffff0000000300000000099999900000000110000000000300000000000300000000fffffffdccccddddded1d1ccdfffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffffdcccccdddeedd11ccdfffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffffdccccccddddddd1ccdfffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffffdcccccc11dddd11ccdfffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffffdccccc88ddd1111ccdfffffffffffffffffffffffffffffff
ffffffff0000000002000000000110000000000000000000000002000000003000000000fffffffdcccc222ddd111cccdfffffffffffffffffffffffffffffff
ffffffff0000000022000000001ff1000000000200f0000000002200000003b300000000fffffffdcccc111ddd11dcccdfffffffffffffffffffffffffffffff
ffffffff0000000e2200000001fcff10000000020ff00000000e22000000003000300000fffffffddddddddddddddddddfffffffffffffffffffffffffffffff
ffffffff00000022e200000001ffcf10000000ff277f00000022e2000000000003b30000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff000002e22200000001cfff1000000f772ff0000002e222000000000000300000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000022ee200000001fcff1000000f7f00000000022ee2000000000300000000fffffff777777777777777777fffffffffffffffffffffffffffffff
ffffffff0000002222000000001ff100000000f000000000002222000000003b30000000fffffff7111cccc79a9cc1117fffffffffffffffffffffffffffffff
ffffffff0000000220000000000110000000000000000000000220000000000300000000fffffff711ccccc77aac77117fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff71cccccc779aa77a97fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff71cccbbb7bb9977717fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff71ccbbbbbbbbbb7717fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff71cbbbb777777b7717fffffffffffffffffffffffffffffff
ffffffff0000003000000000099999900000000000000000099999900000000110000000fffffff71cbbbb077077777c7fffffffffffffffffffffffffffffff
ffffffff000003b300000000090000900000000200f00000090000900000001ff1000000fffffff7ccbbbb077077777c7fffffffffffffffffffffffffffffff
ffffffff000000300030000000900900000000020ff0000000900900000001fcff100000fffffff7cbbb7777777c7ccc7fffffffffffffffffffffffffffffff
ffffffff0000000003b3000000099000000000ff277f000000099000000001ffcf100000fffffff7bbbb7777777ccccb7fffffffffffffffffffffffffffffff
ffffffff00000000003000000009900000000f772ff0000000099000000001cfff100000fffffff7bbbb77766777ccbb7fffffffffffffffffffffffffffffff
ffffffff00000003000000000090090000000f7f0000000000900900000001fcff100000fffffff7bbbbd77777777cbb7fffffffffffffffffffffffffffffff
ffffffff0000003b3000000009aaaa90000000f00000000009aaaa900000001ff1000000fffffff7bbdddddd777799bb7fffffffffffffffffffffffffffffff
ffffffff0000000300000000099999900000000000000000099999900000000110000000fffffff7dddddddd7799aa9d7fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff7ddddeee999aaa9dd7fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff7dddeee92aaaa977e7fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff777777777777777777fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000110000000099999900000000110000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000000200f00000000200f00000001ff1000000090000900000001ff1000000fffffff111111111111111111fffffffffffffffffffffffffffffff
ffffffff000000020ff0000000020ff0000001fcff10000000900900000001fcff100000fffffff1cccccff1d0dffccc1fffffffffffffffffffffffffffffff
ffffffff000000ff277f000000ff277f000001ffcf10000000099000000001ffcf100000fffffff1ccf7fff1100f11cc1fffffffffffffffffffffffffffffff
ffffffff00000f772ff000000f772ff0000001cfff10000000099000000001cfff100000fffffff1ccfffff11d00110d1fffffffffffffffffffffffffffffff
ffffffff00000f7f000000000f7f0000000001fcff10000000900900000001fcff100000fffffff1cccff7f1ffdd111c1fffffffffffffffffffffffffffffff
ffffffff000000f00000000000f000000000001ff100000009aaaa900000001ff1000000fffffff1ccccfffffffff11c1fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000110000000099999900000000110000000fffffff1ccccff1f1111f11f1fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff1cccfff0f1011111f1fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff1cfffff011011111f1fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff1ffff1111111111ff1fffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000fffffff1f7ff111111111ffc1fffffffffffffffffffffffffffffff
ffffffff0000000002000000000110000000099999900000000002000000000000000000fffffff1ffff111001111ffc1fffffffffffffffffffffffffffffff
ffffffff0000000022000000001ff1000000090000900000000022000000000200f00000fffffff1fffff11111111fcc1fffffffffffffffffffffffffffffff
ffffffff0000000e2200000001fcff100000009009000000000e2200000000020ff00000fffffff1fcffffff1111ddcc1fffffffffffffffffffffffffffffff
ffffffff00000022e200000001ffcf1000000009900000000022e200000000ff277f0000fffffff1ccfff7ff11dd00dc1fffffffffffffffffffffffffffffff
ffffffff000002e22200000001cfff10000000099000000002e2220000000f772ff00000fffffff1ccf7fffddd000dcc1fffffffffffffffffffffffffffffff
ffffffff0000022ee200000001fcff100000009009000000022ee20000000f7f00000000fffffff1cfffffd70000d11c1fffffffffffffffffffffffffffffff
ffffffff0000002222000000001ff100000009aaaa90000000222200000000f000000000fffffff111111111111111111fffffffffffffffffffffffffffffff
ffffffff0000000220000000000110000000099999900000000220000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffff9999999999999999999999999999999999999999999999999999999999999999ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
f777fffff777f777f777ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
f7f7fffff7f7f7fffff7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
f7f7fffff7f7f777f777ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
f7f7fffff7f7fff7f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
f777ff7ff777f777f777ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

