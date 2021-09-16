pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- new1/wip
-- pixienop
replays=0
current_scene=-2
realscene_count=0
_final_scene=9000 -- set-while-running

continue_scene=0

_scene_updated_this_pattern = false
scene_just_entered = true

_show_debug = false

_demotime_start = 0
_scenetime_start = 0

function demotime()
		return time() - _demotime_start
end

function scenetime()
		return time() - _scenetime_start
end

function demo_update()
		if stat(20) < 5 then
				if not scene_updated_this_pattern then
						scene_updated_this_pattern = true
						realscene_count += 1
						
						if 0 < continue_scene then
								continue_scene -= 1
						else
  						scene_just_entered = true
  						current_scene += 1
  						if _final_scene < current_scene then
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

-- intro
-- shoutout to conundrumer,
--  rabid squirrel & @shrn
-- ♥♥♥♥♥ ♥♥♥ ♥♥
-- go watch super flu - selee
pnop_x = 28
pnop_y = 42
pnop_width = 9
pnop_height = 5

function srr(st,x,y,r)
	srand(flr(st)+x*30+y*70)
	return rnd(r)
end

-- tri walk
twalk_depth=6
twalk_yh=10
twalk_spread=70
twalk_offsety=60

-- tentacle greets
greets={
	"mercury",
	"defame",
	"zep",
	"p01",
	"4mat",
	"aday",
	"jimage",
	"bedrock bros",
	"provod",
	"rzr1911",
	"jamaluata",
	"@shrn",
	"conundrumer",
	"rabid squirrel",
	"the deadliners",
}


function tprint(text, tprint_current_i, start_time, current_time, per_char_delay, per_char_sound, x, y, col)
		if current_time<start_time then
			return tprint_current
		end
		far_i = 1
		for i=1, #text do
				if start_time + per_char_delay * (i - 1) <= current_time then
						far_i = i
				end
		end
		if tprint_current_i != far_i then
				tprint_current_i = far_i
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
		return tprint_current_i
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
		-- force 30fps draw
		if stat(7) == 60 then
			--0x4300 is our on/off flag
			-- for 30fps drawing
			poke(0x4300, @0x4300^^1)
			if @0x4300 == 1 then
				return
			end
		end

		-- setup
		local dt = demotime()
		local st = scenetime()
		for i=0,15 do
			pal(i,i,1)
		end
		-- et == music time
		et = st*1.677
		--et=t()*(60/(9/(120/8))/60)-.03
		if scene_just_entered then
			sst = st
		end
		
		fillp()

		-- empty first pattern~
		-- this helps sync on the
		-- web player, since it can
		-- take a lil bit for that
		-- to start fully
		sc = -1
		if current_scene == sc then
				-- do nothing
		end
		
		-- names
		sc += 1
		if current_scene == sc then
			if scene_just_entered then
				continue_scene=0
				title_i=0
				author_i=0
				titlec_i=0
				authorc_i=0
			end
	
			cls()
			title_i = tprint("new1 demo", title_i, sst, st, 0.06, 8, 1, 110, 8)
			author_i = tprint(" pixienop ∧ gruber", author_i, sst+.2, st, 0.06, 8, 1, 116, 8)
			titlec_i = tprint("█████", titlec_i, sst+2, st, 0.06, 8, 1, 110, 0)
			authorc_i = tprint(" ████ █ ███", authorc_i, sst+2.2, st, 0.06, 8, 1, 116, 0)
		end
		
		-- ship
		sc += 1
		if current_scene == sc then
			if scene_just_entered then
				continue_scene=5
				aa=-1
			end
			aa+=1
			
			-- zoom in transition
			if st<2 then
				camera(-128+min(128, st*st*350))
			end

			-- bg
			srand(st)
			if min(.9, (st-3)/5) < rnd() then
			fillp(rnd(0b1111111111111111))
			rectfill(0,0,127,127,0)
			fillp()
			end
			
			-- paralax stars
			srand()
			for i=0,120 do
				x = (rnd(400)-st*50) % 400
				y = rnd(128)
				pset(x,y,5)
			end
			for i=0,100 do
				x = (rnd(500)-st*100) % 500
				y = rnd(128)
				pset(x,y,6)
			end
			for i=0,140 do
				x = (rnd(1000)-st*270) % 1000
				y = rnd(128)
				pset(x,y,7)
			end
			
			-- pew pew
			for i=0,3 do
				speed = 1+rnd()
				x = (rnd(1000)+st*270*speed) % 1000
				y = rnd(128)
				line(x,y,x+10*speed,y,8)
			end
			
			-- ship
			x = 25+sin(st/4)*5
			y = 64+sin(st/3)*20+cos(st/2)*8
			ovalfill(x-3+max(-1,min(1,sin(st*3)+cos(st*1.5))),y-3,x+3,y+2,12)
			ovalfill(x+sin(st*3+st*1.4),y-1,x+1,y,7)
			spr(1,x,y-8,2,2)
			
			-- big shot
			camera()
			cls()
			pset(aa,1,7)
		end
		
		-- set the final scene num dynamically
		-- so we don't need to stuff around so much
		if scene_just_entered then
				_final_scene = sc
		end
		
		-- resets
		camera(0,0)
		fillp()

		-- print debug info
		if show_debug then
  		color(1)
  		rectfill(0, 0, 24, 24)
  		color(14)
  		print("s:"..current_scene, 1, 1)
  		print(st, 1, 1+6)
  		print("c:"..continue_scene, 1, 1+12)
  		print("et:"..flr(et), 1, 1+18)
  end
		
		if scene_just_entered then
				scene_just_entered = false
		end
		if rs_just_entered then
				rs_just_entered = false
		end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000033333b0822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000001133bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000111133bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000bb22b22bb2bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003bbbbbbbbbb2bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003bbbbbbbbbb2bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000bb22b22bb2bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000111133bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000001133bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000033333b0822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010300000c0500c1500c6540c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300000905015050150500000000000000000000000000100000000000000000000000000000000000000010000000000000000000000000000000000000001000000000000000000000000000000000000000
010b00001100300000000000000000000000000000000000100030000000000000000000000000000000000010003000000000000000000000000000000000001000300000000000000000000000000000000000
010900001105300000000000000000000000000000000000100530000000000000000000000000000000000010053000000000000000000000000000000000001005300000000000000000000000000000000000
__music__
00 07424344
01 09424344
02 0a424344

