pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- extra info
rb_width = 3
rb_width_mod = rb_width / -2 -- helps centre things
rb_phase = 0.03
rb_rainbow_pattern = {
		8,9,10,11,3,12,13,2,14
		--8,9,10,3,1,2,14,
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
		
		cls()

		--print()
		
		for i = 1, #rb_rainbow_pattern, 1 do
 		local x1 = flr(cos((st / 2)-(rb_phase*i))*50) + 60
 		if flr(((st-(rb_phase*i)) + 0.5) % 2) == 1 then
   		color(rb_rainbow_pattern[i])
   		--rectfill(x1+rb_width_mod, 0, x1+rb_width+rb_width_mod, 128)
   		
   		rectfill(x1+rb_width_mod, 68+cos((st / 2)+0.25-(rb_phase*i))*60, x1+rb_width+rb_width_mod, 128)
   end
		end

		for i = #rb_rainbow_pattern, 1, -1 do
 		local x1 = flr(cos((st / 2)-(rb_phase*i))*50) + 60
 		if flr(((st-(rb_phase*i)) + 0.5) % 2) == 0 then
   		color(rb_rainbow_pattern[i])
   		--rectfill(x1+rb_width_mod, 0, x1+rb_width+rb_width_mod, 128)
   		
   		rectfill(x1+rb_width_mod, 68+cos((st / 2)+0.25-(rb_phase*i))*60, x1+rb_width+rb_width_mod, 128)
   end
		end		
		if scene_just_entered then
				scene_just_entered = false
		end
end
