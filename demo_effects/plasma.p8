pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- extra info
plasma_colours = {
		--1, 2, 8, 14, 4, 3, 1
		2, 1, 1, 1, 2, 1, 3, 3
}


-- default demo stuff
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

end

function _draw()
		local st = scenetime()

		if scene_just_entered then
				
		end
		
		-- plasma function
		color(1)
		rectfill(0, 0, 127, 127)
		local result = 0
		local colcount = #plasma_colours
		local sinst = sin(st)
		for x = 0, 127 do
				for y = 0, 127 do
						--result += sin((y * 0.01) + st * 0.1)
						--result += sin((sin(x*0.004) + cos(y*0.004)) * st * 0.25)
						--result += sin((x/127) + (y/256) + st*0.1)
						--cx = x + 0.5 * sin(st*78)
						--cy = y + 0.5 * sin(st*4)
						--result += sin(sqrt(10 * ((cx ^ 2) + (cy ^ 2)) + st * 50.3)*0.005)
						if x % 3 == 0 and y % 4 == 0 then
								result = sin(st+(x+(y*sin((x*0.005)*st*0.7)*0.7))*0.02)
								result += sin((y * 0.01) + sinst * 0.1)
								result += cos((x-30*sinst*0.15)*y*sinst*0.00002)
								result /= 3
								result = (result*0.5+0.5)*colcount+1
								result = min(colcount, max(1, flr(result)))
						
								pset(x, y, plasma_colours[result])
						end
				end
		end
		
		color(7)
		print("plasma", 1, 1)
		print("t_cpu: " .. stat(1), 1, 8)
		print("s_cpu: " .. stat(2), 1, 8+7)
		print("  fps: " .. stat(7) .. "/" .. stat(8), 1, 8+7+7)
		
		-- back to your regularly-coded template
		if scene_just_entered then
				scene_just_entered = false
		end
end
