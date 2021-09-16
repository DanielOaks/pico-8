pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- demo template
-- pixienop
replays=0
current_scene = -2
realscene_count = 0
final_scene = 900 -- set during running

continue_scene = 0

scene_updated_this_pattern = false
scene_just_entered = false
rs_just_entered = false

show_debug = false

_demotime_start = 0
_scenetime_start = 0

function demotime()
		return time() - _demotime_start
end

function scenetime()
		return time() - _scenetime_start
end

scene_just_entered = true

function demo_update()
		if stat(20) < 5 then
				if not scene_updated_this_pattern then
						scene_updated_this_pattern = true
						realscene_count += 1
						rs_just_entered = true
						
						if 0 < continue_scene then
								continue_scene -= 1
						else
  						scene_just_entered = true
  						current_scene += 1
  						if final_scene < current_scene then
  								current_scene = 0
  								continue_scene = 0 -- prevent overflows
  								realscene_count = 0
  								replays += 1
  						end
  						_scenetime_start = time()
 					end
 					
 					if current_scene == 0 then
								_demotime_start = time()
 					end
				end
		else
				scene_updated_this_pattern = false
		end

		if btnp(4) then
				show_debug = not show_debug
		end
end
-->8
-- effect info

-- b4s1c math
function asin(y)
 return atan2(sqrt(1-y*y),-y)
end

-- tri fill from p01♥♥
function p01_trapeze_h(l,r,lt,rt,y0,y1)
 lt,rt=(lt-l)/(y1-y0),(rt-r)/(y1-y0)
 if(y0<0)l,r,y0=l-y0*lt,r-y0*rt,0
 y1=min(y1,128)
 for y0=y0,y1 do
  rectfill(l,y0,r,y0)
  l+=lt
  r+=rt
 end
end
function p01_trapeze_w(t,b,tt,bt,x0,x1)
 tt,bt=(tt-t)/(x1-x0),(bt-b)/(x1-x0)
 if(x0<0)t,b,x0=t-x0*tt,b-x0*bt,0
 x1=min(x1,128)
 for x0=x0,x1 do
  rectfill(x0,t,x0,b)
  t+=tt
  b+=bt
 end
end
function trifill(x0,y0,x1,y1,x2,y2,col)
 color(col)
 if(y1<y0)x0,x1,y0,y1=x1,x0,y1,y0
 if(y2<y0)x0,x2,y0,y2=x2,x0,y2,y0
 if(y2<y1)x1,x2,y1,y2=x2,x1,y2,y1
 if max(x2,max(x1,x0))-min(x2,min(x1,x0)) > y2-y0 then
  col=x0+(x2-x0)/(y2-y0)*(y1-y0)
  p01_trapeze_h(x0,x0,x1,col,y0,y1)
  p01_trapeze_h(x1,col,x2,x2,y1,y2)
 else
  if(x1<x0)x0,x1,y0,y1=x1,x0,y1,y0
  if(x2<x0)x0,x2,y0,y2=x2,x0,y2,y0
  if(x2<x1)x1,x2,y1,y2=x2,x1,y2,y1
  col=y0+(y2-y0)/(x2-x0)*(x1-x0)
  p01_trapeze_w(y0,y0,y1,col,x0,x1)
  p01_trapeze_w(y1,col,y2,y2,x1,x2)
 end
end

-->8
-- runtime
function _init()
		-- start music
		music(0)
end

function _update60()
		demo_update()
end

function _draw()
		-- setup
		local dt = demotime()
		local st = scenetime()
		for i=0,15 do
			pal(i,i,1)
		end
		-- eft = music finetuning
		eft=.07
		-- et == music time
		et=st*(60/(8/(120/8))/60)-eft

		-- empty first pattern~
		-- this helps sync on the
		-- web player, since it can
		-- take a lil bit for that
		-- to start fully
		sc = -1
		if current_scene == sc then
				-- do nothing
		end
		
		-- intro
		sc += 1
		if current_scene == sc then
			if scene_just_entered then
				continue_scene=5
			end

			cls()
			
			-- effect here
			tet=et%4*2
			tet*=tet
			tet=1-tet
			--rectfill(-1,-1,128*tet-1,127,5+et/4)
			print(et/4%1,20,50,7)
			for i=0,3 do
				c=5
				if i<=et%4 then
					c=7
				end
				pset(20+i*5,57,c)
			end
		end
		
		-- set the final scene num dynamically
		-- so we don't need to stuff around so much
		if scene_just_entered then
				final_scene = sc
		end
		
		camera(0,0)  -- always reset cam

		-- print debug info
		if show_debug then
  		-- print scene time lol
  		color(1)
  		rectfill(103, 0, 128, 18)
  		rectfill(0, 0, 40, 18)
  		
  		color(14)
  		print("s:"..current_scene, 104, 1)
  		print(st, 104, 1+6)
  		print("c:"..continue_scene, 104, 1+12)

  		color(7)
  		print("cpu:" .. stat(1), 1, 1)
  		print("    " .. stat(2), 1, 1+6)
  		print("fps:" .. stat(7) .. "/" .. stat(8), 1, 1+6+6)
  end
		
		-- unset scene_just_entered
		if scene_just_entered then
				scene_just_entered = false
		end
		if rs_just_entered then
				rs_just_entered = false
		end
end
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800000c053000030000300003000030000300003000030c053000030000300003000030000300003000030c053000030000300003000030000300003000030c05300003000030000318635000030000300003
__music__
00 08424344
03 09424344

