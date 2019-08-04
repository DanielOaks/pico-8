pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- l-g-bee-t +
-- made by pixienop 2019~
-- for the squiggly river pride jam~

version = 1.1

-- game state
state_tag = 0
state_title = 1
state_game = 2
state_flag_select = 3
state_squiggly = 4
state_score = 5
state_highscores = 6

state = state_tag

-- init
function _init()
		-- start!
		music(0)

		-- custom menu items
		menuitem(1, "main menu", menu_mainmenu)

		-- custom init functions
		init_flag_select()
		
		-- init score junk
		cartdata("pixienop_lgbeet_1")
		load_high_scores()
		sort_high_score_table()
		save_high_scores()
end

-- update
function _update()
		if state == state_tag then
				update_tag()
		elseif state == state_title then
				update_title()
		elseif state == state_game then
				update_game()
		elseif state == state_flag_select then
				update_flag_select()
		elseif state == state_squiggly then
				update_squiggly()
		elseif state == state_score then
				update_score()
		elseif state == state_highscores then
				update_highscores()
		end
end

-- draw
function _draw()
		if state == state_tag then
				draw_tag()
		elseif state == state_title then
				draw_title()
		elseif state == state_game then
				draw_game()
		elseif state == state_flag_select then
				draw_flag_select()
		elseif state == state_squiggly then
				draw_squiggly()
		elseif state == state_score then
				draw_score()
		elseif state == state_highscores then
				draw_highscores()
		end
end

-- menu items
function menu_mainmenu()
		state = state_title
		transitioning_out = false
		transitioning_in = true
		stars = {}
		_st_time = t()
end

function menu_flag_select()
		--todo: save state, then
		-- reload it when exiting
		state = state_flag_select
		transitioning_out = false
		transitioning_in = true
		_st_time = t()
		
		-- setup flag select page
		selected_flag = 1
		fs_flag_selected = true
		fs_left_selected = false
		fs_right_selected = false
end

function menu_squiggly()
		--todo: save state, then
		-- reload it when exiting
		state = state_squiggly
		transitioning_out = false
		transitioning_in = true
		_st_time = t()
end

function menu_score()
		--todo: save state, then
		-- reload it when exiting
		editing_initial = 1
		state = state_score
		transitioning_out = false
		transitioning_in = false
		_st_time = t()
end

function menu_highscores()
		--todo: save state, then
		-- reload it when exiting
		state = state_highscores
		transitioning_out = false
		transitioning_in = false
		_st_time = t()
end

-->8
-- shared data and functions

-- scene time
_st_time = 0

function current_st()
		return max(t() - _st_time, 0)
end

-- bee rings
beecols = {12,10,11,8,14,2}

-- bg
stars = {}
star_colours = {
	 7, 7, 6, 6, 5,
	 9, 10, 14, 13, 15,
}

-- game speeds
default_speed = 2
speed = 2
speeds = {
		0.2,
		0.8,
		1.3,
		2,
}

-- transitions
transitioning_in = true
transitioning_out = false
t_start = 0

function lstep(edge0, edge1, x)
		return (edge0 * (1-x)) + (edge1 * x)
end

-- basic bg drawing
function draw_bg(st, no_moon)
		-- bg
		cls(1)
		
		-- moon?
		if no_moon == true then
		else
				circfill(100,30,10,15)
				circfill(94,33,10,1)
		end
		
		-- stars
		while #stars < 20 do
	   local star = {}
	   star.x = 130 + flr(rnd() * 256)
	   star.y = flr(rnd() * 128)
	   star.colour = flr(rnd() * (#star_colours - 1)) + 1
	   star.big = 0.95 < rnd()
	   add(stars, star)
		end
		for i = 1, #stars, 1 do
				local star = stars[i]
				
				star.x -= 8 * smooth_speed
				if star.x < -5 then
			   star.x = 130 + flr(rnd() * 256)
			   star.y = flr(rnd() * 128)
			   star.colour = flr(rnd() * (#star_colours - 1)) + 1
			   star.big = 0.95 < rnd()
				end
				
				if star.big then
						circ(star.x, star.y, 1, star_colours[star.colour])
				else
						pset(star.x, star.y, star_colours[star.colour])
				end
		end
		
		-- sky
	 local skyy = 20
	 fillp(0b0101101001011010.1)
	 for x = 0, 127 do
	   local y = skyy + sin(st*0.2*smooth_speed+x*0.004)*4.8 + cos(st*0.023+x*0.03)*1.6
	   y += abs((x/127)-0.5) * 16
	   line(x, -1, x, y, 0xd)
	 end
	 fillp()
	
		-- ground
		local groundy = 110
	 fillp(0b0101101001011010)
		for x = 0, 127 do
				local y = groundy + sin(st*1.4*smooth_speed+x*.004)*7.8 + cos(st*1.4*smooth_speed+x*.012)*3.8
				y += sin(st*20.4*smooth_speed+x*.73)*.8
				line(x, y, x, 128, 0x42)
		end
		fillp()
end

-- draw a basic flag
function draw_flag(fx,fy,x,y)
		rect(x,y,x+32,y+19,5)
		palt(0, false)
		sspr(fx,fy,31,18,x+1,y+1)
		palt(0, true)
end

-- draw a wavy flag
function draw_wavy_flag_id(id, x,y, st, shadow)
		local f = flags[id]
		draw_wavy_flag(f['x'], f['y'], x,y, st, shadow)
end

function draw_wavy_flag(fx,fy,x,y, st, shadow)
		palt(0, false)
		for i = 0, 33 do
				local mod = sin(st-i*.03)*1.9
				if i == 33 then
						if shadow then
								line(x+i, y+mod+2, x+i, y+mod+20, 0)
						end
						break
				end
				pset(x+i, y+mod, 5)
				pset(x+i, y+mod+19, 5)
				if shadow and i != 0 then
						pset(x+i, y+mod+20, 0)
				end
				if i == 0 or i == 32 then
						line(x+i, y+mod+1, x+i, y+mod+19, 5)
				else
						sspr(fx+i-1,fy,1,18,x+i,y+1+mod)
				end
		end
		
		palt(0, true)
end

-->8
-- tag
function update_tag()
		if 3.9 < t() then
				state = state_title
				_st_time = t()
		end
		
		if btnp(❎) or btnp(🅾️) then
				state = state_title
				_st_time = t()
		end
end

function draw_tag()
		cls(7)
		
		local st = current_st()
		
		pal(10,7)
		pal(9,7)
		pal(8,7)
		
		if 0.6 < st and st < 3.73 then
				pal(10,8)
		end
		if 1.65 < st and st < 3.75 then
				pal(9,2)
		end
		if 2.7 < st and st < 3.77 then
				pal(8,1)
		end
		
		spr(176, 26, 42, 9, 5)
		
		pal()
end

-->8
-- title screen

title_item = 1
num_title_items = 6
old_item = 1

-- times!
time_selected = 2
time_desc = {
		"30 sec",
		"1 min",
		"2 min",
		"5 min",
}
time_secs = {
		30,
		60,
		120,
		60*5,
}

-- speed changing
smooth_speed = 1
speed_desc = {
		"1 - chill",
		"2 - balanced",
		"3 - intense",
		"4 - quite fast",
}

-- speed lerping
speed_start = 2
speed_end = 2
s_time = -50
s_duration = 0.4

function update_title()
		local cst = current_st()
		
		local sc = cst - s_time
		if sc < s_duration then
				local step = sc / s_duration
				smooth_speed = lstep(speed_start, speed_end, step)
		end
		
		if transitioning_in then
				if 0.7 < cst then
						transitioning_in = false
				end
				return
		end
		
		if transitioning_out then
				if 0.4 < cst - t_start then
						init_game()
						state = state_game
						transitioning_out = false
						transitioning_in = true
						_st_time = t()
				end
				return
		end
		
		if btnp(⬆️) then
				title_item = max(1, title_item-1)
		elseif btnp(⬇️) then
				title_item = min(num_title_items, title_item+1)
		end

		if btnp(➡️) and title_item == 2 then
				time_selected = min(time_selected+1, #time_desc)
		elseif btnp(⬅️) and title_item == 2 then
				time_selected = max(time_selected-1, 1)
		elseif btnp(➡️) and title_item == 3 then
				speed = min(speed+1, #speed_desc)
				sfx(6)
				
				if true then--speed != smooth_speed then
						speed_start = smooth_speed
						speed_end = speeds[speed]
						s_time = cst
				end
		elseif btnp(⬅️) and title_item == 3 then
				speed = max(speed-1, 1)
				sfx(7)
				
				if true then--speed != smooth_speed then
						speed_start = smooth_speed
						speed_end = speeds[speed]
						s_time = cst
				end
		elseif btnp(❎) or btnp(🅾️) then
				if title_item == 1 then
						transitioning_out = true
						t_start = cst
				elseif title_item == 4 then
						menu_flag_select()
				elseif title_item == 5 then
						menu_highscores()
				elseif title_item == 6 then
						menu_squiggly()
				end
		end
end

function draw_title()
		local st = current_st()
		
		draw_bg(st)

		-- version
		print('v'..version, 108,1, 7)
		
		-- draw wiggly title
		local titletext = "l-g-bee-t +"
		local titlecols = {8,9,10,11,12,14}
		
  col_index = -flr(st*6)  -- which colour from the pattern to draw
  while col_index <= 0 do
  		col_index += #titlecols
  end
  for i = 1, #titletext, 1 do       -- loop through every letter
    letter = sub(titletext, i, i)   -- grab this letter
    this_st = st - (0.1* i)       -- create a modified time for this letter
    base_x = 10
    print(letter, base_x + i*4, 42 + sin(this_st*2)*.9, titlecols[col_index])  -- draw this letter
    
    -- only go to the next colour
    -- for actual letters, ignore
    -- spaces!
    if letter != " " then
      col_index += 1 -- next colour
      if #titlecols < col_index then
        -- if we're at the end,
        -- go back to the first
        -- colour in our pattern
        col_index = 1
      end
    end
  end
		
		-- draw bee
		local s = 12
		if (0 < sin(st*4.9*smooth_speed)) then
				s = 14
		end
		
		-- bee 1
		pal(1,0)
		for i = 1, #beecols do
				pal(beecols[i], i+5+flr(st*10*smooth_speed))
		end
		spr(s, 50+cos(st*.1*smooth_speed)*30+cos(st*.34)*10, 50+sin(st*.3*smooth_speed)*40.9, 2, 2)
		pal()

		-- bee 2
		pal(1,0)
		for i = 1, #beecols do
				if (i + flr(st*5*smooth_speed)) % 2 == 0 then
						pal(beecols[i], 0)
				else
						pal(beecols[i], 10)
				end
		end
		spr(s, 50+cos(st*.1*smooth_speed+3.8)*34+cos(st*.34*smooth_speed+2.5)*7, 50+sin(st*.3*smooth_speed+2.66)*44.9, 2, 2)
		pal()
		
		-- instructions
		local mainx = 20
		local mainy = 55
		
		local x = mainx
		local y = mainy
		local txt = "play"
		if title_item == 1 then
				x += sin(st)*2.9
				y += cos(st)*.9
		end
		print(txt, x,y+1, 0)
		print(txt, x,y, 7)
		
		mainy += 10
		x = mainx
		y = mainy
		txt = "time"
		if title_item == 2 then
				x += sin(st)*2.9
				y += cos(st)*.9
				txt = txt.." ⬅️➡️"
		end
		print(txt, x,y+1, 0)
		print(txt, x,y, 7)
		print(time_desc[time_selected], x+6,y+8, 1)
		print(time_desc[time_selected], x+6,y+7, 7)
		
		mainy += 17
		x = mainx
		y = mainy
		txt = "speed"
		if title_item == 3 then
				x += sin(st)*2.9
				y += cos(st)*.9
				txt = txt.." ⬅️➡️"
		end
		print(txt, x,y+1, 0)
		print(txt, x,y, 7)
		print(speed_desc[speed], x+6,y+8, 1)
		print(speed_desc[speed], x+6,y+7, 7)
		
		mainy += 17
		x = mainx
		y = mainy
		txt = "flags"
		if title_item == 4 then
				x += sin(st)*2.9
				y += cos(st)*.9
		end
		print(txt, x,y+1, 0)
		print(txt, x,y, 7)
		
		mainy += 8
		x = mainx
		y = mainy
		txt = "scores"
		if title_item == 5 then
				x += sin(st)*2.9
				y += cos(st)*.9
		end
		print(txt, x,y+1, 0)
		print(txt, x,y, 7)
		
		mainx += 40
		mainy += 2
		x = mainx
		y = mainy
		txt = "about squiggly"
		if title_item == 6 then
				x += sin(st)*2.9
				y += cos(st)*.9
		end
		print(txt, x,y+1, 0)
		print(txt, x,y, 7)
		
		-- squiggly river mention~
		local a = "               pride jam"
		local b = "squiggly river"
		for x = -1, 1 do
				for y = -1, 1 do
						print(a, 17+x, 121+y, 0)
						print(b, 17+x, 121+y, 0)
				end
		end
		print(a, 17, 121, 7)
		print(b, 17, 121, 8)
		line(16,127,128-16,127,3)
		
		-- transition in from tag
		if transitioning_in then
				for i = 0, 127 do
						line(i, st*500*(st*0.88)+sin(i*0.02+st*3)*5.8-10, i, 128, 7)
				end
		end
		
		-- transition out
		if transitioning_out then
				for i = 0, 127 do
						line(i, 140-(st-t_start)*300*(st*0.88)+sin(i*0.02+st*3)*5.8, i, 128, 7)
				end
		end
end
-->8
-- game

bx = 20
by = 60
ppos = {
		x=20,
		y=60,
}

same_maps = {
		{5,}, -- 0
		{12,}, -- 1
		{},	-- 2
		{11,},	-- 3
		{}, -- 4
		{0,}, -- 5
		{}, -- 6
		{}, -- 7
		{}, -- 8
		{}, -- 9
		{}, -- 10
		{3,}, -- 11
		{1,}, -- 12
		{}, -- 13
		{}, -- 14
		{}, -- 15
}

gpoints = 0
collected_flags = {}

-- blobs flying in
blobs = {}

-- flags that're queued up
gflags = {}

-- cols that have been collected
-- for this current flag
collectedcols = {}

function init_game()
		gpoints = 0
		collected_flags = {}
		gflags = {}
		collectedcols = {}
		blobs = {}
		
		smooth_speed = speeds[speed]
end

function update_game()
		local st = current_st()
		
		-- check time
		local ttt = flr(time_secs[time_selected]-st)
		if ttt <= 0.1 then
				--todo:work out whether
				-- to show score initials
		
				menu_score()
		end
		
		-- populate blobs
		if 1.5 < st then
				local i = 1
				while i <= #blobs do
						if blobs[i].ded == true then
								del(blobs, blobs[i])
						else
								i += 1
						end
				end		
				while #blobs < 10 do
						local b = {}
						b.x = flr(rnd(570*smooth_speed))+140
						b.y = flr(rnd(94))+1
						b.c = mid(flr(rnd(16)),0,15)
						--todo: check collision
						-- with existing blobs lol
						add(blobs, b)
				end
				local px = ppos.x + 8 -- bee width/2
				local py = ppos.y + 6 -- bee height/2
				for i = 1, #blobs do
						blobs[i].x -= 4.4 * smooth_speed
						if blobs[i].x <= -10 then
								blobs[i].ded = true
						else
								-- check collision w/ bee
								local blobx = blobs[i].x+4
								local bloby = blobs[i].y+4
								local distx = abs(blobx-px)
								local disty = abs(bloby-py)
								if distx <= 8 and disty <= 6 then
										-- hit!
										blobs[i].ded = true
										local c = blobs[i].c
										local hit_good = false
										for i = 0, #flags[gflags[1]].cols do
												if c == flags[gflags[1]].cols[i] then
														hit_good = true
														break
												end
										end
										if hit_good then
												del(collectedcols, c) -- don't dupe
												add(collectedcols, c)
												gpoints += 1
												sfx(5)
										else
												gpoints -= 1
												sfx(4)
										end
								end
						end
				end
		end
		
		-- reset flag if asked
		if btnp(🅾️) or btnp(❎) then
				local px = ppos.x + 8 -- bee width/2
				local py = ppos.y + 6 -- bee height/2
				if 100 < px and 80 < py then
						del(gflags, gflags[1])
						collectedcols = {}
						sfx(3)
				end
		end
		
		-- populate gflags
		if 0 < #gflags and #collectedcols == #flags[gflags[1]].cols then
				add(collected_flags, gflags[1])
		
				del(gflags, gflags[1])
				collectedcols = {}
				sfx(3)
		end
		while #gflags < 2 do
				local f = flr(rnd(#flags))+1
				local add_it = true
				-- check already exists
				for i = 1, #gflags do
						if gflags[i] == f then
								do_it = false
								break
						end
				end
				-- check enabled
				if flags[f]['enabled'] == false then
						add_it = false
				end
				
				if add_it then
						add(gflags, f)
				end
		end
		
		if transitioning_in then
				if 0.7 < st then
						transitioning_in = false
				end
				return
		end
		
		-- movement
		local bspeed = 7
		if btn(⬆️) then
				by -= bspeed * smooth_speed
		end
		if btn(⬇️) then
				by += bspeed * smooth_speed
		end
		if btn(⬅️) then
				bx -= bspeed * smooth_speed
		end
		if btn(➡️) then
				bx += bspeed * smooth_speed
		end
		by = mid(0, by, 128-12-30)
		bx = mid(0, bx, 128-12)
end

function draw_game()
		local st = current_st()

		draw_bg(st)
		
		spr(220, 104,84, 3,2)
		
		-- draw bee
		local s = 12
		if (0 < sin(st*4.9*smooth_speed)) then
				s = 14
		end
		
		-- bee 1
		pal(1,0)
		for i = 1, #beecols do
				pal(beecols[i], i+5+flr(st*10*smooth_speed))
		end
		ppos.x = bx+cos(st*.1*smooth_speed)*1.8+cos(st*.34)*1.9
		ppos.y = by+sin(st*.3*smooth_speed)*2.9
		spr(s, ppos.x, ppos.y, 2, 2)
		pal()
		
		if 0 < #blobs then
				for i = 1, #blobs do
						local b = blobs[i]
						pal(6, b['c'])
						spr(24, b['x'],b['y'])
						pal()
				end
		end
		
		if 0 < #gflags then
				-- flags
				local x = 25
				local y = 102
				for i = 1, 1 do--min(2,#gflags) do
						draw_wavy_flag_id(gflags[i], x,y, st, true)
						x += 100
				end
				
				-- draw ref paint blobs
				local f = flags[gflags[1]]
				local cols = f['cols']
				x = 3
				y = 116
				for i = 1, #cols do
						local c = cols[#cols-i+1]
						
						-- see if already collected
						local collected = false
						if collectedcols then
								for j = 1, #collectedcols do
										if collectedcols[j] == c then
												collected = true
												break
										end
								end
						end
						-- draw it
						pal(5,0)
						pal(6,0)
						spr(24, x+1,y+1)
						pal()
						pal(6, c)
						if collected then
								pal(5,3)
						end
						spr(24, x,y)
						pal()
						if collected then
								spr(219,x,y)
						end
						x += 10
						if 20 < x then
								y -= 10
								x = 3
						end
				end
				
				print(f.name, 70,120, 1)
				print(f.name, 70,119, 9)
		end
		
		print("points", 70,101, 0)
		print("points", 70,100, 7)
		print(gpoints, 79,109, 1)
		print(gpoints, 79,108, 7)

		local ttt = flr(time_secs[time_selected]-st)
		print("time", 102,101, 0)
		print("time", 102,100, 7)
		print(ttt, 106,109, 1)
		print(ttt, 106,108, 7)
		
		-- transition in
		if transitioning_in then
				for i = 0, 127 do
						line(i, -1, i, 150 - st*450*(st*0.88)+sin(i*0.02+st*3)*5.8-10, 7)
				end
		end
end
-->8
-- flag select

selected_flag = 1

fs_flag_selected = true
fs_left_selected = false
fs_right_selected = false

flags = {
		{x=00,y=16,name='pride',cols={8,9,10,3,1,2}},
		{x=00,y=70,name='lesbian',cols={8,4,9,15,7,13,14,2},note="so much dither needed~ ░★"},
		{x=31,y=16,name='bi',cols={8,2,1}},
		{x=62,y=16,name='genderqueer',cols={2,7,3}},
		{x=00,y=34,name='trans',cols={12,7,14}},
		{x=31,y=34,name='pan',cols={8,10,12}},
		{x=62,y=34,name='genderfluid',cols={14,7,8,0,1}},
		{x=00,y=52,name='non-binary',cols={10,7,2,0}},
		{x=31,y=52,name='ace',cols={0,6,7,2}},
		{x=62,y=52,name='aromantic',cols={3,11,7,6,0}},
		{x=93,y=16,name='polysexual',cols={14,11,12}},
		{x=93,y=34,name='agender',cols={0,6,7,11}},
		{x=93,y=52,name='intersex',cols={10,2}},
}

flag_grid_width = 2
flag_grid_height = 3

function get_flagpage_pos()
		local pos_in_line = selected_flag
		local line_on = 1
		while flag_grid_width < pos_in_line do
				pos_in_line -= flag_grid_width
				line_on += 1
		end

		local page = 1
		while flag_grid_height < line_on do
				line_on -= flag_grid_height
				page += 1
		end
		
		return {
				page=page,
				line_on=line_on,
				pos_in_line=pos_in_line,
				pages=ceil(#flags/(flag_grid_width*flag_grid_height)),
				flags_per_page=flag_grid_height*flag_grid_width,
		}
end

function init_flag_select()
		for i = 1, #flags do
				local f = flags[i]
				
				f['enabled'] = true
		end
end

function update_flag_select()
		local pos = get_flagpage_pos()
		
		if btnp(❎) or btnp(🅾️) then
				if fs_flag_selected then
						flags[selected_flag]['enabled'] = not flags[selected_flag]['enabled']
				elseif fs_right_selected then
						selected_flag = pos.page * (flag_grid_width*flag_grid_height)+1
						fs_right_selected = false
						fs_flag_selected = true
				elseif fs_left_selected and 1 < pos.page then
						selected_flag = max(1, (pos.page-2) * (flag_grid_width*flag_grid_height)+1)
						fs_left_selected = false
						fs_flag_selected = true
				elseif fs_left_selected then
						-- todo: restore state
						state = state_title
				end
		end

		if btnp(➡️) then
				if fs_left_selected then
						fs_left_selected = false
						fs_flag_selected = true
				elseif pos.pos_in_line < flag_grid_width and selected_flag+1 <= #flags then
				  selected_flag += 1
				elseif pos.page < pos.pages then
						fs_flag_selected = false
						fs_right_selected = true
				end
		elseif btnp(⬅️) then
				if fs_right_selected then
						fs_right_selected = false
						fs_flag_selected = true
				elseif 1 < pos.pos_in_line then
				  selected_flag -= 1
				else
						fs_flag_selected = false
						fs_left_selected = true
				end
		end
		
		if btnp(⬇️) then
				-- if should move to next line
				if fs_flag_selected and (pos.flags_per_page*(pos.page-1))+pos.line_on*flag_grid_width < #flags then
						-- which flag in that line to move to
						if selected_flag+flag_grid_width <= #flags then
								selected_flag += flag_grid_width
						else
								selected_flag = line_on*flag_grid_width+1
						end
				end
		elseif btnp(⬆️) then
				if fs_flag_selected and 0 < selected_flag-flag_grid_width then
						selected_flag -= flag_grid_width
				end
		end
end

function draw_flag_select()
		local st = current_st()

		draw_bg(st, true)
		
		rectfill(0,2,127,12,13)
		print('choose flags', 39,5, 7)
		
		local bx = 26
		local by = 18
		local pos = get_flagpage_pos()
		for i = 1+(pos.page-1)*(flag_grid_height*flag_grid_width), #flags do
				local f = flags[i]
				
				if i == selected_flag and fs_flag_selected then
						draw_wavy_flag(f.x, f.y, bx, by, st, true)
				else
						draw_flag(f.x, f.y, bx, by)
				end
				if f['enabled'] then
						spr(10,bx+12,by+17)
				else
						-- no cross no bad
						--spr(9,bx+12,by+17)
				end
				
				if i == selected_flag and fs_flag_selected then
						print(f['name'].." flag", 20,111, 7)
						if f['note'] then
								print(f['note'], 10,118, 7)
						end
						
						-- draw colours
						if false then--f['cols'] then
								line(0,126,#f['cols'],126,0)
								local j = 1
								while j <= #f['cols'] do
										pset(j-1,127,f['cols'][j])
										j += 1
								end
								pset(j-1,127,0)
						end
				end
				
				if true then
						local left_y = 56
						if fs_left_selected then
								left_y += sin(st*.8)*2.8
						end
						spr(11, 9,left_y, 1,1, true)
				end
				
				if pos.page < pos.pages then
						local right_y = 56
						if fs_right_selected then
								right_y += sin(st*.8)*2.8
						end
						spr(11, 128-17,right_y)
				end
				
				bx += 42
				if 80 < bx then
						bx = 26
						by += 31
				end
				
				if 100 < by then
						break
				end
		end

		if fs_left_selected and 1 < pos.page then
				print("previous page", 20,111, 7)
		elseif fs_left_selected then
				print("back", 20,111, 7)
		end

		if fs_right_selected then
				print("next page", 20,111, 7)
		end
end

-->8
-- squiggly

function update_squiggly()
		local pos = get_flagpage_pos()
		
		if btnp(❎) or btnp(🅾️) then
				state = state_title
				_st = t()-5
				transitioning_in = false
				transitioning_out = false
		end
end

function draw_squiggly()
		local st = current_st()

		draw_bg(st)
		
		local x = 8
		local y = 40
		print("squiggly river", x,y, 14)
		print("               is", x,y, 7)
		y += 7
		print("a place for games,", x,y, 7)
		y += 7
		print("playful art things", x,y, 7)
		y += 7
		print("& those who make", x,y, 7)
		y += 7
		print("and play them!", x,y, 7)
		y += 16
		print("if you're ever down under,", x,y, 7)
		y += 7
		print("come to a meetup and say hi!", x,y, 7)
		
		draw_wavy_flag(31,70, 86,47, st, true)
end

-->8
-- score

alphabet = "abcdefghijklmnopqrstuvwxyz0123456789,./;'[]<>?:\"{}\\▥🐱ˇ▒♪😐█★✽●♥웃⌂…∧░⧗▤☉◆⬅️➡️⬆️⬇️🅾️❎"

initials = "aaa"
initials_nums = {1,1,1}
editing_initial = 1

high_scores = {}

function sort_high_score_table()
		local a = high_scores

  for i=1,#a do
      local j = i
      while j > 1 and a[j-1].points < a[j].points do
          a[j],a[j-1] = a[j-1],a[j]
          j = j - 1
      end
  end
  
  high_scores = a
end

function save_new_high_score()
		entry = {}
		entry.points = gpoints
		entry.initial_nums = initials_nums
		entry.initials = initials

		add(high_scores, entry)
		
		sort_high_score_table()
		save_high_scores()
end

function save_high_scores()
		local dset_i = 0
		if 0 < #high_scores then
				for i = 1, 10 do
						if #high_scores < i then
								break
						end
				
						local entry = high_scores[i]
						dset(dset_i, entry.initial_nums[1])
						dset_i += 1
						dset(dset_i, entry.initial_nums[2])
						dset_i += 1
						dset(dset_i, entry.initial_nums[3])
						dset_i += 1
						dset(dset_i, entry.points)
						dset_i += 1
				end
		end
		-- end marker
		dset(dset_i, 0)
		dset(dset_i+1, 0)
		dset(dset_i+2, 0)
		dset(dset_i+3, 0)
end

function load_high_scores()
		high_scores = {}

		local dget_i = 0
		for i = 1, 10 do
				local get1 = dget(dget_i)
				local get2 = dget(dget_i+1)
				local get3 = dget(dget_i+2)
				local get4 = dget(dget_i+3)
				dget_i += 4
				
				if get1 == 0 or get2 == 0 or get3 == 0 then
						break
				end
				
				local initials = ""
				initials = sub(alphabet,get1,get1)..sub(alphabet,get2,get2)..sub(alphabet,get3,get3)
				
				local entry = {}
				entry.points = get4
				entry.initials = initials
				entry.initial_nums = {get1,get2,get3}
				
				add(high_scores, entry)
		end
end

function update_score()
		local st = current_st()
		
		if (btnp(🅾️) or btnp(❎)) and editing_initial == 4 then
				save_new_high_score()
				menu_highscores()
		end
		
		if btnp(⬅️) then
				editing_initial = max(editing_initial-1, 1)
		elseif btnp(➡️) then
				editing_initial = min(editing_initial+1, 4)
		end
		
		local current_i = initials_nums[min(3,editing_initial)]
		if btnp(⬇️) then
				if editing_initial < 4 then
						current_i += 1
						if #alphabet < current_i then
								current_i = 1
						end
						initials_nums[editing_initial] = current_i
						
						initials = ""
						for i = 1, 3 do
								initials = initials..sub(alphabet,initials_nums[i],initials_nums[i])
						end
				end
		elseif btnp(⬆️) then
				if editing_initial < 4 then
						current_i -= 1
						if current_i < 1 then
								current_i = #alphabet
						end
						initials_nums[editing_initial] = current_i
				
						initials = ""
						for i = 1, 3 do
								initials = initials..sub(alphabet,initials_nums[i],initials_nums[i])
						end
				end
		end
end

function draw_score()
		local st = current_st()

		draw_bg(st)
		
		--print(initials, 56,50, 7)
		for i = 1, 3 do
				print(sub(initials,i,i), 37+i*13,50, 7)
		end
		if sin(st*2) < 0 then
			if editing_initial < 4 then
					spr(25, 37+editing_initial*13,57)
					spr(26, 37+editing_initial*13,46)
			elseif editing_initial == 4 then
					spr(27, 88,51)
			end
	end
		
		print("flags collected", 20,69, 7)
		print(#collected_flags, 90,69, 7)
		
		print("          score", 20,78, 7)
		print(gpoints, 90,78, 7)
end


-- highscores

function update_highscores()
		local st = current_st()
		
		if btnp(❎) or btnp(🅾️) then
				menu_mainmenu()
				transitioning_in = false
		end
end

function draw_highscores()
		local st = current_st()

		draw_bg(st)
		
		for i = 1, #high_scores do
				local entry = high_scores[i]
				print(entry.initials, 30, 30+i*7, 7)
				print(entry.points, 60, 30+i*7, 7)
		end
end
__gfx__
000000004ddd000000000000000000000000000088888880ccccccc0eeeeeee0888888880000000000000000000000004ddd0000000000000000000000000000
00000000dd66dd00000000d0dddd0000000000d088888880eeeeeee07777777099999999ee0000ee0000000b06660000dd66dd00000000d0dddd0000000000d0
0070070004d66d0000000d06d66dd00000000d06222222207777777022222220aaaaaaaa0ee00ee0000000bb0066600004d66d0000000d06d66dd00000000d06
0007700000d466da11a00d004d6d6dda11a00d0011111110eeeeeee0555555503333333300eeee0000000bb00006666000d466d8ee200d004d6d6dd8ee200d00
000770000000ddaa11ad60000040d6aa11ad600011111110ccccccc01111111011111111000ee000b000bb00000066660000dd88ee2d60000040d688ee2d6000
0070070001aa11aa11ad660001aa11aa11ad66000000000000000000000000002222222200eeee00bb0bb000000666600caabb88ee2d66000caabb88ee2d6600
0000000001aa11aa11add60001aa11aa11add60055555550aaaaaaa0eeeeeee0000000000ee00ee0bbbbb000006660000caabb88ee2dd6000caabb88ee2dd600
0000000011aa11aaa11add0011aa11aaa11add006666666077777770eeeeeee000000000ee0000ee0bbb000006660000ccaabb888ee2dd00ccaabb888ee2dd00
0000000011aaa11aa11a006011aaa11aa11a00607777777022222220aaaaaaa000555500606000000600000066606060ccaaabb88ee20060ccaaabb88ee20060
0000000011110110011a006011110110011a00602222222055555550ccccccc0056666500600000060600000606066001ccc0110000100601ccc011000010060
00000000100001000101000010000100010100002222222055555550ccccccc05666776500000000000000006660606010000100000100001000010000010000
00000000000001000001000000000100000100000000000000000000000000005666676500000000000000000000000000000100000100000000010000010000
00000000000000000000000000000000000000000000000000000000000000005666666500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005666666500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000566665000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000055550000000000000000000000000000000000000000000000000000000000
888888888888888888888888888888888888888888888888888888888888882222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000
888888888888888888888888888888888888888888888888888888888888882222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000
888888888888888888888888888888888888888888888888888888888888882222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000
999999999999999999999999999999988888888888888888888888888888882222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000
999999999999999999999999999999988888888888888888888888888888882222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000
999999999999999999999999999999988888888888888888888888888888882222222222222222222222222222222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa88888888888888888888888888888887777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa22222222222222222222222222222227777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa22222222222222222222222222222227777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
333333333333333333333333333333322222222222222222222222222222227777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
333333333333333333333333333333322222222222222222222222222222227777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
333333333333333333333333333333311111111111111111111111111111117777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
111111111111111111111111111111111111111111111111111111111111113333333333333333333333333333333ccccccccccccccccccccccccccccccc0000
111111111111111111111111111111111111111111111111111111111111113333333333333333333333333333333ccccccccccccccccccccccccccccccc0000
111111111111111111111111111111111111111111111111111111111111113333333333333333333333333333333ccccccccccccccccccccccccccccccc0000
222222222222222222222222222222211111111111111111111111111111113333333333333333333333333333333ccccccccccccccccccccccccccccccc0000
222222222222222222222222222222211111111111111111111111111111113333333333333333333333333333333ccccccccccccccccccccccccccccccc0000
222222222222222222222222222222211111111111111111111111111111113333333333333333333333333333333ccccccccccccccccccccccccccccccc0000
ccccccccccccccccccccccccccccccc8888888888888888888888888888888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000
ccccccccccccccccccccccccccccccc8888888888888888888888888888888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000
ccccccccccccccccccccccccccccccc8888888888888888888888888888888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee8888888888888888888888888888888777777777777777777777777777777766666666666666666666666666666660000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee8888888888888888888888888888888777777777777777777777777777777766666666666666666666666666666660000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee8888888888888888888888888888888777777777777777777777777777777766666666666666666666666666666660000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa777777777777777777777777777777777777777777777777777777777777770000
7777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e877777777777777777777777777777770000
7777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaae8e8e8e8e8e8e8e8e8e8e8e8e8e8e8ebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
7777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000
7777777777777777777777777777777aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaae8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e77777777777777777777777777777770000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa000000000000000000000000000000077777777777777777777777777777770000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeccccccccccccccccccccccccccccccc000000000000000000000000000000066666666666666666666666666666660000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeccccccccccccccccccccccccccccccc000000000000000000000000000000066666666666666666666666666666660000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeccccccccccccccccccccccccccccccc000000000000000000000000000000066666666666666666666666666666660000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111111111111111111111111111111100000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111111111111111111111111111111100000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc111111111111111111111111111111100000000000000000000000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00000000000000000000000000000003333333333333333333333333333333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00000000000000000000000000000003333333333333333333333333333333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00000000000000000000000000000003333333333333333333333333333333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaaaaaaaaaaa222aaaaaaaaaaaaaa0000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaaaaaaaaa2222222aaaaaaaaaaaa0000
77777777777777777777777777777776666666666666666666666666666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaaaaaaaa222aaa222aaaaaaaaaaa0000
77777777777777777777777777777776666666666666666666666666666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaaaaaaa222aaaaa222aaaaaaaaaa0000
777777777777777777777777777777766666666666666666666666666666667777777777777777777777777777777aaaaaaaaaa22aaaaaaa22aaaaaaaaaa0000
777777777777777777777777777777766666666666666666666666666666667777777777777777777777777777777aaaaaaaaaa22aaaaaaa22aaaaaaaaaa0000
222222222222222222222222222222277777777777777777777777777777777777777777777777777777777777777aaaaaaaaaa22aaaaaaa22aaaaaaaaaa0000
222222222222222222222222222222277777777777777777777777777777777777777777777777777777777777777aaaaaaaaaa22aaaaaaa22aaaaaaaaaa0000
222222222222222222222222222222277777777777777777777777777777776666666666666666666666666666666aaaaaaaaaa222aaaaa222aaaaaaaaaa0000
222222222222222222222222222222277777777777777777777777777777776666666666666666666666666666666aaaaaaaaaaa222aaa222aaaaaaaaaaa0000
000000000000000000000000000000022222222222222222222222222222226666666666666666666666666666666aaaaaaaaaaaa2222222aaaaaaaaaaaa0000
000000000000000000000000000000022222222222222222222222222222226666666666666666666666666666666aaaaaaaaaaaaaa222aaaaaaaaaaaaaa0000
000000000000000000000000000000022222222222222222222222222222220000000000000000000000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000
000000000000000000000000000000022222222222222222222222222222220000000000000000000000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000
000000000000000000000000000000022222222222222222222222222222220000000000000000000000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000
88988988988988988988988988988981111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000
94894894894894894894894894894891111111111111111cccc11111111111000000000000000000000000000000000000000000000000000000000000000000
89989989989989989989989989989981111111111111111c11ccc11c111111000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999991111111111111111cc1111cc1111111000000000000000000000000000000000000000000000000000000000000000000
9f99f99f999f99f99f99f99f99f99f911111111111111111c1111111111111000000000000000000000000000000000000000000000000000000000000000000
999999999999999999999999999999911111111111111111c1111111111111000000000000000000000000000000000000000000000000000000000000000000
f9ff9ff9ff9ff9ff9ff9ff9ff9ff9ff1111111111cc11cc11c111111111111000000000000000000000000000000000000000000000000000000000000000000
9ff9ff9ff9ff9ff9ff9ff9ff9ff9ff9111111111c11c1c1cc1111111111111000000000000000000000000000000000000000000000000000000000000000000
7777777777777777777777777777777111111111c111cc1111111111111111000000000000000000000000000000000000000000000000000000000000000000
777777777777777777777777777777711111111c11111c1111111111111111000000000000000000000000000000000000000000000000000000000000000000
eeedeeedeeedeeedeeedeeedeeedeee11111111cccc1118818888181111111000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee111111111111c188228182881111111000000000000000000000000000000000000000000000000000000000000000000
ededededededededededededededede111111111cccc111188228881111111000000000000000000000000000000000000000000000000000000000000000000
dededededededededededededededed11111111cc111111181881811111111000000000000000000000000000000000000000000000000000000000000000000
ededededededededededededededede1111c111ccc11111111111111111111000000000000000000000000000000000000000000000000000000000000000000
2ee2ee2ee2ee2ee2ee2ee2ee2ee2ee211111cc1111c1111111111111111111000000000000000000000000000000000000000000000000000000000000000000
e8de8de8de8de8de8de8de8de8de8de1111111ccccc1111111111111111111000000000000000000000000000000000000000000000000000000000000000000
2e22e22e22e22e22e22e22e22e22e221111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000
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
000a0a0000000000a0000008000080000000000000a00a00000a0000000000000000000000000000000000000000000050505050505050505050505000000000
00a000a000000000a0000000800080000000000000a000a0000a0000000000000000000000000000000000000000033000000000000000000000000000000000
00a0000a00000000a0000000080800000000000000aa00a0000a00000000000000aa0000000000000000000000003bb350666060006660666000005000000000
000a000a0000000a000000000080000000000000000900a0000a00000a000000aa0aa00000000000000000000003bb3000611060006160611000000000000000
00000000a00000a00000000000000000000a00000009000900aa0000a0a000aa00000a000000000000000000003bb30050660060006660606000005000000000
00000000900000a000000000000000000aa0a00000090009009a000a000a00a000000aa0000000000000000003bb300000610066606160666000000000000000
000000000900090000000000000000000a00a000000900009099000a000aa0a0000000a000000000000000000033000050100011101010111000005000000000
00000000090090000000000000000000a00a0000000900009099000a0000a00a00000aa000000000000000000000000000000000000000000000000000000000
00000000009900000000000a000a000aa00a000000090000909900090000a00a00000a0000000000000000000000000050660066600660666066605000000000
0000000000990000a000a00a000a000a0090000000090000999900900000a00a0000aa0000000000000000000000000000616061106110611016100000000000
0000000009900000a000a0a0000a00090900000000090000099000900009900a000aa00000000000000000000000000050660066601600666006005000000000
0000000000090000a0000aa0000990090000000800080000088000900009000a0aaa000000000000000000000000000000616061100160611006000000000000
00000000000900000a00099000009009000000800008000000800080000900099900000000000000000000000000000050606066606610666006005000000000
00000000000900000900099000009008000088000000000000800088008000090000000000000000000000000000000000101011101100111001000000000000
00000000000080000900090900009000888800000000000000800008880000090000000000000000000000000000000050505050505050505050505000000000
00000000000080000900090090008000000000000000000000800000000000080000000000000000000000000000000000000000000000000000000000000000
00000000000080000800800099000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
00000000000008000080800008000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
00000000000008000080800000000000000000000aaa099908800888000000800000000000000000000000000000000000000000000000000000000000000000
0000000000000800000000000000000000000000000a090900800808000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000aaa090900800888000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000a00090900800008000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000aaa099908880888000008800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000
__label__
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d4ddd1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1dd66ddd1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d14d66d1d1d1d1d161d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d466d0aa01ddd1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1ddd00aa0d6d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1da00aa00aa0d66d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1a00aa00aa0dd61d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1aa00aa000aa0ddd1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1daa000aa00aa01d6d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d10aaad001d1d0d161d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d0d1d101d1d101d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d0d1d1d0d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1dfdfdfdfd1d1d1d1d1d1d1d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1111111111111d1d1d1d1d1d1dfdfdfdfdfd1111111d1d1d1d1d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d111111111111111111111d1d1d1dfdfdfdffffff11111111111d1d1d1d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d111111111111111111111111111d1d1d1dffffffffff1111111111111d1d1d1d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d11111111111111111111111111111111111111111fffffffff111111111111111d1d1
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d11111111111111111111111111111111111111111111111111111111111fffffffff11111111111111111d
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d111111111111111111111111111111111111111111111111111111111111111ffffffff111111111111111111
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1111111111111111111111111111111111111111111111111111111111111111111ffffffff11111111111111111
d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d111111111111111111111111111111111111111111111111111111111111111111111fffffff11111111111111111
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d111111111111111111111111111111111111111111111111111111111111111111111111fffffff11111111111111111
d1d1d1d1d1111111d1d1d1d1d1d1d1111111111111111111111111111111111111111111111111111111111111111111111111111ffffff11111111111111111
1d1d1d111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ffffff11111111111111111
d1d111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ffffff11111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ffffff11111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111fffff111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111fffff111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ffff1111111111711111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ffff11111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111fff111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111fff11111111111111111111a1
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ff111111111111111111111111
11111111111111111111111ee111111111111111111111eee1111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111b1111111e11111119991aaa1bbb111111e11111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111b1111111e11188819191a111b111ccc11e11111118111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111b111ccc1e1e111119911aa11bb1111111e11111188811111111111111111111111111111111111111111111111111111111111111111111111
11111111111111b1111111eee111119191a111b11111111e11111118111111111111111111111111111111111111111111111111111111111111111111111111
11111111711111bbb11111111111119991aaa1bbb111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111117771711177717171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111117071711170717171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111117771711177717771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111117001711170710071111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111117111777171717771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111110111000101010001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111114ddd11111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111dd66dd11111111d111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111111111111114d66d1111111d1611111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111111111111111d466ddeef11d1111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111ddddeefd611111111111111111111111111111111111111111
111111111111111111117771777177717771111111111111111111111111111111111111111abbccddeefd661111111111111111111111111111111111111111
111111111111111111110701070177717001111111111111111111111111111111111111111abbccddeefdd61111111111111111111111111111111111111111
11111111111111111111171117117077771111111111111111111111111111111111111111aabbccdddeefdd1111111111111111111111111111111111111111
11111111111111111111171117117171701111111111111111111111111111111111111111aabbbccddeef116111111111111111111111111111111111111111
111111111111111111111711777171717771111111111111111111111111111111111111110aaa10011110116111111111111111111111111111111111111111
11111111111111111111101100010101000111111111111111111111111111111111111111011110111110111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111110111110111111111111111111111111111111111111111111
11111111111111111111111111771111117771777177111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111171111117771171171711111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111171111117171171171711111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111171111117171171171711111111111111111111111111111111111111111111111111111111111111111111111111171111111
11111111111111111111111111777111117171777171711111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111177177717771777177111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111700170717001700170711111111111111111111111111111111111111111111711111111111111111111111111111111111111111111
11111111111111111111777177717711771171711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111007170017011701171711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111770171117771777177711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111001101110001000100011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111777111111111111177717771711177717711177177717711111111111111111111111111111111111111111111111111111111
11111111111111111111111111117111111111111171717171711171717171711171117171111111111111111111111111111111111111111111111111111111
11111111111111111111111111777111117771111177117771711177717171711177117171111111111111111111111111111111111111111111111111111111
11111111111111111111111111711111111111111171717171711171717171711171117171111111111111111111111111111111111111111111111111111111
11111111111111111111111111777111111111111177717171777171717171177177717771111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111777171117771177117711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111700171117071700170011111111111111111111111111111111111111111111111111111111111111111111111111111111111112114
11111111111111111111771171117771711177711111111111111111121112111211111111111111111111111111111111111111111111111111111142124212
11111111111111111111701171117071717100711111111111111421142124212421241121111111111111111111111111111111111111111411241424242424
11111111111111111111711177717171777177011111111111421242424242424242424242124112111111111111111111111111111112114242424242424242
11111111111111111111011100010101000100111111112414242424242424242424242424242424211411141111111111111121142124242424242424242424
11111111111111111111111111111111111111111112124242424242424242424242424242424242424241424142114211421242424242424242424242424242
11111111111111111111111111111111111111111124242424242424242424242424242424242424242424242424242424242424242424242424242424242424
11111111111111111111177117711771777177724772424242424242424242424242424242424242424242424242424242424242424242424242424242424242
11111111111111111111700170017071707470047004242424242424242424242424242424242424242424242424242424242424242424242424242424242424
11111111111111111111777171117171770277427772424242424242424277727772477272727772424247724742727277724772477272427272424242424242
11111111111111111111007171117171707470240074242424242424242470747074707474740704242470047074747407047004700474247474242424242424
11111111111111111111770107717702727277727702424242424242424277727702727272724742424277727272727247427242724272427772424242424242
11111111111111111111001110010024040400040024242424242424242470747074747474742724242400747704747427247474747474240074242424242424
11111111111111111111111111124242424242424242424242424242424272727772770207724742424277020772077277727772777277727772424242424242
11111111111111111111111124242424242424242424242424242424242404040004002420042024242400242004200400040004000400040004242424242424
11111111111111111111421242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242
11111111111111111411242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424
11411111121112114242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242
14211421142124242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424
42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242
24242424242424242000000000000000000000000004000004240000000000000000000004240000000000000000000004240000000000000424242424242424
42424242424242420088008008080888008800880802080802420888088808080888088802420777077707770770077702420777077707770242424242424242
24242424242424240800080808080080080008000804080804240808008008080800080804240707070700700707070004240070070707770424242424242424
42424242424242420888080808080080080008000802088802420880008008080880088002420777077000700707077042424070077707070242424242424242
24242424242424240008088008080080080808080800000804240808008008880800080804240700070700700707070004240070070707070424242424242424
42424242424242420880008800880888088808880888088802420808088800800888080802420702070707770777077702420770070707070242424242424242
24242424242424240000200000000000000000000000000004240000000000000000000004240004000000000000000004240000000000000424242424242424
42424242424242423333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333242424242424242

__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600000e6711c641246250060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
010800001536010365000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800001d36021365003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
010700000012218131241413c14130131241310010100105003020030200302003020030200302003020030200302003020030200302003020030200302003020030200302003020030200302003020030200302
01070000001220c131181413014124131181310010100105001050010500105001050010500105001050010500105001050010500105001050010500105001050010500105001050010500105001050010500105
010c00160c0300003000030000300c0300003000030000300c0300003000030000300c0300003000030000300f0300f0300f03011030110301103011000110000c00000000000000000000000000000000000000
011000000c0530000000000000001c6550000000000000000c7530000000000000001c655000001f6251d6450c0530000000000000001c6550000000000000000c7530000000000000001c6551d6451d6351d625
010c00160c0300003000030000300c0300003000030000300c0300003000030000300c0300003000030000300703007030070300a0300a0300a03007000070000a0000a000000000000000000000000000000000
011000000c5460f5360c5260f5160c5460f5360c5260f5160c546135360c526135160c546135360c526135160a5460c536145260c5160a5460c536145260c5160f546185360f526185460f536185460f53618516
011000002b3342b334293352933528335243352433500324003042b33500005000052733527335243350c3242433500005183352433500005183352433500324183351b3351d335000051f3351b335183350c324
011000002b3342b434293352913628335184352433500424001042b3350040500305184351b135183351b4242b335004052713524335184002433530435001240c3261b4352933524405271351b3440f4550c324
011000000c0530000000000000001c6050000000000000000c7530000000000000001c605000001f6051d6050c0530000000000000001c6050000000000000000c7530000000000000001c6051d6051d6051d605
011000000c0530c6250c6250c625186250c6250c6250c6250c7530c6250c6250c625186250c6250c6250c6250c0530c6250c6250c625186250c62518625246250c7530c625186251862524625246253062530625
__music__
01 08090b0c
00 0a090b0d
00 080e0b0c
02 0a0f0b0d

