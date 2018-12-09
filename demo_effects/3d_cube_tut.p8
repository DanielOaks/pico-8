pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- default demo stuff
function tan(a)
		return sin(a)/cos(a)
end

-- effect-specific info
render_aspect = 1 -- aspect ratio

render_fov = 60
_render_fov_rad = 1/tan((render_fov * 0.5)/(180*3.141592))

render_znear = 0.1
render_zfar = 1000
--_render_zscale = render_zfar / (render_zfar-render_znear)
--_render_offset = (-(render_zfar * render_znear)) / (render_zfar - render_znear)

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

function multiply_matrix_tri(t, m)
		local v1 = multiply_matrix(t.vecs[1], m)
		local v2 = multiply_matrix(t.vecs[2], m)
		local v3 = multiply_matrix(t.vecs[3], m)
		
		return tri(v1, v2, v3)
end

function multiply_matrix(v, m)
		local new_x = v.x * m[1][1] + v.y * m[2][1] + v.z * m[3][1] + m[4][1]
		local new_y = v.y * m[1][2] + v.y * m[2][2] + v.z * m[3][2] + m[4][2]
		local new_z = v.z * m[1][3] + v.y * m[2][3] + v.z * m[3][3] + m[4][3]

		local w = v.x * m[1][4] + v.y * m[2][4] + v.z * m[3][4] + m[4][4]

		if w != 0 then
				new_x /= w
				new_y /= w
				new_z /= w
		end
		
		return vec3d(new_x, new_y, new_z)		
end

function vec3d(x, y, z)
		local vec = {}
		vec.x = x
		vec.y = y
		vec.z = z
		return vec
end

function tri(vec1, vec2, vec3)
		local triangle = {}
		triangle.vecs = {
				vec1, vec2, vec3
		}
		return triangle
end

function mesh(tris)
		local msh = {}
		msh.tris = {}
		if tris != nil then
				msh.tris = tris
		end
		return msh
end

meshcube = mesh({
		-- south
		tri(vec3d(0,0,0), vec3d(0,1,0), vec3d(1,1,0)),
		tri(vec3d(0,0,0), vec3d(1,1,0), vec3d(1,0,0)),
		-- east
		tri(vec3d(1,0,0), vec3d(1,1,0), vec3d(1,1,1)),
		tri(vec3d(1,0,0), vec3d(1,1,1), vec3d(1,0,1)),
		-- north
		tri(vec3d(1,0,1), vec3d(1,1,1), vec3d(0,1,1)),
		tri(vec3d(1,0,1), vec3d(0,1,1), vec3d(0,0,1)),
		-- west
		tri(vec3d(0,0,1), vec3d(0,1,1), vec3d(0,1,0)),
		tri(vec3d(0,0,1), vec3d(0,1,0), vec3d(0,0,0)),
		-- top
		tri(vec3d(0,1,0), vec3d(0,1,1), vec3d(1,1,1)),
		tri(vec3d(0,1,0), vec3d(1,1,1), vec3d(1,1,0)),
		-- bottom
		tri(vec3d(1,0,1), vec3d(0,0,1), vec3d(0,0,0)),
		tri(vec3d(1,0,1), vec3d(0,0,0), vec3d(1,0,0)),
})


-- default demo stuff
show_debug = false

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
		cls()
		
		-- draw tris lol
		local ftheta = scenetime() * 0.2

		local mat_rot_z = mat4x4()
		mat_rot_z[1][1] = cos(ftheta)
		mat_rot_z[1][2] = sin(ftheta)
		mat_rot_z[2][1] = -sin(ftheta)
		mat_rot_z[2][2] = cos(ftheta)
		mat_rot_z[3][3] = 1
		mat_rot_z[4][4] = 1

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
		
		local t
		local t_orig
		local t_proj_1
		local t_proj_2
		local t_proj_3
		for i = 1, #meshcube.tris do
				t_orig = meshcube.tris[i]
				
				-- translate cube
				t = tri()
				for j = 1, 3 do
						t.vecs[j] = vec3d(t_orig.vecs[j].x, t_orig.vecs[j].y, t_orig.vecs[j].z)
				end
				
				--t = multiply_matrix_tri(t, mat_rot_z)
				t = multiply_matrix_tri(t, mat_rot_x)
				--t = multiply_matrix_tri(t, mat_rot_y)
				
				-- away from screen
				t.vecs[1].z += 5
				t.vecs[2].z += 5
				t.vecs[3].z += 5
				
				-- transform (project) tri verticies
				t1 = multiply_matrix(t.vecs[1], mat_proj)
				t2 = multiply_matrix(t.vecs[2], mat_proj)
				t3 = multiply_matrix(t.vecs[3], mat_proj)
				
				-- convert
				
				t1.x += 1; t1.y += 1
				t2.x += 1; t2.y += 1
				t3.x += 1; t3.y += 1
				
				t1.x *= 0.5 * 127; t1.y *= 0.5 * 127
				t2.x *= 0.5 * 127; t2.y *= 0.5 * 127
				t3.x *= 0.5 * 127; t3.y *= 0.5 * 127

				-- draw
				color(i)
				line(t1.x, t1.y, t2.x, t2.y)
				line(t2.x, t2.y, t3.x, t3.y)
				line(t3.x, t3.y, t1.x, t1.y)
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

