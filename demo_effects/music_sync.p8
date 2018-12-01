pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- extra info
current_scene = -1
final_scene = 2

-- tracks whether current_scene
--  has already been updated
scene_updated_this_pattern = false
-- tracks whether we've entered
--  a new scene for this draw frame
scene_just_entered = false

-- if true, show debug info :shrug:
show_debug = false

-- time vars
_demotime_start = 0
_scenetime_start = 0



-- default demo stuff
function tan(a)
		return sin(a)/cos(a)
end

function demotime()
		return time() - _demotime_start
end

function scenetime()
		return time() - _scenetime_start
end

scene_just_entered = true

function _init()
		music(0)
end

function _update()
		-- update music scene count
		-- use this comparison just for
		--  a bit more safety if things lag
		--  unexpectedly
		if stat(20) < 5 then
				if not scene_updated_this_pattern then
						scene_updated_this_pattern = true
						scene_just_entered = true
						current_scene += 1
						if final_scene < current_scene then
								current_scene = 0
								_demotime_start = time()
						end
						_scenetime_start = time()
				end
		else
				scene_updated_this_pattern = false
		end
		
		-- show debug
		if btnp(4) then
				show_debug = not show_debug
		end
end

function _draw()
		-- setup
		local dt = demotime()
		local st = scenetime()

		-- drawing
		-- sc is used to simplify adding
		--  new scenes in the middle and
		--  shuffling them around
		sc = -1
		if current_scene == sc then
				-- do nothing
		end
		
		sc += 1
		if current_scene == sc then
				color(2)
				rectfill(0, 0, 127, 127)
				
				color(14)
				print("welcome to da demo", 30, 50 + sin(dt)*5)
				print("scene "..current_scene, 90 + cos(dt)*4.9, 90 + sin(-dt)*5.9)
		end
		
		sc += 1
		if current_scene == sc then
				color(3)
				rectfill(0, 0, 127, 127)

				color(11)
				print("welcome to da demo", 30, 50 + sin(dt)*5)
				print("scene "..current_scene, 90 + cos(dt)*4.9, 90 + sin(-dt)*5.9)
		end
		
		sc += 1
		if current_scene == sc then
				color(4)
				rectfill(0, 0, 127, 127)
				
				color(15)
				print("welcome to da demo", 30, 50 + sin(dt)*5)
				print("scene "..current_scene, 90 + cos(dt)*4.9, 90 + sin(-dt)*5.9)
		end
		
		-- print debug info
		if show_debug then
  		-- print scene time lol
  		color(1)
  		rectfill(103, 0, 128, 12)
  		rectfill(0, 0, 40, 18)
  		
  		color(14)
  		print(current_scene, 104, 1)
  		print(st, 104, 1+6)

  		color(7)
  		print("cpu:" .. stat(1), 1, 1)
  		print("    " .. stat(2), 1, 1+6)
  		print("fps:" .. stat(7) .. "/" .. stat(8), 1, 1+6+6)
  end
		
		-- remove scene_just_entered
		if scene_just_entered then
				scene_just_entered = false
		end
end
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000023532920002350262000535010205073500e205053530200004350050000035007000023500500007353000000735000000053500000004350000000535305300043500000000350000000235000000
01100000054500000005450000000445000000024500000009450000000945000000074500000005450000000e450000000e450000000c4500000009450000000e45609447074370545607447054360445702445
01100000244461a4552b4551d445264551a4452b4552b4051f4561f4451d4551d4451c4561c4451a4350000526455264452843528425294552b4452b4352d4252b45529445284352642529455264452843526425
011000001a4531d7551c7551a7551a4531d7551c7551a7551a4531d755296551a7551a4531d7551c7551a7551a4531d7551c7551a7551a4531d7551c7551a7551a4531d755296551a7551a453296551a45321755
011000001f7351d7251a7151a71500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a7151a7151a7251a7251a7351a7351a7451a765
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a7151a7151a7251a7251a7351a7351a7451a765
010800202662526625266252662526625266252662526625266252662526625266252662526625266252662526625266252662526625266252662526625266252662526625266252662526625266252662526625
__music__
00 01064344
01 02030447
02 01054344

