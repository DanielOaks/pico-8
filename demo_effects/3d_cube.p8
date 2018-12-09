pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- effect-specific info

-- obj file with newlines replaced with ;'s
cube_obj = "v -0.5 -0.5 -0.5;v 0.5 -0.5 -0.5;v 0.5 -0.5 0.5;v -0.5 -0.5 0.5;v -0.5 0.5 -0.5;v 0.5 0.5 -0.5;v 0.5 0.5 0.5;v -0.5 0.5 0.5;f 2 1 5 6;f 3 2 6 7;f 4 3 7 8;f 1 4 8 5;f 3 4 1 2;f 6 5 8 7;"
cube = {} -- loaded at runtime

function split_string(str, char)
		split = {}
		
		last_i = 1
		newsplit = ""
		for i = 1, #str do
				if sub(str, i, i) == char then
						newsplit = sub(str, last_i, i-1)
						last_i = i+1
				elseif i == #str then
						newsplit = sub(str, last_i)						
				end
				if newsplit != "" then
				 	split[#split+1] = newsplit
				 	newsplit = ""
				end
		end
		
		return split
end

function mesh_from_objstring(obj)
		mesh = {}
		faces = {}
		verts = {}
		
		lines = split_string(obj, ";")
		for _, l in pairs(lines) do
				parts = split_string(l, " ")
				if 0 < #parts then
						if parts[1] == "v" then
								verts[#verts+1] = {
										parts[2]+0.0, parts[3]+0.0, parts[4]+0.0,
								}
						elseif parts[1] == "f" then
								newface = {}
								newface.verts = {
										verts[parts[2]+0],
										verts[parts[3]+0],
										verts[parts[4]+0],
								}
								faces[#faces+1] = newface
  						if #parts == 5 then
  								newface.verts = {
												verts[parts[3]+0],
												verts[parts[4]+0],
												verts[parts[5]+0],
  								}
  								faces[#faces+1] = newface
  						end
						end
				end
		end
		
		mesh.tris = faces
		--todo(dan): work out tri normals

		return mesh
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
		cube = mesh_from_objstring(cube_obj)
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

