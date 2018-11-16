pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- extra info
stxt_text = "this is an example"
stxt_start_x = 128 -- will depend on trig used
stxt_char_width = 4
stxt_x = 0
stxt_y = 100
stxt_speed = 1
stext_amplitude = 4
stext_phase = 0.05
stxt_colors = {
		--8, 14, 12, 3,
		--8,9,10,11,3,12,13,2,14,
		8,9,10,3,12,2,14,
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
		stxt_x -= stxt_speed
end

function _draw()
		local st = scenetime()

		if scene_just_entered then
				stxt_x = stxt_start_x
		end
		
		cls()
		
		color(1)
		rectfill(0, 0, 128, 128)
		color(7)

		-- restart text scrolling
		local x_add = 0
		while stxt_x + stxt_char_width * (#stxt_text + 1) + x_add < 0 do
				x_add += stxt_start_x + stxt_char_width * (#stxt_text + 1)
		end

		local c = 1 -- colour
		local char = ""
		for i = 1, #stxt_text, 1 do
				color(stxt_colors[c])
				char = sub(stxt_text, i, i)
				print(char,
					(stxt_x + stxt_char_width*i) + x_add,
					stxt_y + sin(st + i * stext_phase) * stext_amplitude)
				
				if char != " " then
  				c += 1
  				if #stxt_colors < c then
  						c = 1
  				end
  		end
		end

		if scene_just_entered then
				scene_just_entered = false
		end
end
