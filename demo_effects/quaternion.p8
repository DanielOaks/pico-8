pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- vecs and tris
-- vec3 and vec4 used under cc0
--  from https://github.com/barerose/dvector

function tri(vert1, vert2, vert3)
		local triangle = {}
		triangle.verts = {
				vert1, vert2, vert3
		}
		return triangle
end

function hypot(a, b)
		return sqrt(a*a + b*b)
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
-- matrices
function mat4x4()
		mat = {}
		for i = 1, 4 do
				mat[i] = {0, 0, 0, 0}
		end
		return mat
end

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

-->8
-- quaternions
-- quat used under cc0
--  from https://github.com/barerose/dvector
function quat(x, y, z, w)
		q = {}
		q.x = x
		q.y = y
		q.z = z
		q.w = w
		return q
end

function quatxyz(q)
		return vec3(q.x, q.y, q.z)
end

function quatmultiplyvector(q, v)
		t = vec3multiply(vec3crossproduct(quatxyz(q), v), 2)
		return vec3add(vec3add(v, vec3multiply(t, q.w)), vec3crossproduct(quatxyz(q), t))
end

function quataxisangle(a, r)
		s = sin(r/2)
		return quat(a.x*s, a.y*s, a.z*s, cos(r/2))
end

function quateulerxyz(a, b, c)
		return quatmultiply(quataxisangle(vec3(0, 0, 1), c), quatmultiply(quataxisangle(vec3(0, 1, 0), b), quataxisangle(vec3(1, 0, 0), a)))
end

function quateulerxzy(a, b, c)
		return quatmultiply(quataxisangle(vec3(0, 1, 0), c), quatmultiply(quataxisangle(vec3(0, 0, 1), b), quataxisangle(vec3(1, 0, 0), a)))
end

function quateuleryxz(a, b, c)
		return quatmultiply(quataxisangle(vec3(0, 0, 1), c), quatmultiply(quataxisangle(vec3(1, 0, 0), b), quataxisangle(vec3(0, 1, 0), a)))
end

function quateuleryzx(a, b, c)
		return quatmultiply(quataxisangle(vec3(1, 0, 0), c), quatmultiply(quataxisangle(vec3(0, 0, 1), b), quataxisangle(vec3(0, 1, 0), a)))
end

function quateulerzxy(a, b, c)
		return quatmultiply(quataxisangle(vec3(0, 1, 0), c), quatmultiply(quataxisangle(vec3(1, 0, 0), b), quataxisangle(vec3(0, 0, 1), a)))
end

function quateulerzyx(a, b, c)
		return quatmultiply(quataxisangle(vec3(1, 0, 0), c), quatmultiply(quataxisangle(vec3(0, 1, 0), b), quataxisangle(vec3(0, 0, 1), a)))
end

function quatnormalize(q)
		return vec4normalize(q)
end

function quatconjugate(q)
		return quat(-q.x, -q.y, -q.z, q.w)
end

function quatlerp(q1, q2, s)
		return quatnormalize(quat((1-s)*q1.x + s*q2.x, (1-s)*q1.y + s*q2.y, (1-s)*q1.z + s*q2.z, (1-s)*q1.w + s*q2.w))
end

function quatslerp(q1, q2, s)
		th = acos(q1.x*q2.x + q1.y*q2.y + q1.z*q2.z + q1.w*q2.w)
		sn = sin(th)
		wa = sin((1-s)*th)/sn
		wb = sin(s*th)/sn
		return quatnormalize(quat(wa*q1.x + wb*q2.x, wa*q1.y + wb*q2.y, wa*q1.z + wb*q2.z, wa*q1.w + wb*q2.w))
end

function quatmultiply(q1, q2)
		return quat(q1.x*q2.w + q1.y*q2.z - q1.z*q2.y + q1.w*q2.x, -q1.x*q2.z + q1.y*q2.w + q1.z*q2.x + q1.w*q2.y, q1.x*q2.y - q1.y*q2.x + q1.z*q2.w + q1.w*q2.z, -q1.x*q2.x - q1.y*q2.y - q1.z*q2.z + q1.w*q2.w)
end

function quatequal(q1, q2)
		return vec4equal(q1, q2)
end



