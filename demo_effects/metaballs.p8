pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- effect-specific info

function evalballcol(val)
		col = 1
		if val < 2.5 then
				-- do nothing
		elseif 4.7 < val then
				col = 7
		elseif 3.7 < val then
				col = 14
		else
				col = 13
		end
		return col
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
		r1 = 30
		origin_x = 50 + sin(st*0.6)*20
		origin_y = 60 + cos(st*1.3)*30
		
		r2 = 45
		origin2_x = 70 + sin(st*0.8)*40
		origin2_y = 40 + cos(st*0.75)*40

		calcs = 0
		cls(1)
		
		-- raw method
		--[[
      		for x = 0, 127, 4 do
      				for y = 0, 127, 4 do
      						val = r1 / sqrt( (x+2-origin_x)^2 + (y+2-origin_y)^2 )
      						val += r2 / sqrt( (x+2-origin2_x)^2 + (y+2-origin2_y)^2 )
      						calcs += 1
      						
      						col = 1
      						if val < 2.5 then
      								-- do nothing
      						elseif 4.7 < val then
      								col = 7
      						elseif 3.7 < val then
      								col = 14
      						else
      								col = 13
      						end
      						
      						if col != 1 then
		      						rectfill(x, y, x+3, y+3, col)
		      				end
      				end
      		end
  ]]
  
  -- chunked method
  local userectfill = sin(st*0.05) < 0
  local chunksize = 2
  local psize = 8 + flr(sin(st*0.15)*4.9)
  local psizehalf = psize/2
		for x = 0, 127, psize*chunksize do
				for y = 0, 127, psize*chunksize do
						val = r1 / sqrt( (x+psizehalf-origin_x)^2 + (y+psizehalf-origin_y)^2 )
						val += r2 / sqrt( (x+psizehalf-origin2_x)^2 + (y+psizehalf-origin2_y)^2 )
						calcs += 1
						
						col = evalballcol(val)
						if col != 1 then
								if userectfill then
		  						rectfill(x, y, x+psize-1, y+psize-1, col)
		  				else
		  						rect(x, y, x+psize-1, y+psize-1, col)
		  				end
  				end
						
						-- calculate other chunks
						if 1 < chunksize and 2 < val then
								-- 0,1
								newx = x+1*psize
								newy = y

  						val = r1 / sqrt( (newx+psizehalf-origin_x)^2 + (newy+psizehalf-origin_y)^2 )
  						val += r2 / sqrt( (newx+psizehalf-origin2_x)^2 + (newy+psizehalf-origin2_y)^2 )
  						calcs += 1
  						
  						col = evalballcol(val)
  						if col != 1 then
  								if userectfill then
      						rectfill(newx, newy, newx+psize-1, newy+psize-1, col)
      				else
      						rect(newx, newy, newx+psize-1, newy+psize-1, col)
      				end
    				end

								-- 1,0
								newx = x
								newy = y+1*psize

  						val = r1 / sqrt( (newx+psizehalf-origin_x)^2 + (newy+psizehalf-origin_y)^2 )
  						val += r2 / sqrt( (newx+psizehalf-origin2_x)^2 + (newy+psizehalf-origin2_y)^2 )
  						calcs += 1
  						
  						col = evalballcol(val)
  						if col != 1 then
  								if userectfill then
      						rectfill(newx, newy, newx+psize-1, newy+psize-1, col)
      				else
      						rect(newx, newy, newx+psize-1, newy+psize-1, col)
      				end
    				end

								-- 1,1
								newx = x+1*psize
								newy = y+1*psize

  						val = r1 / sqrt( (newx+psizehalf-origin_x)^2 + (newy+psizehalf-origin_y)^2 )
  						val += r2 / sqrt( (newx+psizehalf-origin2_x)^2 + (newy+psizehalf-origin2_y)^2 )
  						calcs += 1
  						
  						col = evalballcol(val)
  						if col != 1 then
  								if userectfill then
      						rectfill(newx, newy, newx+psize-1, newy+psize-1, col)
      				else
      						rect(newx, newy, newx+psize-1, newy+psize-1, col)
      				end
    				end

						end
				end
		end

		print("calcs", 1, 103, 6)
		print(calcs, 1, 110, 7)
		
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

