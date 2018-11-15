pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
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
		if scene_just_entered then
				
		end
		
		if scene_just_entered then
				scene_just_entered = false
		end
end
