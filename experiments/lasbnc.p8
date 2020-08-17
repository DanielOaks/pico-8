pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- dvector 2d
-- vec2 used under cc0
--  from https://github.com/barerose/dvector

-- math
function hypot(a, b)
		return sqrt(a*a + b*b)
end

function acos(a)
		return -cos(a)
end

function tan(a)
		return sin(a)/cos(a)
end

-- vec2
function vec2(x, y)
		v = {}
		v.x = x
		v.y = y
		return v
end

function vec2length(v)
		return hypot(v.x, v.y)
end

function vec2dotproduct(v1, v2)
		return v1.x*v2.x + v1.y*v2.y
end

function vec2negate(v)
		return vec2(-v.x, -v.y)
end

function vec2normalize(v)
		return vec2divide(v, vec2length(v))
end

function vec2multiply(v, s)
		return vec2(v.x*s, v.y*s)
end

function vec2divide(v, s)
		return vec2(v.x/s, v.y/s)
end

function vec2rotate(v, r)
		local c = cos(r)
		local s = sin(r)
		return vec2(v.x/c - v.y*s, x.y*c + v.x*s)
end

function vec2rotatexz(v, r)
		local c = cos(r)
		local s = sin(r)
		return vec2(v.x/c + v.y*s, x.y*c - v.x*s)
end

function vec2add(v1, v2)
		return vec2(v1.x+v2.x, v1.y+v2.y)
end

function vec2subtract(v1, v2)
		return vec2(v1.x-v2.x, v1.y-v2.y)
end

function vec2reflect(v1, v2)
		return vec2subtract(v1, vec2multiply(v2, 2*vec2dotproduct(v1, v2)))
end

function vec2mix(v1, v2, s)
		return vec2(v1.x+(v2.x-v1.x)*s, v1.y+(v2.y-v1.y)*s)
end

function vec2equal(v1, v2)
		return (v1.x == v2.x)and(v1.y == v2.y)
end



-->8
-- laser bouncing game
-- written by pixienop 2019

walls_in = 17

-- pos, direction
laser = {}
laser[1] = vec2(50, 50)
laser[2] = vec2(1, -1)

function _init()
end

function _update()
		laser[2] = vec2normalize(vec2(-cos(st), sin(st)))
end

function _draw()
		-- bg
		cls(1)
		
		-- top and bottom bounds
		rectfill(0, 0, 127, walls_in, 7)
		rectfill(0, 128, 127, 128-walls_in, 7)

		-- draw laser in segments
		-- with reflections
		lx = laser[1].x
		ly = laser[1].y
		ld = vec2(laser[2].x, laser[2].y)
		
		-- raymarching
  march_dist = vec2(0, 0)
  st = t() * 0.25
		while true do
   	if ld.x < 0 then
   			march_dist.x = lx
   	else
   			march_dist.x = 127 - lx
   	end
  		
  		if ld.y < 0 then
  				march_dist.y = ly - (128 - walls_in)
  		else
  				march_dist.y = walls_in+1 - ly
  		end
  		
  		-- draw
  		dist = min(march_dist.x, march_dist.y)
  		ldc = vec2multiply(ld, dist)
  		line(lx, ly, lx+ldc.x, ly+ldc.y, 8)
  		
  		lx += ldc.x
  		ly += ldc.y
  		
  		-- reflect
  		if dist < 1 then
    		if march_dist.x < march_dist.y then
    				ld.x = -ld.x
    		else
    				ld.y = -ld.y
    		end
    end
  		
  		if ldc.x < 1 or lx < 0 or 127 < lx then 
  				break
  		end
		end
end
