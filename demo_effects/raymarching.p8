pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- vectors
-- vec3 and vec4 used under cc0
--  from https://github.com/barerose/dvector


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


-- vec3
function vec3(x, y, z)
		v = {}
		v.x = x
		v.y = y
		v.z = z
		return v
end

function vec3length(v)
		return hypot(hypot(v.x, v.y), v.z)
end

function vec3dotproduct(v1, v2)
		return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
end

function vec3negate(v)
		return vec3(-v.x, -v.y, -v.z)
end

function vec3normalize(v)
		return vec3divide(v, vec3length(v))
end

function vec3multiply(v, s)
		return vec3(v.x*s, v.y*s, v.z*s)
end

function vec3divide(v, s)
		return vec3(v.x/s, v.y/s, v.z/s)
end

function vec3add(v1, v2)
		return vec3(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z)
end

function vec3subtract(v1, v2)
		return vec3(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z)
end

function vec3reflect(v1, v2)
		return vec3subtract(v1, vec3multiply(v2, 2*vec3dotproduct(v1, v2)))
end

function vec3crossproduct(v1, v2)
		return vec3(v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x)
end

function vec3mix(v1, v2, s)
		return vec3(v1.x+(v2.x-v1.x)*s, v1.y+(v2.y-v1.y)*s, v1.z+(v2.z-v1.z)*s)
end

function vec3equal(v1, v2)
		return (v1.x == v2.x)and(v1.y == v2.y)and(v1.z == v2.z)
end

-- vec4
function vec4(x, y, z, w)
		v = {}
		v.x = x
		v.y = y
		v.z = z
		v.w = w
		return v
end

function vec4length(v)
		return hypot(hypot(v.x, v.y), hypot(v.z, v.w))
end

function vec4dotproduct(v1, v2)
		return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z + v1.w*v2.w
end

function vec4negate(v)
		return vec4(-v.x, -v.y, -v.z, -v.w)
end

function vec4normalize(v)
		return vec4divide(v, vec4length(v))
end

function vec4multiply(v, s)
		return vec4(v.x*s, v.y*s, v.z*s, v.w*s)
end

function vec4divide(v, s)
		return vec4(v.x/s, v.y/s, v.z/s, v.w/s)
end

function vec4add(v1, v2)
		return vec4(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z, v1.w+v2.w)
end

function vec4subtract(v1, v2)
		return vec4(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z, v1.w-v2.w)
end

function vec4reflect(v1, v2)
		return vec4subtract(v1, vec4multiply(v2, 2*vec4dotproduct(v1, v2)))
end

function vec4mix(v1, v2, s)
		return vec4(v1.x+(v2.x-v1.x)*s, v1.y+(v2.y-v1.y)*s, v1.z+(v2.z-v1.z)*s, v1.w+(v2.w-v1.w)*s)
end

function vec4equal(v1, v2)
		return (v1.x == v2.x)and(v1.y == v2.y)and(v1.z == v2.z)and(v1.w == v2.w)
end

-->8
-- effect-specific info
local max_steps = 100
local max_dist = 100
local surf_dist = 0.01
local e = vec2(0.1, 0)


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

