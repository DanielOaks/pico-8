pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- mai breakout
-- pixienop 2019
-- cc0 / public domain~

-- start menu stuff
start_menu_x = 40
start_menu_y = 70
start_menu_lheight = 10
start_menu_choice = 1
start_menu_entries = {}
start_menu_entries[1] = {}
start_menu_entries[1].name = "1p start"
start_menu_entries[1].state = "1p-lvl1"
start_menu_entries[2] = {}
start_menu_entries[2].name = "other option"
start_menu_entries[2].state = "otherstate"
sm_transfer = false

-- state handling
state = "introwait"
next_state = "pixienop"
continue_state = 0
state_updated_this_pattern = true
state_just_entered = true
state_start_time = 0
show_debug = false

function stime()
		return time() - state_start_time
end

-- the doing
function _init()
		music(0)
end

function _update()
		-- automagic state updating
		if stat(20) < 5 then
				if not state_updated_this_pattern then
						state_updated_this_pattern = true
						
						if next_state != "" then
								if 0 < continue_state then
										continue_state -= 1
								else
										state = next_state
										state_just_entered = true
										next_state = ""
										state_start_time = time()
								end
						end
				end
		else
				state_updated_this_pattern = false
		end
		
		-- start menu
		if state == "menu" then
				if btnp(⬇️) then
						start_menu_choice += 1
						sfx(1)
				end
				if btnp(⬆️) then
						start_menu_choice -= 1
						sfx(0)
				end
				if start_menu_choice < 1 then
						start_menu_choice = #start_menu_entries
				elseif #start_menu_entries < start_menu_choice then
						start_menu_choice = 1
				end
				
				if btnp(🅾️) or btnp(❎) then
						state = start_menu_entries[start_menu_choice].state
						sm_transfer = true
						state_just_entered = true
				end
		end
end

function _draw()
		pat = stat(20)
		st = stime()

		-- pnop logo
		if state == "pixienop" then
				if state_just_entered then
						next_state = "menu"
						state_just_entered = false
				end
				cls()
				pnop_x = 28
    pnop_y = 42
    pnop_width = 9
    pnop_height = 5
    if 27 < pat then
    		pal(10, 0)
    end
    if pat < 6 or 26 < pat then
    		pal(9, 0)
    end
    if pat < 12 or 25 < pat then
    		pal(8, 0)
    end
				spr(176, pnop_x, pnop_y, pnop_width, pnop_height)
				pal()
		end
		
		-- start menu
		if state == "menu" then
				if state_just_entered then
						start_menu_choice = 1
						state_just_entered = false
				end
				
				cls(2)
				for i = 1, #start_menu_entries do
						y = start_menu_y+start_menu_lheight*(i-1)
				
						if start_menu_choice == i then
								circfill(start_menu_x-7, y+3, 2, 1)
								circfill(start_menu_x-7, y+2, 2, 7)
						end
				
						color(1)
						print(start_menu_entries[i].name, start_menu_x, y+1)
						color(7)
						print(start_menu_entries[i].name, start_menu_x, y)
				end
				
				-- intro cover
				if st < 10 then
  				color(0)
  				rectfill(min(st*320, 128), 0, 128, 127)
  		end
		end
		
		-- lvl 1
		if state == "1p-lvl1" then
				if state_just_entered then
						state_just_entered = false
				end
				
				cls(12)
				
				padl_w = 25
				padl_h = 3

				x = ((cos(st*0.8)*sin(st*0.4))+1)*0.5
				padl_x = x * 128 - padl_w * x
				padl_y = 110
				rectfill(padl_x, padl_y, padl_x+padl_w, padl_y+padl_h, 7)
		end

		-- print debug info
		if show_debug then
  		-- print scene time lol
  		color(1)
  		rectfill(103, 0, 128, 18)
  		rectfill(0, 0, 40, 18)
  		
  		color(14)
  		print("s:"..state, 104, 1)
  		print(st, 104, 1+6)
  		print("c:"..continue_state, 104, 1+12)

  		color(7)
  		print("cpu:" .. stat(1), 1, 1)
  		print("    " .. stat(2), 1, 1+6)
  		print("fps:" .. stat(7) .. "/" .. stat(8), 1, 1+6+6)
		end
end

__gfx__
00000000000000000000000000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007700007777770000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000
00000000000770000077770077777777000000000000000000000000000000000000000000000000000700000007070000000000000000000000000000000000
00077000007777000777777077777777000000000000000000000000000000000000000000070000007070000077700000000000000000000000000000000000
00077000007777000777777077777777000000000000000000000000000000000000000000000000000700000707000000000000000000000000000000000000
00000000000770000077770077777777000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000
00000000000000000007700007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000a00000000000aa00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000aa0000000000a000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000a0000000000a000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aaaaaa000000000000000000000000a0000000000a000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aa000000a00000000000000000000000aa000000000a000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000a000000000000000000000000a000000000a000000000000000000000000000000000000000000000000000000000000000000000000000
0000000a000000000a000000000000000000000000aa0000000aa000000000000000000000000000000000000000000000000000000000000000000000000000
000000a0000000000a000008808800000000000000aa0000000a0000000000000000000000000000000000000000000000000000000000000000000000000000
00000a00000000000a000080080080000000000000a0a000000a0000000000000000000000000000000000000000000000000000000000000000000000000000
0000a000000000000a000080000080000000000000a0a000000a0000000000000000000000000000000000000000000000000000000000000000000000000000
0000a000000000000a000080000080000000000000a00a00000a0000000000000000000000000000000000000000000000000000000000000000000000000000
000a0a0000000000a0000008000080000000000000a00a00000a0000000000000000000000000000000000000000000000000000000000000000000000000000
00a000a000000000a0000000800080000000000000a000a0000a0000000000000000000000000000000000000000000000000000000000000000000000000000
00a0000a00000000a0000000080800000000000000aa00a0000a00000000000000aa000000000000000000000000000000000000000000000000000000000000
000a000a0000000a000000000080000000000000000900a0000a00000a000000aa0aa00000000000000000000000000000000000000000000000000000000000
00000000a00000a00000000000000000000a00000009000900aa0000a0a000aa00000a0000000000000000000000000000000000000000000000000000000000
00000000900000a000000000000000000aa0a00000090009009a000a000a00a000000aa000000000000000000000000000000000000000000000000000000000
000000000900090000000000000000000a00a000000900009099000a000aa0a0000000a000000000000000000000000000000000000000000000000000000000
00000000090090000000000000000000a00a0000000900009099000a0000a00a00000aa000000000000000000000000000000000000000000000000000000000
00000000009900000000000a000a000aa00a000000090000909900090000a00a00000a0000000000000000000000000000000000000000000000000000000000
0000000000990000a000a00a000a000a0090000000090000999900900000a00a0000aa0000000000000000000000000000000000000000000000000000000000
0000000009900000a000a0a0000a00090900000000090000099000900009900a000aa00000000000000000000000000000000000000000000000000000000000
0000000000090000a0000aa0000990090000000800080000088000900009000a0aaa000000000000000000000000000000000000000000000000000000000000
00000000000900000a00099000009009000000800008000000800080000900099900000000000000000000000000000000000000000000000000000000000000
00000000000900000900099000009008000088000000000000800088008000090000000000000000000000000000000000000000000000000000000000000000
00000000000080000900090900009000888800000000000000800008880000090000000000000000000000000000000000000000000000000000000000000000
00000000000080000900090090008000000000000000000000800000000000080000000000000000000000000000000000000000000000000000000000000000
00000000000080000800800099000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
00000000000008000080800008000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
00000000000008000080800000000000000000000aaa099908800888000000800000000000000000000000000000000000000000000000000000000000000000
0000000000000800000000000000000000000000000a090900800808000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000aaa090900800888000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000a00090900800008000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000aaa099908880888000008800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000001d26500500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001826500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000c1500c1500c1410c1400c1310c1301115011150111411114011131111301815018150181411814018131181301812118111181101811018101106010c6011060010630106210c6110c6110c6010c601
011000000005004140000300415000040041310005004140040300715004040071360405007140040300715002040051310205005140020300515602040051300505009140050310915005040091300505009140
01100000183231830018300000001c6051d3001d300000000c3230000000000000000000000000000000000018323000000000000000000000000000000000000c32300000000000000000000000000000000000
0110000018323183001a6031a6431a6031d3001a633000000c32300000000001a6431a6031d3001a633000001832300000000001a6431a6031d3001a633000000c32300000000001a6431a6031a6331a6231a613
01100000185651c5551f5451c545185651c5551f5451c545185651f5551c545185651f5551c545185651f5551a5651d555215651a5551d565215551a5651d5551a5651c5551f5451a5651d555215652955524575
0110000030552305423450134552345423555235542355323c5523b55239552375523555234552345523255230552305523054230532305323052230512007000070000700007000070000700007000070000700
011000003255232542345013455234542325523254232532375523755235552345523255232552305523255134552305523054230532305323052230512007000070000700007000070000700007000070000700
011000003055230542345013455234542355523554235532345523455235552355523255232552375523755235552345523254230532355323452232512305123051230512245010070000700007000070000700
__music__
00 08484344
00 09424344
01 0a0b4344
00 0a0b4344
00 0a0c0d44
00 0a0c0d0e
00 0a0c0d0e
00 0a0c0d0f
02 0a0c0d10

