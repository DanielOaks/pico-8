pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- star-smatter
-- pixienop (daniel oaks) 2018
scene = "0"
scene_just_entered = true
scene_start_time = 0
base_time = 0
show_debug = false

scene_list = {
		--"cls",
		
		"intro-pixienop",
		"intro-starsmatter",
		"intro-black",
		"intro-popin",
		"intro-popin-fadeout",
		"effect-bars",
		"effect-plasma",
		--plasma *of the rainbow's colours*? :ooo
		"effect-tunnel",
  "outro-planet",

		-- static before the restart
		"effect-screen-static",
}
-- here, we input times in a relative way,
-- but _init turns them into absolutes.
--
-- todo(dan): should we do this with ms to
-- prevent floating point scene/music desyncs?
scene_end_time = {}
scene_end_rtime = {}
scene_end_rtime["cls"] = 0.1
scene_end_rtime["intro-pixienop"] = 3.15
scene_end_rtime["intro-starsmatter"] = 3.2
scene_end_rtime["intro-black"] = 1
scene_end_rtime["intro-popin"] = 15.5
scene_end_rtime["intro-popin-fadeout"] = 1
scene_end_rtime["effect-bars"] = 36.5
scene_end_rtime["effect-plasma"] = 13.35
scene_end_rtime["effect-tunnel"] = 25.05
scene_end_rtime["outro-planet"] = 26.2
scene_end_rtime["effect-screen-static"] = 1.5


-- effect vars
outro_explosions_played = false

stars = {}

star_colours = {
		7, 7, 6, 6, 5,
		9, 10, 14, 13, 15,
}

charging_sprites = {
		204, 233, 236
}

plasma_rb_delay = 3
plasma_colours = {
		--1, 2, 8, 14, 4, 3, 1
		2, 1, 1, 1, 2, 1, 3, 3
}

rb_width = 3
rb_width_mod = rb_width / -2 -- helps centre things
rb_phase = 0.04
rb_current_sync = 0
rb_rainbow_pattern = {
		8,9,10,11,3,12,2,14,
		--8,9,10,3,1,2,14,
}

stxt_start_time = 99999
stxt_start_delay = 23
stxt_text = "star-smatter, my first demo!  hope you like it!  greetz to rez, razor1911, 4mat, flt, conspiracy, y'all are awesome and got me into this!  now back to the effects!"
stxt_start_x = 128 -- will depend on trig used
stxt_char_width = 4
stxt_x = 0
stxt_y = 110
stxt_speed = 2
stxt_amplitude = 2
stxt_phase = 0.06
stxt_colors = {
		--8, 14, 12, 3,
		--8,9,10,11,3,12,13,2,14,
		--8,9,10,3,12,2,14,
		8,9,10,3,12,14,
}

tun_speed = 0.3
tun_radius = 90
tun_smallest_radius_count = 1.2
tun_step_phase = 0.25
tun_step_speed = 0.1
tun_z_frames = 16
tun_angles_around = 30

-- because of how we canculate
-- the z, frames and step speed
-- factor into the step phase,
-- so must multiply into the
-- original one above \o/
tun_2_smallest_radius_count = 1.2
tun_2_step_speed = 0.05
tun_2_z_frames = 32
tun_2_colors = {
		8,9,10,11,3,12,2,14,
}
tun_2_angles_around = #tun_2_colors
tun_2_angle_mod = 0
tun_2_angle_mod_phase = 0.005

-- working vars
tprint_current_i = {} -- default is 0 so it prints on first char

-- demotime returns the current time,
-- fixed for demo replays and such :)
function demotime()
		return time() - base_time
end

function scenetime()
		return demotime() - scene_start_time
end

function _init()
		print("initializing")
		
		-- set initial scene
		scene = scene_list[1]
		
		-- make proper scene end times
		local stime = 0
		for i=1, #scene_list do
				local sname = scene_list[i]
				stime += scene_end_rtime[sname]
				scene_end_time[sname] = stime
		end
		
		base_time = time()
end

function _update()
		if btnp(4) then
				show_debug = not show_debug
		end

		if scene_end_time[scene] < demotime() then
				scene_just_entered = true
				for i=1, #scene_list do
						if scene_list[i] == scene then
								if i == #scene_list then
										-- restart the demo
										scene = scene_list[1]
										base_time = time()
								else
										scene = scene_list[i+1]
								end
								break
						end
				end
		end
		
		rb_current_sync += 0.0015
		if 1 < rb_current_sync then
				rb_current_sync -= 1
		end

		tun_2_angle_mod += tun_2_angle_mod_phase
		if 1 < tun_2_angle_mod then
				tun_2_angle_mod -= 1
		end
		
		stxt_x -= stxt_speed
end

function _draw()
--		print("scene " .. scene .. " - time " .. demotime())

		-- update scene start time
		if scene_just_entered then
				scene_start_time = demotime()
		end
		local st = scenetime()
		local dt = demotime()

		-- draw scene details
		if scene == "cls" then
				-- normally just for testing
				cls()
				outro_explosions_played = false
		elseif scene == "intro-pixienop" then
				if scene_just_entered then
						music(-1)
						sfx(1)
				end
				outro_explosions_played = false
		
				cls()
				color(1)
				rectfill(0, 0, 128, 128)

				-- draw the logo grey first
				pal()
				pal(10, 6)
				pal(9, 6)
				pal(8, 5)
				spr(176, 25, 39, 9, 5)
				
				color(7)
				pal()
				
				local tstate = st
				if st < 0.25 then
						tstate = 0
				elseif st < 1.35 then
						tstate *= 11
						tstate = flr(tstate)
						while 3 < tstate do
								tstate -= 3
						end
				else
						tstate = 4
				end
				
				if tstate == 0 then
						palt(8, true)
						palt(9, true)
						palt(10, true)
				elseif tstate == 1 then
						palt(8, true)
						palt(10, true)
				elseif tstate == 2 then
						palt(8, true)
						palt(9, true)
				elseif tstate == 3 then
						palt(9, true)
						palt(10, true)
				end
				spr(176, 25, 39, 9, 5)

				if st < 0.5 or 2.3 < st then
						pal()
						color(1)
						local stf = st
						local fp = 0b0
						if st < 0.5 then
  						fp = 0b0000000000000000
  						while 0.02 < stf do
  								fp = shl(fp, 1)
  								fp += 0b1
  								stf -= 0.02
  						end
  				elseif 2.15 < st then
  						fp = 0b1111111111111111
  						while 2.15 < stf do
  								fp = shl(fp, 1)
  								stf -= 0.035
  						end
  				end
						fillp(fp + 0b0.1)
						rectfill(0, 40, 128, 80)
						fillp()
				end
		elseif scene == "intro-starsmatter" then
				if scene_just_entered then
						music(1)
				end
				
				cls()
				color(1)
				rectfill(0, 0, 128, 128)
				
				if 128 < st*100 then				
						color(0)
						rectfill(0, 61 - min(st*100-128, 128)*0.85, 128, 67 + min(st*100-128, 128)*0.85)

  				color(1)
  				rectfill(0, 61, 128, 67)
				end
				
				color(7)
				rectfill(0, 60, min(st*100, 128), 60)
				rectfill(128 - min(st*100, 128), 68, 128, 68)
				
				tprint("star-smatter", scene_start_time, demotime(), 0.05, nil, 41, 62)
				if 1.3 < st then
						--tprint("a smol pico-8 demo", scene_start_time+1.3, demotime(), 0.05, nil, 29, 71)
						-- use smol font mentioned on the bbs (thx keiya!)
						tprint("\65 \83\77\79\76 \80\73\67\79-8 \68\69\77\79", scene_start_time+1.3, demotime(), 0.05, nil, 29, 71)
				end
		elseif scene == "intro-black" then
  		color(0)
  		rectfill(0, 128, 128, 128 - min(st*100, 128))
		elseif scene == "intro-popin" then
				local scroll_in = 128 - min(st*100, 128)
		
				-- dodgy sky -- to make betr latr
  		color(1)
  		rectfill(0, 128, 128, 128 - min(st*100, 128))
  		
  		-- draw stars
  		if scene_just_entered then
  				for i = 1, 80 do
  						local star = {}
  						star.x = flr(rnd() * 128)
  						star.y = flr(rnd() * 128)
  						star.life = flr(rnd() * 120)
  						star.colour = flr(rnd() * (#star_colours - 1)) + 1
  						star.big = 0.95 < rnd()
  						if (4 < star.y and star.y < 56) or (73 < star.y and star.y < 100) then
				  				add(stars, star)
				  		end
  				end
  		end
  		
  		for i = 1, #stars, 1 do
  				local star = stars[i]
  				
  				-- do here instead of update just because
  				-- putting it in update will affect all frames
  				-- and meh
  				star.life -= 1
  				if star.life < -30 then
  						star.life = flr(rnd() * 120)
  				end
  				stars[i].life = star.life
  
  				if 0 < star.life then
  						pal(7, star_colours[star.colour])
  						local star_sprite = 201
  						if star.big then
  								if 90 < star.life then
  										star_sprite = 203
  								elseif 35 < star.life then
  										star_sprite = 202
  								end
		    		end
		    		spr(star_sprite, star.x, star.y + scroll_in)
    		end
  		end
  		pal()
				
				-- draw clouds
				--todo: break cloud apart on lazer shootin'
				
				-- draw lazer
				if 14.7 < st then
						for i = 1, #rb_rainbow_pattern, 1 do
								color(rb_rainbow_pattern[i])
								local x1 = 58 + ((i-1)*1)
								local laz_height = 0
								if 14.7 < st and st < 15.1 then
										laz_height = max(0, 105-230*(0.5+cos((st-14.7)*0.7)*-0.5)+cos(i/(#rb_rainbow_pattern+1))*4)
								end
								rectfill(x1, laz_height, x1, 128)
						end
  		end
				
				-- draw charge-up
				if 14.65 < st then
						spr(218, 53, 97, 2, 1)
						spr(218, 55, 97, 2, 1)
						spr(218, 54, 97, 2, 1)
				elseif 11.5 < st then
						local base_sprite = charging_sprites[flr(sin(st*1.7)*1.4+2.4)]
						spr(base_sprite, 50, 94, 3, 2)
				elseif 11.3 < st then
						spr(218, 54, 95, 2, 1)
				elseif 11 < st then
						spr(217, 58, 95)
				end
				
				-- draw the lazar shooter
				pal(1, 6)
				pal(4, 5)
				pal(2, 0)
				color(13)
				spr(153, 38, 97 + 50 - 50 * min(st * 0.1, 1), 6, 3)
				pal()
				
				-- draw mountains
				local mountain_shake = 0
				if 6.5 < st and st < 10.2 then
						mountain_shake = max(min(1, sin(st*0.65)*2.5), -1)
				end
				spr(96, 0 + mountain_shake, 104 + scroll_in, 16, 3)

				-- draw buildings
				pal(4, 0)
				local building_shake = 0
				if 6.6 < st and st < 10.3 then
						building_shake = max(min(1, cos(st*0.9)*1.6), -1)
				end
  		spr(144, 0+building_shake, 112 + scroll_in, 8, 2)
  		spr(144, 64+building_shake, 112 + scroll_in, 8, 2)
  		pal()
  		
				color(7)
				if 14.7 < st then
						-- do nothing
				elseif 14.5 < st then
						color(5)
						print("project star-smatter.", 20, 62)
						print("our last hope.", 20, 68)
				elseif 8.75 < st then
						print("project star-smatter.", 20, 62)
						tprint("our last hope.", scene_start_time+8.75, demotime(), 0.1, nil, 20, 68)
				elseif 6.75 < st then
						tprint("project star-smatter.", scene_start_time+6.75, demotime(), 0.075, nil, 20, 62)
				elseif 4.7 < st then
						print("we all knew that this", 20, 62)
						print("day would come...", 20, 68)
				elseif 3.6 < st then
						print("we all knew that this", 20, 62)
						tprint("day would come...", scene_start_time+3.6, demotime(), 0.05, nil, 20, 68)
  		elseif 2.5 < st then
						tprint("we all knew that this", scene_start_time+2.5, demotime(), 0.05, nil, 20, 62)
  		end
		elseif scene == "intro-popin-fadeout" then
  		color(0)
  		rectfill(0, 128, 128, 128 - min(st*600, 128))
  elseif scene == "effect-bars" then
  		if scene_just_entered then
  				stxt_start_time = demotime() + stxt_start_delay
  				stxt_first_frame_this_add = true
  		end
  
  		-- draw bg
  		color(1)
  		rectfill(0, 0, 127, 127)

  		-- draw stars
  		if scene_just_entered then
  				stars = {}
  				for i = 1, 60 do
  						local star = {}
  						star.x = flr(rnd() * 128)
  						star.y = flr(rnd() * 128)
  						star.z = 0.85 < rnd()
  						star.life = flr(rnd() * 120)
  						star.colour = flr(rnd() * (#star_colours - 1)) + 1
  						star.big = 0.95 < rnd()
  						add(stars, star)
  				end
  		end
  		
  		for i = 1, #stars, 1 do
  				local star = stars[i]
  				
  				-- do here instead of update just because
  				-- putting it in update will affect all frames
  				-- and meh
  				star.life -= 1
  				if star.life < -30 then
  						star.life = flr(rnd() * 120)
  				end
  				stars[i].life = star.life
  				
  				star.y += 20 * rnd()
  				if 131 < star.y then
  						star.y = 0 - 3
  						star.x = rnd() * 128
		  				stars[i].x = star.x
  						star.z = 0.85 < rnd()
		  				stars[i].z = star.z
  						star.colour = flr(rnd() * (#star_colours - 1)) + 1
		  				stars[i].colour = star.colour
  						star.big = 0.95 < rnd()
		  				stars[i].big = star.big
  				end
  				stars[i].y = star.y
  
  				if not star.z then
    				if 0 < star.life then
    						pal(7, star_colours[star.colour])
    						local star_sprite = 201
    						if star.big then
    								if 90 < star.life then
    										star_sprite = 203
    								elseif 35 < star.life then
    										star_sprite = 202
    								end
  		    		end
  		    		spr(star_sprite, star.x, star.y)
      		end
      end
  		end
  		pal()
  		
  		-- draw rasterbars
  		local pattern_width = 24
  		local pattern_width_mod = 10
  		local pattern_height = 42 - max(0, 100-st*55)
  		local pattern_height_mod = 10
  		local pattern_height_perspective = 10
  		local rb_swirl_phase = 0 -- doesn't work right, lol
  		local pattern_vase_width = 10
  		local pattern_vase_phase = sin(st*0.1)*0.005
  		pattern_vase_phase *= min(1, max(0, st*0.25 - 3))

				-- really messes up the vase pattern after a while~
  		local extra_phase = min(20, max(1, st*0.45 - 8))
  		extra_phase *= min(1, max(0, 20 - st*0.45))
  		if extra_phase < 1 then
		  		pattern_vase_phase *= extra_phase
		  end
  		
  		for i = 1, #rb_rainbow_pattern, 1 do
    		--local x1 = 128/2 + flr(cos((st / 2)-(rb_phase*i))*pattern_width)
    		local y1 = pattern_height+cos((st / 2)+0.25-(rb_phase*i))*pattern_height_perspective+sin((st*0.5)+(i*rb_current_sync))*pattern_height_mod
    		if flr(((st-(rb_phase*i)) + 0.5) % 2) == 1 then
      		color(rb_rainbow_pattern[i])
      		--rectfill(x1+rb_width_mod, y1, x1+rb_width+rb_width_mod, 128)
      		for y2 = 128, y1, -1 do
      				local x2 = 128/2 + flr(cos((st / 2)-(rb_phase*i)+sin(y2*rb_swirl_phase))*pattern_width+((sin(cos((st / 2)-(rb_phase*i))*y2*pattern_vase_phase))*pattern_vase_width))
      				rectfill(x2+rb_width_mod, y2, x2+rb_width+rb_width_mod, y2)
      		end
      end
  		end
  
  		for i = #rb_rainbow_pattern, 1, -1 do
    		--local x1 = 128/2 + flr(cos((st / 2)-(rb_phase*i))*pattern_width)
    		local y1 = pattern_height+cos((st / 2)+0.25-(rb_phase*i))*pattern_height_perspective+sin((st*0.5)+(i*rb_current_sync))*pattern_height_mod
    		if flr(((st-(rb_phase*i)) + 0.5) % 2) == 0 then
      		color(rb_rainbow_pattern[i])
      		--rectfill(x1+rb_width_mod, y1, x1+rb_width+rb_width_mod, 128)
      		for y2 = 128, y1, -1 do
      				local x2 = 128/2 + flr(cos((st / 2)-(rb_phase*i)+sin(y2*rb_swirl_phase))*pattern_width+((sin(cos((st / 2)-(rb_phase*i))*y2*pattern_vase_phase))*pattern_vase_width))
      				rectfill(x2+rb_width_mod, y2, x2+rb_width+rb_width_mod, y2)
      		end
      end
  		end
  		
  		-- draw top stars
  		for i = 1, #stars, 1 do
  				if stars[i].z then
		  				local star = stars[i]
		  				
    				if 0 < star.life then
    						pal(7, star_colours[star.colour])
    						local star_sprite = 201
    						if star.big then
    								if 90 < star.life then
    										star_sprite = 203
    								elseif 35 < star.life then
    										star_sprite = 202
    								end
  		    		end
  		    		spr(star_sprite, star.x, star.y)
      		end
		  		end
		  end
		  pal()
		  
		  -- draw scroller
		  if stxt_start_time < dt then
		  		if stxt_first_frame_this_add then
		  				stxt_x = stxt_start_x
		  				stxt_first_frame_this_add = false
		  		end
		  
		  		-- restart text scrolling
    		local x_add = 0
    		--while stxt_x + stxt_char_width * (#stxt_text + 1) + x_add < 0 do
    		--		x_add += stxt_start_x + stxt_char_width * (#stxt_text + 1)
    		--end
		  
    		local c = 1 -- colour
    		local char = ""
    		local x = 0
    		local y = 0
    		local scrolltime = dt - stxt_start_time
    		for i = 1, #stxt_text, 1 do
    				char = sub(stxt_text, i, i)
    				x = (stxt_x + stxt_char_width*i) + x_add
    				y = stxt_y + sin(scrolltime + i * stxt_phase) * stxt_amplitude
    				
    				-- draw outline
    				color(0)
    				for xmod = -1, 1, 1 do
		    				for ymod = -1, 1, 1 do
				    				print(char, x+xmod, y+ymod)
				    		end
				    end
   
   					-- draw char
    				color(stxt_colors[c])
    				print(char, x, y)
    				
    				-- advance colours
    				if char != " " then
      				c += 1
      				if #stxt_colors < c then
      						c = 1
      				end
      		end
    		end


		  end
  		
  		-- draw intro fade-in
  		color(0)
  		rectfill(0, -1, 128, 128 - min(st*600, 129))
  		
  		-- draw outro fade-out
  		rectfill(0, -1, 128, 128 - min((36 - st)*600, 129))
  elseif scene == "effect-plasma" then
  		local sinst = sin(st)

  		-- draw black bg
  		color(0)
  		rectfill(0, 0, 127, 127)

				-- draw plasma
  		local result = 0
  		local colcount = #plasma_colours
  		--fillp(0x8aa2)
  		fillp(0xa5a5+0b0.1)
  		for x = 0, 127, 5 do
  				for y = 0, 127, 5 do
  						--result += sin((y * 0.01) + st * 0.1)
  						--result += sin((sin(x*0.004) + cos(y*0.004)) * st * 0.25)
  						--result += sin((x/127) + (y/256) + st*0.1)
  						--cx = x + 0.5 * sin(st*78)
  						--cy = y + 0.5 * sin(st*4)
  						--result += sin(sqrt(10 * ((cx ^ 2) + (cy ^ 2)) + st * 50.3)*0.005)
  						--if x % 6 == 0 and y % 6 == 0 then
  								result = sin(st+(x+(y*sin((x*0.005)*st*0.7)*0.7))*0.02)
  								result += sin((x * 0.01) + sinst * 0.1)
  								result += cos((x-30*sinst*0.15)*y*sinst*0.00002)
  								result /= 3
  								result = (result*0.5+0.5)*colcount+1
  								result = min(colcount, max(1, flr(result)))
  						
  								--pset(x, y, )
  								color(plasma_colours[result])
  								rectfill(x, y, x+4, y+4)
  						--end
  				end
  		end
  		fillp()

  		
  		-- draw rainbow
  		local max_x = min(127, max(0, flr((st - plasma_rb_delay) * 350)))
  		if 0 < max_x then
    		for x = 0, max_x do
    				local y = sin(x*0.01+st*4)*((sinst*2*0.5+0.5)*4.9)+((sin(st*0.46)*30.9))*(sin(x*0.004)*50/120)+50
    				for i = 1, #rb_rainbow_pattern, 1 do
    						if max_x < 127 then
      						if (i == 1 or i == #rb_rainbow_pattern) and max_x - 4 < x then
      						elseif (i == 2 or i == #rb_rainbow_pattern - 1) and max_x - 2 < x then
      						elseif (i == 3 or i == #rb_rainbow_pattern - 2) and max_x - 1 < x then
      						else
        						pset(x, y+(i-1), rb_rainbow_pattern[i])
        				end
        		else
        				pset(x, y+(i-1), rb_rainbow_pattern[i])
        		end
      		end
    		end
    end

  		-- draw intro fade-in
  		color(0)
  		rectfill(-1, 0, 128 - min(st*600, 129), 128)
  		
  		-- draw outro fade-out
  		rectfill(128, 0, min((12.8 - st)*600, 129), 128)
  elseif scene == "effect-tunnel" then
  		-- bg
  		color(1)
  		rectfill(0, 0, 127, 127)
  		
  	 local tt = st * 0.3
  		
  		-- initial tunnel stars
  		for z = 0, tun_z_frames, 1 do
  				local zmod = z / tun_z_frames
  				tt = (st - z * tun_step_speed) * tun_speed
  		
    		x = sin(tt) * 15.9 + sin(tt*2.4) * 4 + (128/2)
    		y = cos(tt) * 10.9 + cos(tt*5.6+3.7) * 3 + (128/2)
  
  				local starcolor = 7
  				if zmod < 0.15 then
  						starcolor = 0
  				elseif zmod < 0.33 then
  						starcolor = 5
  				elseif zmod < 0.66 then
  						starcolor = 6
  				end
    		color(starcolor)
  
    		local radius_mod = (z+tun_smallest_radius_count) / tun_z_frames
  				local radius = tun_radius * radius_mod
  
  				for angle = 1, tun_angles_around, 1 do
  						angle = (angle / tun_angles_around) + (zmod * tun_step_phase)
  
  						local x_around = x + radius * cos(angle)
  						local y_around = y + radius * sin(angle)
  						
  						pset(x_around, y_around)
  				end
  		end
  
  		-- tunnel strips
  		for z = 0, tun_2_z_frames, 1 do
  				local zmod = z / tun_2_z_frames
  				tt = (st - z * tun_2_step_speed) * tun_speed
  		
    		x = sin(tt) * 15.9 + sin(tt*2.4) * 4 + (128/2)
    		y = cos(tt) * 10.9 + cos(tt*5.6+3.7) * 3 + (128/2)
  
    		local radius_mod = (z+tun_2_smallest_radius_count) / tun_2_z_frames
  				local radius = tun_radius * radius_mod
  
  				for angle = 1, tun_2_angles_around, 1 do
  						local colorig = angle
  						angle = (angle / tun_2_angles_around) + (zmod * tun_step_phase) + tun_2_angle_mod
  
  						local x_around = x + radius * cos(angle)
  						local y_around = y + radius * sin(angle)
  						
  						pset(x_around, y_around, tun_2_colors[colorig])
  				end
  		end

  		-- draw intro fade-in
  		color(0)
  		rectfill(-1, 0, 64 - min(st*400, 65), 128)
  		rectfill(129, 0, 64 + min(st*400, 65), 128)
  		rectfill(0, -1, 128, 64 - min(st*400, 65))
  		rectfill(0, 129, 128, 64 + min(st*400, 65))
  		
  		-- draw outro fade-out
  		local fadeout_secs = 24.8
  		rectfill(129, 0, min((fadeout_secs - st)*400, 128), 128)
  		rectfill(-1, 0, 128 - min((fadeout_secs - st)*400, 129), 128)
  		rectfill(0, 128, 128, min((fadeout_secs - st)*400, 128))
  		rectfill(0, -1, 128, 128 - min((fadeout_secs - st)*400, 129))
  elseif scene == "outro-planet" then
  		-- stop music lol
  		if scene_just_entered then
  				--todo(dan): in-mem pattern replacement instead?
  				-- to keep the exact music place the same lol
  				music(20)
  		end
  
  		-- draw space
  		color(0)
  		rectfill(0, 0, 127, 127)
  		
  		-- draw stars
  		if scene_just_entered then
  				for i = 1, 80 do
  						local star = {}
  						star.x = flr(rnd() * 128)
  						star.y = flr(rnd() * 128)
  						star.life = flr(rnd() * 120)
  						star.colour = flr(rnd() * (#star_colours - 1)) + 1
  						star.big = 0.95 < rnd()
  						if (4 < star.y and star.y < 56) or (73 < star.y and star.y < 100) then
				  				add(stars, star)
				  		end
  				end
  		end
  		
  		for i = 1, #stars, 1 do
  				local star = stars[i]
  				
  				-- do here instead of update just because
  				-- putting it in update will affect all frames
  				-- and meh
  				star.life -= 1
  				if star.life < -30 then
  						star.life = flr(rnd() * 120)
  				end
  				stars[i].life = star.life
  
  				if 0 < star.life then
  						pal(7, star_colours[star.colour])
  						local star_sprite = 201
  						if star.big then
  								if 90 < star.life then
  										star_sprite = 203
  								elseif 35 < star.life then
  										star_sprite = 202
  								end
		    		end
		    		spr(star_sprite, star.x, star.y)
    		end
  		end
  		pal()
  		
  		-- draw planet
  		color(2)
  		circfill(280, 64, 200)
  		
  		clip(78, 0, 128-78, 128)
  		
  		sspr(0, 0, 127, 48, 78, 0)
  		sspr(0, 0, 127, 48, 50, 48)
  		sspr(0, 0, 127, 48, 30, 96, 127, 48, true)

  		color(12)
  		circ(280, 64, 201)
  		circ(280, 64, 202)
  		
  		color(0)
  		for width = 203, 220 do
		  		circ(280, 64, width)
		  end
		  
		  clip()

  		-- draw rainbow lol
  		max_x = min((st - 2)*7.5, 81)
  		
  		local rb_index = 1 + flr(st*5)
  		for x = 0, max_x do
  				y = 64
  				if x % 4 == 2 or x % 4 == 3 then
  						y = 65
  				end
  			
  				rb_index += 1
    		while #rb_rainbow_pattern < rb_index do
    				rb_index -= #rb_rainbow_pattern
    		end	
  			
  				pset(x, y, rb_rainbow_pattern[rb_index])
  		end
  		
  		-- draw asplosions
 			color(7)
 			local start_asp = 12.7
  		if start_asp < st then
  				if not outro_explosions_played then
  						music(-1)
  						sfx(4)
  						outro_explosions_played = true
  				end
  				circfill(81, 64, 5)
  		end
  		if start_asp + 0.8 < st then
  				circfill(81, 64, 25)
  		end
  		if start_asp + 1.8 < st then
  				circfill(81, 64, 40)
  		end
  		if start_asp + 2.8 < st then
  				circfill(81, 64, 66)
  		end
  		if start_asp + 3.8 < st then
  				rectfill(0, 0, 127, 127)
  		end
  		if start_asp + 0.15 < st then
  				circfill(86, 57, 8)
  		end
  		if start_asp + 0.3 < st then
  				circfill(83, 77, 12)
  		end
  		if start_asp + 0.45 < st then
  				circfill(76, 50, 14)
  		end
  		if start_asp + 0.60 < st then
  				circfill(94, 67, 10)
  		end
  		
  		-- draw outro text
  		if start_asp + 5.5 < st then
  				color(0)
						tprint("targets eliminated", scene_start_time+start_asp+5.5, demotime(), 0.05, 5, 28, 62)
  		end
  		if start_asp + 7 < st then
  				if flr(st) % 2 == 0 then
  						color(0)
  						pset(100, 66)
  				end
  		end
  		
  		-- fade-in
				if st < 1 then
						pal()
						color(0)
						local stf = st
						local fp = 0b0
						if st < 1.5 then
  						fp = 0b0000000000000000
  						while 0.07 < stf do
  								fp = shl(fp, 1)
  								fp += 0b1
  								stf -= 0.07
  						end
  				end
						fillp(fp + 0b0.1)
						rectfill(0, 0, 127, 127)
						fillp()
				end
  		
  		-- draw outro fade-out
  		local fadeout_secs = 26
  		rectfill(129, 0, min((fadeout_secs - st)*400, 128), 128)
  		rectfill(-1, 0, 128 - min((fadeout_secs - st)*400, 129), 128)
  		rectfill(0, 128, 128, min((fadeout_secs - st)*400, 128))
  		rectfill(0, -1, 128, 128 - min((fadeout_secs - st)*400, 129))

  elseif scene == "effect-screen-static" then
  		if scene_just_entered then
  				music(40)
  		end

  		cls()
  		for i = 0x6000, 0x7fff, 0x1 do
  				poke(i, band(rnd(0xff), 0x0f))
  		end
		end

		if show_debug then
  		-- print scene time lol
  		color(1)
  		rectfill(99, 0, 128, 6)
  		color(14)
  		print(st, 100, 1)

  		color(7)
  		print("t_cpu: " .. stat(1), 1, 1)
  		print("s_cpu: " .. stat(2), 1, 1+7)
  		print("  fps: " .. stat(7) .. "/" .. stat(8), 1, 1+7+7)
  end

		-- centre line
		--rectfill(63, 0, 64, 128)
		
		-- make sure starting scene marker is disabled
		if scene_just_entered then
				scene_just_entered = false
		end
end

-- typewriter print, takes:
-- - text
-- - started time of printing
-- - current time of printing
-- - per-character delay in secs
-- - per-character sound effect
-- - <other standard print() args>
function tprint(text, start_time, current_time, per_char_delay, per_char_sound, x, y, col)
		_tprint("1", text, start_time, current_time, per_char_delay, per_char_sound, x, y, col)
end
function tprint2(text, start_time, current_time, per_char_delay, per_char_sound, x, y, col)
		_tprint("2", text, start_time, current_time, per_char_delay, per_char_sound, x, y, col)
end

-- 'shard' is a rough way to handle
-- multiple tprints at once
function _tprint(shard, text, start_time, current_time, per_char_delay, per_char_sound, x, y, col)
		if tprint_current_i[shard] == nil then
				tprint_current_i[shard] = 0
		end

		far_i = 1
		for i=1, #text do
				if start_time + per_char_delay * (i - 1) <= current_time then
						far_i = i
				end
		end
		if tprint_current_i[shard] != far_i then
				tprint_current_i[shard] = far_i
				-- skip spaces
				if sub(text, far_i, far_i) != " " then
  				if per_char_sound != nil then
  						sfx(per_char_sound)
  				end
 		end
		end
		if col != nil then
				print(sub(text, 1, far_i), x, y, col)
		elseif x != nil and y != nil then
				print(sub(text, 1, far_i), x, y)
		else
				print(sub(text, 1, far_i))
		end
end
__gfx__
00001111111111111111111111111111111001111110000000000001111111111111111111111111111111110001111111111111111333000011111111000111
00011111111111111113111111111111100001111100000000000111111111111111111111111111111111111011111111111111111133300011111111110111
00011111111111111133331111111110000001111100000000001111111111111111111111cc1111011111111111111111111111111133330011111111111111
0011111111111111133333333111100000001111110100000001111111111111111111111ccccc11100111111111111111111111111113333101111111111111
01111111111111113333333333000000000011111110000000111111000001111111111111ccccc1111110000111111111111110001111333110111111111111
11111111111111113331133330000000000011111100000001111111100001111111111111ccccc1111100000011111111111110001111131111111111111111
11111111111111333311111111100000000111111000000011111111110001111111111110cccccc111000000000111111111110000111111111111110111111
11111111111113333300000011110000000111100000000111001111111001111111cccccccc1ccc111101111000000000011110000111111111111111011111
1111111111113333300000000011110000000000000000111111111111111111111ccccccccc1ccc111111111100000000001110000111111111111111001111
11111111111133300000000000000000000000000000011111111111111111111111cccccccccccc111111111100000000001111000011111111111111111111
1111111111133330000000000000000000000000000011111111111111111111111111ccccccccc1111111111000001111000100000000111111111111111111
111111111113330000000000000000000000000000011111111111111111111111111ccccccccc11111111111000000111000100000000000001111111111111
1111111111113000000000000000000000000000001111111111111111111111111cccccc0ccc111111111110000000011100000000000000000011111111111
011111111111100000000000000000000000000001111111111111111111111111ccccc0000c0111111111000000000001100010000000000000011111111111
1111111111110000000000000000000000000000011111111111111111111111111ccc0000000111111100000100000001100011000000000000000111111111
1111111111110000000000000000000000000000111111111111111111111111110ccc0000000111111100111100000000100011100000000000000011111111
1111111111110000000000000000000000000001111111111111111111111111cccccc0000001111111111111100000000100011110000000000000011111111
111111111111000000000000000000000000001111111111111111111111111cccccc00000111111111111111110000000000011110000000000000011011111
11111111111000000000000000000000000001111111000001ff111111100000cccc000011110001111111111110000000000111111000000000000000000111
1111111111000000000000000000000000001111111000000ffff111110000000000000011100000111111111110000000000000000011110000000000000011
11101111110000000000000000000000001111111110000000ffff11110000000000000011100000111111110101000000000000000001110000000000000011
111001111100000000000000000000001111111111100000000ffff1110000000000000011110000001111111111000000000000000000111100000000000011
11110111110000000cccccc01111111111111111111100000000ff11111000000000000011111100000001111111100000000000000000011100000000000111
1111111111000000cccccccc11111111111111111111100000000001111100000000000011110000000000111111110000000000000000001110000011111111
111111110000000cccccccccc0111111111111111111100000000001110000000000000111100000000000111111111110000000000000000110000011111111
11111110000000ccc0011cccccc11111111111111111100000000000000000000000001111100000000000011111111111100000000000000000000011111111
01111100000000cccccccccccccc1111111111111111111000000000000000000000111111100000000000011111111111011000000000000000000011111111
11110000000000cccccccccccccccc11111111111111111000000000000000001111111111100000000000011111111111011100000000000000000011111111
110000000000cccccccccccccccccccccc1111111111111100000000000000111111111111100000000000001111111111011110000000000000000011111111
00000000001ccccc1f1110cccccccccccccc11111111111110000000000011111111111111110000000000011111111111011111f00000000000000011111111
000000000111cccffff1100ccccccccccccccc11111111111111111111111111111111111111110001100011311111111101111fff0000000000000011111111
00000000111111fffff110011cccccccccccccc11111111111111111111111111111111111111111111111133311111111011111fff000000000000011111100
0000001111111fffff111011ccccccc11111cc1111111111111111111111111111111111111111111111113333333111110111111fff00000000000011110000
00001111111111ffcc11111ccc1111111111001100000111111111111111111111111111011111111111133333333311111111111fff00000000000111000000
11111111111111cccccc11ccc111111111000000000000111111111111111111111113111000001111111333113331111111111111f000000000000000000000
000011111111111cccccccccc1111111110000000000000111111111111111111111333111110001111133311111111111111111111000000000000000000000
100000011111111111ccccccc1111111100000010111100011011111111111111111131111111111111113111111111111111111111100000000000000000000
10000011111111111111cccc11111111100000011111100011111111111111111111111111111111111111111100111111111111111110000000000000000001
11000011111111111111111111111111100000111111110111111111111111000000000000001111111000111110011100111111111111000000000000000111
11000011111111111111111111111111110000111111111111111111110000000000000000000000010000000000000000111111111111111111111111111011
11100111111111111111111111011111111111111111111111111111000000000000000000000000000000000000000000111111101111111111111111111111
11100111111111111111111110001111111111111111111111111110000000000000000000000000000000000000001100111111000000111111111111111111
11111111110111111111111100111111111111111111111111111100000000000000000000000000000000000000001111111111000000000011111001111111
11111111111111111111111111111111111111111111111111111000000000001111111111000000000000000000011111111111133000000011111101111111
11111111111111111111111111111111111111111111111111110000000000001111111111111010000000000111111111111111333310000011111100111111
11111111111111111111111111111111111111111111111111110000000000000111111111111111111111001111111111111111133333331001111100011111
11111111111111111100111111111111111111111111111111100000001111111111111111111111111111001111101111111111113333333111111110001111
11111111111111111000001111111111111111100000000111000000011111111111111111111111111110011111100001111111111133333311111111001111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000006666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000556666656666665660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000055555556555555566666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555555555555556556666000000000000000000000000000000000000000000000000000000000000000000066666000000000000000
00000000000005555555555555555555555555666660000000000000000000000000000000000000000000000000000000000000666666666660000000000000
00000000000555555555555555555555555555566666660000000000000000000000000000000000000000000000000000000066666665566666000000000000
00000000005555555555555555555555555555555666666660000000000000000000000000000000000000000000000000066666665555566666655000000000
00000055555555555555555555555555555555555556665666650000000000000000000000000000000000000000000055566666666666665556665550000000
00055555335555555555555555555555555555555555555555665555000000000000000000000000000000000000055555666555555555555555555555550000
55353333333355555555555555555555555555555555555555555555555000000000000000000000000000000055555556665555556665555555555555555555
33333333333335555555555555333333355555333355555555555555555550000000000000000000000000005555566666555555665555555566566555555555
33333333333333335555553333333333335553333335555555555555555555550000000000000000000005555556655555555555555555555556666555555555
33333333333333333555333333333333355533333335553335533555355555555500000000000000055555555556555555555555555555555555556655555555
33333333333333333333333333355333333333333333533333333333333555555555555000005555555555555555555555555555555555555555555665555555
33333553333333333333333333553333333333333333533333333333333355555555555555555555555555555555555555533333333333355555555555553355
33333333333333333333333335555333333333333333333333333333333335555555555555555555555555333355335555333333333333335533335555533335
33333333333533333333333333333353333333333333333333333333333333355555553333355555555533333333333533333333333333333333333333333333
33333333333333333333333333333333333533333333333333333333333333333333333333333555555333333333333333333333333333333333333333333333
33335533333533333333333333333353333333333333333333555333353333333333333333333355553333333333333333333533333333333333333333333333
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000444400000000000000000004440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000411400000000000000000044540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000441400000000000000000045540044440444400000000000044400000000001111100000000001111111111111111000000000011111000000000
4444000000004140004440000000000004454004114441144000000000444d400000000001444410000000000144444444444410000000000144441000000000
4554400444444144404d440000000004445544044141111140000000444ddd440000000011111111000000001111111111111111000000001111111100000000
4555444411111111444dd444400044445555544411111111444440044dddddd40000000014222222111111111144442144444411111111112222224100000000
5555555516611661dddddddd44004544566554541111666111414404ddd6dddd0000000012444244444442444444421444444244444442144444422100000000
5666556511111111dddd6ddd54444545555555551611111111115444d6dd6d6d0000000014442444444424444444214444442444444421444444211100000000
5555565511116161d6d6dd6d55555555555665551111116111615555dddddd6d000000001442444344424446444214444442444c444214444442144100000000
5655665511611111dddddd6d56556665555555651161661111115565dd6d66dd000000001421444444244444442144e444244444442444b44421444100000000
5565556511111611d6d6d6dd55565555565555551611116116115565d66ddddd0000000012144444424474644244444442144144424444444244444100000000
5555555511111111dddddddd55555555555555551111111111115555dddddddd0000000011444444244444442444e44421444444244434442444444100000000
0000000000000000000000000000000000000000000000000000000000000000000000001444e442444644424444444214444442444444424444442100000000
00000000000000000000000000000000000000000000000000000000000000000000000014444424444444244444442144444424444444244444424100000000
00000000000000000000000000000000000000000000000000000000000000000000000014444244444442444444421444444244444442444444244100000000
000000000000000000000000000000000000000000000000000000000000000000000000144421444444244c4444214444442444444424444442444100000000
00000000000000000000000000000000000000000000000000000a000000000000000000144214444442444444424444444244444442444444244b4100000000
0000000000000000000000000000000000000000a00000000000aa00000000000000000014214444442444444424444444244444442444444244444100000000
0000000000000000000000000000000000000000aa0000000000a000000000000000000012144444424444444244444442444444424444442444444100000000
00000000000000000000000000000000000000000a0000000000a000000000000000000011444444244444442444444424444444244444424444442100000000
00000000000aaaaaa000000000000000000000000a0000000000a000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aa000000a00000000000000000000000aa000000000a000000000000000000000000000000000000007000000000000000000000000000000000000
00000000a00000000a000000000000000000000000a000000000a000000000000000000000000000000700000007000000000000000000000000000000000000
0000000a000000000a000000000000000000000000aa0000000aa000000000000000000000070000007070000770770000000000007000000000000000000000
000000a0000000000a000008808800000000000000aa0000000a0000000000000000000000000000000700000007000000000070000000000070000000000000
00000a00000000000a000080080080000000000000a0a000000a0000000000000000000000000000000000000007000000000000000700007000007000000000
0000a000000000000a000080000080000000000000a0a000000a0000000000000000000000000000000000000000000000077777777777777777700000000000
0000a000000000000a000080000080000000000000a00a00000a00000000000000000000000000000000000000000000007777aaaaaaaaaaaa77770000000000
000a0a0000000000a0000008000080000000000000a00a00000a0000000000000000000000000000000000000000000000777aaaaaaaaaaaaaa7770000000000
00a000a000000000a0000000800080000000000000a000a0000a0000000000000000000000000000000000000000000000777aaaaaaaaaaaaaa7770000000000
00a0000a00000000a0000000080800000000000000aa00a0000a00000000000000aa000000000000000000000000000000077aaaaaaaaaaaaaa7700000000000
000a000a0000000a000000000080000000000000000900a0000a00000a000000aa0aa00000000000000007777770000000000aaaaaaaaaaaaaa0000000000000
00000000a00000a00000000000000000000a00000009000900aa0000a0a000aa00000a00000000000000777777770000000000aaaaaaaaaaaa00000000000000
00000000900000a000000000000000000aa0a00000090009009a000a000a00a000000aa0000000000000777aa777000000000000000000000000000000000000
000000000900090000000000000000000a00a000000900009099000a000aa0a0000000a000777700000077aaaa77000000000000000000000000000000000000
00000000090090000000000000000000a00a0000000900009099000a0000a00a00000aa0077aa770000007aaaa70000000000000000000000000000000000000
00000000009900000000000a000a000aa00a000000090000909900090000a00a00000a0000000000000000000000000000000000000000000000000000000000
0000000000990000a000a00a000a000a0090000000090000999900900000a00a0000aa0000000000000000000000000000000000000000000000000000000000
0000000009900000a000a0a0000a00090900000000090000099000900009900a000aa00000000000000000000000000000000000000000000000000000000000
0000000000090000a0000aa0000990090000000800080000088000900009000a0aaa000000070000000070000000000000000070000000000007000000000000
00000000000900000a00099000009009000000800008000000800080000900099900000000700000000007000000700000000000000007000000700000000000
00000000000900000900099000009008000088000000000000800088008000090000000000000000000000000000000000000770000700000000000000000000
00000000000080000900090900009000888800000000000000800008880000090000000000077777777777777777700000077777777777777777700000000000
000000000000800009000900900080000000000000000000008000000000000800000000007777aaaaaaaaaaaa777700007777aaaaaaaaaaaa77770000000000
00000000000080000800800099000000000000000000000000000000000000080000000000777aaaaaaaaaaaaaa7770000777aaaaaaaaaaaaaa7770000000000
00000000000008000080800008000000000000000000000000000000000000080000000000777aaaaaaaaaaaaaa7770000777aaaaaaaaaaaaaa7770000000000
00000000000008000080800000000000000000000aaa099908800888000000800000000000077aaaaaaaaaaaaaa7700000077aaaaaaaaaaaaaa7700000000000
0000000000000800000000000000000000000000000a090900800808000000800000000000000aaaaaaaaaaaaaa0000000000aaaaaaaaaaaaaa0000000000000
00000000000000000000000000000000000000000aaa0909008008880000008000000000000000aaaaaaaaaaaa000000000000aaaaaaaaaaaa00000000000000
00000000000000000000000000000000000000000a00090900800808000000800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000aaa099908880888000008800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002d565295552b5452856529555265452453528535245252852524515285122850100001000000000000000186541864118631186211861500000000000000000000000000000000000000000000000000
01101020136120e6121161210612156120e612136120c612116120e6121361210612116120e6121361213612136120e6121161210612156120e612136120c612116120e6121361210612116120e6121361213612
010300000c6500c6500c6410c6400c6310c6300c6210c6200c6110c6100c6100c6100c60100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000015b550eb551365510b5011b550eb500c6600c6610c6510c6510c6410c6410c6310c6310c6210c6210c6110c6110c60100000000000000000000000000000000000000000000000000000000000000000
010200000c4400c430004250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000136100e6101161010620156200e610136200c620116100e6101361010610116300e6201362013620136200e6201162010630156300e620136300c630116200e6201362010620116300e6201362013620
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800001d3241d325180051c30521324213251c305213051a3241a32500000243051832418325000001c3051d3241d325180051c3051c3241c3251c30521305213242132500000243051f3241f325000001c305
011800000214502145021450214500145001450014500145051450514505145051450414504145051450714502145021450214502145001450014500145001450914509145071450714504145041450514505145
011800000e225002000e225002001c7000e1171c7001d7000c225002000c225002001c7000e1161d1141d125132251322513225002000e4150e4250e4250e435102250020010225002001a225002001a22500200
011800001a33300000000001d6051d655000001a333000001a333300003c6140000000000000001d655000001a33300000000001d655000001d655000001d6551a333000001a333000001d655000001d6551d654
011800000e115112150e0151331515315113151031511315000001031500005103151131510315153121531500000000000000015312000000000000000000000000013312000021331200000103100000011312
011800000561505615116153561505615116150561505615116150561505615356150561535615116150561505615116150561505615356151161535615356151161505615056153561511615056153561511615
011800000e125112150e025133151532511315103251131513025103151102510315113251031515325153150e125112150e02513315153251131510325113151302513315110251331511325103151532511315
011800002142521415214252141521425214151d4251d4151f4251f4151f4251f4151f4251f4151a4251a4151c4251c4151c4251c4151c4251c4151a4251a41518425184151842518415184251a4251a4251a415
0118000029425000002942500000294250000026425000002842500000284250000028425000002b4250000026425000002642500000264250000029425000002442500000244250000024425000002642500000
__music__
01 090a0b4c
00 090a0b4c
00 090a0b0c
00 090a0b0c
00 090a0b4c
00 490a0b4c
00 0a0b0d0e
02 0a0b0d0e
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
03 0f101144
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
03 024a4344

