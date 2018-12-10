pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
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

-->8
-- effect-specific info

-- obj file with newlines replaced with ;'s
cube_obj = "v -0.5 -0.5 -0.5;v 0.5 -0.5 -0.5;v 0.5 -0.5 0.5;v -0.5 -0.5 0.5;v -0.5 0.5 -0.5;v 0.5 0.5 -0.5;v 0.5 0.5 0.5;v -0.5 0.5 0.5;f 2 1 5 6;f 3 2 6 7;f 4 3 7 8;f 1 4 8 5;f 3 4 1 2;f 6 5 8 7;"
cube = {} -- loaded at runtime

render_aspect = 1 -- aspect ratio
render_fov = 90
_render_fov_rad = 1/tan((render_fov * 0.5)/(180*3.141592))
render_znear = 0.1
render_zfar = 1000

function tri(vert1, vert2, vert3, val4)
		local triangle = {}
		triangle.verts = {
				vert1, vert2, vert3, val4,
		}
		return triangle
end

function mat4x4()
		mat = {}
		for i = 1, 4 do
				mat[i] = {0, 0, 0, 0}
		end
		return mat
end

mat_proj = mat4x4()
mat_proj[1][1] = render_aspect * _render_fov_rad
mat_proj[2][2] = _render_fov_rad
mat_proj[3][3] = render_zfar / (render_zfar-render_znear)
mat_proj[4][3] = (-render_zfar * render_znear) / (render_zfar - render_znear)
mat_proj[3][4] = 1
mat_proj[4][4] = 0

mat_screen = mat4x4()
mat_screen[1][1] = 0.5*127
mat_screen[2][2] = 0.5*127
mat_screen[3][3] = 0.5*127
mat_screen[4][4] = 1

function multiply_matrix_tri(t, m)
		local v1 = multiply_matrix(t.verts[1], m)
		local v2 = multiply_matrix(t.verts[2], m)
		local v3 = multiply_matrix(t.verts[3], m)
		
		return tri(v1, v2, v3, 0)
end


function multiply_matrix(v, m)
		local new_x = v[1] * m[1][1] + v[2] * m[2][1] + v[3] * m[3][1] + m[4][1]
		local new_y = v[2] * m[1][2] + v[2] * m[2][2] + v[3] * m[3][2] + m[4][2]
		local new_z = v[3] * m[1][3] + v[2] * m[2][3] + v[3] * m[3][3] + m[4][3]

		local w = v[1] * m[1][4] + v[2] * m[2][4] + v[3] * m[3][4] + m[4][4]

		if w != 0 then
				new_x /= w
				new_y /= w
				new_z /= w
		end
		
		return {new_x, new_y, new_z, w}
end

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
										1,
								}
								faces[#faces+1] = newface
  						if 4 < #parts then
  								newface = {}
  								newface.verts = {
												verts[parts[2]+0],
												verts[parts[4]+0],
												verts[parts[5]+0],
												1,
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
		cls()

		local ftheta = scenetime() * 0.2
		
		local mat_rot_x = mat4x4()
		mat_rot_x[1][1] = 1
		mat_rot_x[2][2] = cos(ftheta * 0.5)
		mat_rot_x[2][3] = sin(ftheta * 0.5)
		mat_rot_x[3][2] = -sin(ftheta * 0.5)
		mat_rot_x[3][3] = cos(ftheta * 0.5)
		mat_rot_x[4][4] = 1
		
		local mat_rot_y = mat4x4()
		mat_rot_y[1][1] = cos(ftheta * 0.5)
		mat_rot_y[1][3] = -sin(ftheta * 0.5)
		mat_rot_y[2][2] = 1
		mat_rot_y[3][1] = sin(ftheta * 0.5)
		mat_rot_y[3][3] = cos(ftheta * 0.5)
		mat_rot_y[4][4] = 1
		
		local mat_rot_xy = mat4x4()
		mat_rot_xy[1][1] = cos(ftheta * 0.5)
		mat_rot_xy[1][3] = -sin(ftheta * 0.5)
		mat_rot_xy[2][2] = cos(ftheta * 0.5)
		mat_rot_xy[2][3] = sin(ftheta * 0.5)
		mat_rot_xy[3][1] = sin(ftheta * 0.5)
		mat_rot_xy[3][2] = -sin(ftheta * 0.5)
		mat_rot_xy[3][3] = cos(ftheta * 0.5)
		mat_rot_xy[4][4] = 1
		
		local t
		local t_proj_1
		local t_proj_2
		local t_proj_3
		for t_orig in all(cube.tris) do
				-- copy to new triangle
				-- so we can modify it fine
				t = tri()
				for j = 1, 3 do
						t.verts[j] = {t_orig.verts[j][1], t_orig.verts[j][2], t_orig.verts[j][3], t_orig.verts[j][4]}
				end
				
				-- rotate
				--t = multiply_matrix_tri(t, mat_rot_xy)
				t = multiply_matrix_tri(t, mat_rot_x)
				--t = multiply_matrix_tri(t, mat_rot_y)
				
				-- to world space
				t.verts[1][3] += 2
				t.verts[2][3] += 2
				t.verts[3][3] += 2

				-- to view space
				t = multiply_matrix_tri(t, mat_proj)
				t.verts[1][1] /= t.verts[1][4];t.verts[1][2] /= t.verts[1][4];t.verts[1][3] /= t.verts[1][4];
				t.verts[2][1] /= t.verts[2][4];t.verts[2][2] /= t.verts[2][4];t.verts[2][3] /= t.verts[2][4];
				t.verts[3][1] /= t.verts[3][4];t.verts[3][2] /= t.verts[3][4];t.verts[3][3] /= t.verts[3][4];
				
				-- to screen space
				t.verts[1][1] += 1; t.verts[1][2] += 1
				t.verts[2][1] += 1; t.verts[2][2] += 1
				t.verts[3][1] += 1; t.verts[3][2] += 1
				t = multiply_matrix_tri(t, mat_screen)
				
				-- draw eet
				color(7)
				line(t.verts[1][1], t.verts[1][2], t.verts[2][1], t.verts[2][2])
				line(t.verts[2][1], t.verts[2][2], t.verts[3][1], t.verts[3][2])
				line(t.verts[3][1], t.verts[3][2], t.verts[1][1], t.verts[1][2])
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

