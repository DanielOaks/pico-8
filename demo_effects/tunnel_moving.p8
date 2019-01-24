pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- effect-specific info
tunnel_rainbow_pattern = {
		8,9,10,11,3,12,13,2,14,
		8,9,10,11,3,12,13,2,14,
}
tunnel_resetbase = 0


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
		cls(0)
		tmodsize_min = 3
		tmodsize_max = 140
		tmodsize_diff = tmodsize_max - tmodsize_min
		tmodscale_max = 2.5
		tmodsteps = 100
		col_steps = 100
		col_speed = 40

		for i = 0, tmodsteps do
				mod = i / tmodsteps

				thist = st - tmodscale_max * mod
				tun_x = 75 + sin(thist) * 20 + cos(thist*0.2)*20
				tun_y = 65 + cos(thist*0.4) * 30

				col = ((#tunnel_rainbow_pattern*0.5 * mod))
				col = tunnel_rainbow_pattern[1 + flr(col)]
				
				size = tmodsize_min + tmodsize_diff*mod
				
				circ(tun_x-1, tun_y-1, size, col)
				circ(tun_x+1, tun_y+1, size, col)
				circ(tun_x, tun_y, size, col)
		end		
		
		--[[cls(1)
		local tmodsteps = 150
		local tmodscale = 0.0001
		local tcolspeed = 35
		for t = 0, tmodsteps do
				local tmod = t * tmodsteps * tmodscale
				local tunnel_x = 70 + sin((st-tmod)*0.3)*30 + cos((st-tmod)*0.35)*14
				local tunnel_y = 70 + cos((st-tmod)*0.3)*20 + sin((st-tmod)*0.6)*17
				local tunnel_size = 3 + (t * tmodsteps * tmodscale) * 80
				
				local val = abs(sin(st*0.4-t*tmodscale*tcolspeed))
				val *= #tunnel_rainbow_pattern-1
				local col = tunnel_rainbow_pattern[flr(val)+1]

				pset(tunnel_x, tunnel_y, 7)
				circ(tunnel_x, tunnel_y, tunnel_size, col)
				circ(tunnel_x, tunnel_y, tunnel_size-1, col)
				circ(tunnel_x, tunnel_y, tunnel_size+1, col)
		end]]
		
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

