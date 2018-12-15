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
--cube_obj = "v -0.5 -0.5 -0.5;v 0.5 -0.5 -0.5;v 0.5 -0.5 0.5;v -0.5 -0.5 0.5;v -0.5 0.5 -0.5;v 0.5 0.5 -0.5;v 0.5 0.5 0.5;v -0.5 0.5 0.5;f 2 1 5 6;f 3 2 6 7;f 4 3 7 8;f 1 4 8 5;f 3 4 1 2;f 6 5 8 7;"
cube_obj = "v 1 -2.6226834e-08 -3.01991605e-07;v 0.623489678 -2.6226834e-08 -0.781831622;v -0.222521007 -2.6226834e-08 -0.974927902;v -0.90096885 -2.6226834e-08 -0.433883756;v -0.900968909 -2.6226834e-08 0.433883607;v -0.222520947 -2.6226834e-08 0.974927902;v 0.623489797 -2.6226834e-08 0.781831503;v 0.887046874 -0.234549493 -2.67880722e-07;v 0.553064585 -0.234549493 -0.693521321;v -0.197386563 -0.234549493 -0.864806771;v -0.799201608 -0.234549493 -0.384875238;v -0.799201667 -0.234549493 0.384875089;v -0.197386518 -0.234549493 0.864806771;v 0.553064704 -0.234549493 0.693521202;v 0.63324368 -0.292478383 -1.91234278e-07;v 0.394820899 -0.292478383 -0.495089948;v -0.140910015 -0.292478383 -0.61736691;v -0.570532858 -0.292478383 -0.274754137;v -0.570532858 -0.292478383 0.274754047;v -0.140909985 -0.292478383 0.61736691;v 0.394820988 -0.292478383 0.495089859;v 0.429709315 -0.13016513 -1.29768608e-07;v 0.267919332 -0.13016513 -0.335960329;v -0.0956193507 -0.13016513 -0.418935597;v -0.387154698 -0.13016513 -0.186443895;v -0.387154728 -0.13016513 0.186443821;v -0.0956193209 -0.13016513 0.418935597;v 0.267919362 -0.13016513 0.335960269;v 0.429709315 0.1301651 -1.29768608e-07;v 0.267919332 0.1301651 -0.335960329;v -0.0956193507 0.1301651 -0.418935597;v -0.387154698 0.1301651 -0.186443895;v -0.387154728 0.1301651 0.186443821;v -0.0956193209 0.1301651 0.418935597;v 0.267919362 0.1301651 0.335960269;v 0.63324362 0.292478353 -1.91234264e-07;v 0.394820869 0.292478353 -0.495089889;v -0.140910015 0.292478353 -0.61736685;v -0.570532799 0.292478353 -0.274754107;v -0.570532799 0.292478353 0.274754018;v -0.14090997 0.292478353 0.61736685;v 0.394820929 0.292478353 0.495089799;v 0.887046874 0.234549507 -2.67880722e-07;v 0.553064585 0.234549507 -0.693521321;v -0.197386563 0.234549507 -0.864806771;v -0.799201608 0.234549507 -0.384875238;v -0.799201667 0.234549507 0.384875089;v -0.197386518 0.234549507 0.864806771;v 0.553064704 0.234549507 0.693521202;g ;f 1 9 2;f 1 8 9;f 2 10 3;f 2 9 10;f 3 11 4;f 3 10 11;f 4 12 5;f 4 11 12;f 5 13 6;f 5 12 13;f 6 14 7;f 6 13 14;f 7 8 1;f 7 14 8;f 8 16 9;f 8 15 16;f 9 17 10;f 9 16 17;f 10 18 11;f 10 17 18;f 11 19 12;f 11 18 19;f 12 20 13;f 12 19 20;f 13 21 14;f 13 20 21;f 14 15 8;f 14 21 15;f 15 23 16;f 15 22 23;f 16 24 17;f 16 23 24;f 17 25 18;f 17 24 25;f 18 26 19;f 18 25 26;f 19 27 20;f 19 26 27;f 20 28 21;f 20 27 28;f 21 22 15;f 21 28 22;f 22 30 23;f 22 29 30;f 23 31 24;f 23 30 31;f 24 32 25;f 24 31 32;f 25 33 26;f 25 32 33;f 26 34 27;f 26 33 34;f 27 35 28;f 27 34 35;f 28 29 22;f 28 35 29;f 29 37 30;f 29 36 37;f 30 38 31;f 30 37 38;f 31 39 32;f 31 38 39;f 32 40 33;f 32 39 40;f 33 41 34;f 33 40 41;f 34 42 35;f 34 41 42;f 35 36 29;f 35 42 36;f 36 44 37;f 36 43 44;f 37 45 38;f 37 44 45;f 38 46 39;f 38 45 46;f 39 47 40;f 39 46 47;f 40 48 41;f 40 47 48;f 41 49 42;f 41 48 49;f 42 43 36;f 42 49 43;f 43 2 44;f 43 1 2;f 44 3 45;f 44 2 3;f 45 4 46;f 45 3 4;f 46 5 47;f 46 4 5;f 47 6 48;f 47 5 6;f 48 7 49;f 48 6 7;f 49 1 43;f 49 7 1;"
cube = {} -- loaded at runtime
obj_z_offset = 2

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

function vec3(x, y, z)
		v = {}
		v.x = x
		v.y = y
		v.z = z
		return v
end

function quat(w, x, y, z)
		q = {}
		q.w = w
		q.x = x
		q.y = y
		q.z = z
		return q
end

-- a is degrees, xyz == axis
function rotating_quat(a, x, y, z)
		-- deg -> rads
		a = a/360 * 3.141592*2

		-- make quaternion
		w = cos(a*0.5)
		sina2 = sin(a*0.5)
		x = x*sina2
		y = y*sina2
		z = z*sina2
		return quat(w, x, y, z)
end

function multiply_quat(q1, q2)
		w = q1.w*q2.w - q1.x*q2.x - q1.y*q2.y - q1.z*q2.z
		x = q1.w*q2.w + q1.x*q2.x + q1.y*q2.y - q1.z*q2.z
		y = q1.w*q2.w - q1.x*q2.x + q1.y*q2.y + q1.z*q2.z
		z = q1.w*q2.w + q1.x*q2.x - q1.y*q2.y + q1.z*q2.z
		return quat(w, x, y, z)
end

function normalize_quat(q)
		magnitude = sqrt(q.w*q.w + q.x*q.x + q.y*q.y + q.z*q.z)
		w = q.w / magnitude
		x = q.x / magnitude
		y = q.y / magnitude
		z = q.z / magnitude
		return quat(w, x, y, z)
end

-- v is a vertex
-- rq is a rotating_quat
_root_rotating_quat = quat(1, 0, 0, 0)
function vert_quat_rotate(v, rq)
		t = multiply_quat(_root_rotating_quat, rq)

		mat_rq = mat4x4()
		mat_rq[1][1] = 1 - 2*(t.y*t.y) - 2*(t.z*t.z)
		mat_rq[1][2] = 2*t.x*t.y + 2*t.w*t.z
		mat_rq[1][3] = 2*t.x*t.z - 2*t.w*t.y
		mat_rq[2][1] = 2*t.x*t.y - 2*t.w*t.z
		mat_rq[2][2] = 1 - 2*(t.x*t.x) - 2*(t.z*t.z)
		mat_rq[2][3] = 2*t.y*t.z - 2*t.w*t.x
		mat_rq[3][1] = 2*t.x*t.z + 2*t.w*t.y
		mat_rq[3][2] = 2*t.y*t.z + 2*t.w*t.x
		mat_rq[3][3] = 1 - 2*(t.x*t.x) - 2*(t.y*t.y)
		mat_rq[4][4] = 1
		
		return multiply_matrix(v, mat_rq)
end

function multiply_quat_tri(t, rq)
		local v1 = vert_quat_rotate(t.verts[1], rq)
		local v2 = vert_quat_rotate(t.verts[2], rq)
		local v3 = vert_quat_rotate(t.verts[3], rq)
		
		return tri(v1, v2, v3, 0)
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
		
		local ftheta = scenetime() * 0.4
		local mat_rot_x = mat4x4()
		mat_rot_x[1][1] = 1
		mat_rot_x[2][2] = cos(ftheta * 0.5)
		mat_rot_x[2][3] = sin(ftheta * 0.5)
		mat_rot_x[3][2] = -sin(ftheta * 0.5)
		mat_rot_x[3][3] = cos(ftheta * 0.5)
		mat_rot_x[4][4] = 1

		local a = sin(scenetime()*0.035) * 50
		local q_rotate_x = rotating_quat(a, 1, 1, 0)
				
		local t
		local t_proj_1
		local t_proj_2
		local t_proj_3
		
		col = 1
		for t_orig in all(cube.tris) do
				-- copy to new triangle
				-- so we can modify it fine
				t = tri()
				for j = 1, 3 do
						t.verts[j] = {t_orig.verts[j][1], t_orig.verts[j][2], t_orig.verts[j][3], t_orig.verts[j][4]}
				end
				
				-- rotate
				--t = multiply_matrix_tri(t, mat_rot_xy)
				--t = multiply_matrix_tri(t, mat_rot_x)
				t = multiply_quat_tri(t, q_rotate_x)
				--t = multiply_matrix_tri(t, mat_rot_y)
				
				-- to world space
				t.verts[1][3] += obj_z_offset
				t.verts[2][3] += obj_z_offset
				t.verts[3][3] += obj_z_offset

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
				color(col)
				line(t.verts[1][1], t.verts[1][2], t.verts[2][1], t.verts[2][2])
				line(t.verts[2][1], t.verts[2][2], t.verts[3][1], t.verts[3][2])
				line(t.verts[3][1], t.verts[3][2], t.verts[1][1], t.verts[1][2])
				
  		col += 1
  		if 15 < col then
  				col = 1
  		end
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

