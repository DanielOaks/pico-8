pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- effect-specific info

function frac(x)
		return x - abs(x)
end


-- default demo stuff
show_debug = false

function tan(a)
		return sin(a)/cos(a)
end

function demotime()
		return time()
end

function scenetime()
		return time()
end

scene_just_entered = true

function _init()

end

function _update()
		-- start
		if btnp(4) then
				show_debug = not show_debug
		end

		-- effect-update stuff
		
end

function _draw()
		-- start
		local st = scenetime()
		local dt = demotime()

		-- do your effect here
		cls()
		
		print("wave functions~", 68, 1, 13)
		color(7)
		
		-- sine
		local ybase = 1
		local diff = 17
		
		line(0,5 + ybase,127,5 + ybase)
		line(0,15 + ybase,127,15 + ybase)
		local ymid = ybase + 10.5
		local yrange = 3.4
		print("sine", 1, ybase, 12)
		for x = 0, 127 do
				pset(x, ymid + sin(st + x/10)*yrange, 12)
		end
		color(7)
		
		-- cos
		ybase += diff
		
		line(0,5 + ybase,127,5 + ybase)
		line(0,15 + ybase,127,15 + ybase)
		local ymid = ybase + 10.5
		local yrange = 3.4
		print("cos", 1, ybase, 3)
		for x = 0, 127 do
				pset(x, ymid + cos(st + x/10)*yrange, 3)
		end
		color(7)
		
		-- saw
		ybase += diff
		
		line(0,5 + ybase,127,5 + ybase)
		line(0,15 + ybase,127,15 + ybase)
		local ymid = ybase + 10.5
		local yrange = 3.4
		print("saw", 1, ybase, 8)
		for x = 0, 127 do
				local thisx = x/10
				pset(x, ymid + yrange * (((thisx+st)%1)*2-1), 8)
		end
		color(7)
		
		-- square
		ybase += diff
		
		line(0,5 + ybase,127,5 + ybase)
		line(0,15 + ybase,127,15 + ybase)
		local ymid = ybase + 10.5
		local yrange = 3.4
		print("square", 1, ybase, 14)
		for x = 0, 127 do
				local thisx = x/10
				local res = 1
				if sin(thisx+st) < 0 then
						res = -1
				end
				pset(x, ymid + yrange * res, 14)
		end
		color(7)
		
		-- triangle
		ybase += diff

		line(0,5 + ybase,127,5 + ybase)
		line(0,15 + ybase,127,15 + ybase)
		local ymid = ybase + 10.5
		local yrange = 3.4
		print("triangle", 1, ybase, 10)
		for x = 0, 127 do
				local thisx = x*0.5
				pset(x, ymid + yrange*(((abs(((thisx+st*4.75)%6)-3)/3)-0.5)*2), 10)
		end
		color(7)
		
		
		-- end
		if show_debug then
  		-- print scene time lol
  		color(1)
  		rectfill(103, 0, 128, 12)
  		rectfill(0, 0, 40, 18)
  		
  		color(14)
  		print("tmplte", 104, 1)
  		print(st, 104, 1+6)

  		color(7)
  		print("cpu:" .. stat(1), 1, 1)
  		print("    " .. stat(2), 1, 1+6)
  		print("fps:" .. stat(7) .. "/" .. stat(8), 1, 1+6+6)
  end

		if scene_just_entered then
				scene_just_entered = false
		end
end

