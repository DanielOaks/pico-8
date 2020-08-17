pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


function _init()

end

function _draw()
		cls(1)
		
		width = 17
		midl = 128/2
		sep = 16
		a = sin(time()*.65)
		if a < 0 then
				color(6)
		else
				color(8)
		end
		circfill(midl-sep, 50, width)
		circfill(midl+sep, 50, width)
		circfill(midl, 86, 3)
		rectfill(midl-2, 56, midl+2, 60)
		for y = 60, 86 do
				line(midl-sep-width+3+(y-60), y, midl+sep+width-3-(y-60), y)
		end
end
