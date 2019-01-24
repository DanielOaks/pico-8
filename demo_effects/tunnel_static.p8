pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- extra info
tun_speed = 0.3
tun_radius = 70
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
		tun_2_angle_mod += tun_2_angle_mod_phase
		if 1 < tun_2_angle_mod then
				tun_2_angle_mod -= 1
		end
end

function _draw()
		local st = scenetime()

		if scene_just_entered then
				
		end
		
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

		if scene_just_entered then
				scene_just_entered = false
		end
end
