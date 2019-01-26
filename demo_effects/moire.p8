pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- effect-specific info
moire_cols = {
		{8, 9, 10},
		{12, 13, 14},
		{14, 2, 8},
		{4, 15, 7},
}


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
		local origin_x = 50 + sin(st*0.6)*20
		local origin_y = 60 + cos(st*0.3)*30
		
		local origin2_x = 70 + sin(st*0.8)*40
		local origin2_y = 40 + cos(st*0.75)*40

		cls(1)
		
		local mmod = 0.03 + sin(st*0.3)*0.02
		local mlim = 0.2 + sin(st*0.3)*0.15
		for x = 0, 127, 4 do
				for y = 0, 127, 4 do
						local val1 = sqrt((x+2-origin_x)^2 + (y+2-origin_y)^2)
						local val2 = sqrt((x+2-origin2_x)^2 + (y+2-origin2_y)^2)

						local val1mod = sin(val1*mmod)
						local val2mod = sin(val2*mmod)
						
						local col = 1
						local col_chosen = flr(((cos(st*0.1)+1)*0.49) * #moire_cols + 1)
						if mlim < val1mod and mlim < val2mod then
								col = moire_cols[col_chosen][2]
						elseif mlim < val1mod then
								col = moire_cols[col_chosen][3]
						elseif mlim < val2mod then
								col = moire_cols[col_chosen][1]
						end
						
						if col != 1 then
  						rectfill(x, y, x+3, y+3, col)
  				end
				end
		end

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

