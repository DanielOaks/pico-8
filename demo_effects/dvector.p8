pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- basics

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

-- tris
function tri(vert1, vert2, vert3)
		local triangle = {}
		triangle.verts = {
				vert1, vert2, vert3
		}
		return triangle
end
-->8
-- vectors
-- vec3 and vec4 used under cc0
--  from https://github.com/barerose/dvector

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
-- mat4 used under cc0
--  from https://github.com/barerose/dvector
function mat4zero()
		return mat4(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
end

function mat4(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33)
		m = {
				{m00, m01, m02, m03},
				{m10, m11, m12, m13},
				{m20, m21, m22, m23},
				{m30, m31, m32, m33},
		}
		return m
end

function mat4multiplyvector(m, v)
		x = m[1][1]*v.x + m[1][2]*v.y + m[1][3]*v.z + m[1][4]*v.w
		y = m[2][1]*v.x + m[2][2]*v.y + m[2][3]*v.z + m[2][4]*v.w
		z = m[3][1]*v.x + m[3][2]*v.y + m[3][3]*v.z + m[3][4]*v.w
		w = m[4][1]*v.x + m[4][2]*v.y + m[4][3]*v.z + m[4][4]*v.w
		return vec4(x, y, z, w)
end

function mat4setrotationx(r)
		c = cos(r)
		s = sin(r)
		return mat4(1, 0, 0, 0, 0, c, s, 0, 0, -s, c, 0, 0, 0, 0, 1)
end

function mat4setrotationy(r)
		c = cos(r)
		s = sin(r)
  return mat4(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1)
end

function mat4setrotationz(r)
		c = cos(r)
		s = sin(r)
		return mat4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
end

function mat4setrotationquaternion(q)
		xx = q.x*q.x
		xy = q.x*q.y
		xz = q.x*q.z
		xw = q.x*q.w
		yy = q.y*q.y
		yz = q.y*q.z
		yw = q.y*q.w
		zz = q.z*q.z
		zw = q.z*q.w
		return mat4(1-2*yy-2*zz, 2*xy+2*zw, 2*xz-2*yw, 0, 2*xy-2*zw, 1-2*xx-2*zz, 2*yz+2*xw, 0, 2*xz+2*yw, 2*yz-2*xw, 1-2*xx-2*yy, 0, 0, 0, 0, 1)
end

function mat4setscale(s)
		return mat4(s, 0, 0, 0, 0, s, 0, 0, 0, 0, s, 0, 0, 0, 0, 1)
end

function mat4setscalexyz(v)
		return mat4(v.x, 0, 0, 0, 0, v.y, 0, 0, 0, 0, v.z, 0, 0, 0, 0, 1)
end

function mat4settranslation(v)
		return mat4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, v.x, v.y, v.z, 1)
end

function mat4lookat(from, to, up)
		f = vec3normalize(vec3subtract(to, from))
		s = vec3normalize(vec3crossproduct(f, up))
		t = vec3crossproduct(s, f)
		m = mat4(s.x, t.x, -f.x, 0, s.y, t.y, -f.y, 0, s.z, t.z, -f.z, 0, 0, 0, 0, 1)
		for i = 1, 4 do
				m.m[4][i] = -vec3dotproduct(vec3(m.m[1][i], m.m[2][i], m.m[3][i]), from)
		end
		return m
end

function mat4perspective(vfov, aspect, ndist, fdist)
		a = 1/tan(vfov/2)
		return mat4(a/aspect, 0, 0, 0, 0, a, 0, 0, 0, 0, -((fdist+ndist)/(fdist-ndist)), -1, 0, 0, -((2*fdist*ndist)/(fdist-ndist)), 0)
end

function mat4ortho(left, right, bottom, top, ndist, fdist)
  return mat4(2/(right-left), 0, 0, 0, 0, 2/(top-bottom), 0, 0, 0, 0, -2/(fdist-ndist), 0, -(right+left)/(right-left), -(top+bottom)/(top-bottom), -(fdist+ndist)/(fdist-ndist), 1)
end

function mat4transpose(m)
		return mat4(m[1][1], m[2][1], m[3][1], m[4][1], m[1][2], m[2][2], m[3][2], m[4][2], m[1][3], m[2][3], m[3][3], m[4][3], m[1][4], m[2][4], m[3][4], m[4][4])
end

-- mat4inverse not transferred lol

function mat4multiplyscalar(m, s)
		new_m = mat4()
		for i = 1, 4 do
				for j = 1, 4 do
						new_m[i][j] = m[i][j] * s
				end
		end
		return new_m
end

function mat4rotatex(m, r)
		return mat4multiplymatrix(mat4setrotationx(r), m)
end

function mat4rotatey(m, r)
		return mat4multiplymatrix(mat4setrotationy(r), m)
end

function mat4rotatez(m, r)
		return mat4multiplymatrix(mat4setrotationz(r), m)
end

function mat4rotatequaternion(m, q)
		return mat4multiplymatrix(mat4setrotationquaternion(q), m)
end

function mat4scale(m, s)
		return mat4multiplymatrix(mat4setscale(s), m)
end

function mat4scalexyz(m, v)
		return mat4multiplymatrix(mat4setscalexyz(v), m)
end

function mat4translate(m, v)
		return mat4multiplymatrix(mat4settranslation(v), m)
end

function mat4multiplymatrix(m1, m2)
		m = mat4()
		for i = 1, 4 do
				for j = 1, 4 do
						m[i][j] = m1[1][j]*m2[i][1] + m1[2][j]*m2[i][2] + m1[3][j]*m2[i][3] + m1[4][j]*m2[i][4]
				end
		end
		return m
end

function mat4add(m1, m2)
		m = mat4()
		for i = 1, 4 do
				for j = 1, 4 do
						m[i][j] = m1[i][j] + m2[i][j]
				end
		end
		return m
end

function mat4subtract(m1, m2)
		m = mat4()
		for i = 1, 4 do
				for j = 1, 4 do
						m[i][j] = m1[i][j] - m2[i][j]
				end
		end
		return m
end

function mat4equal(m1, m2)
		for i = 1, 4 do
				for j = 1, 4 do
						if m1[i][j] != m2[i][j] then
								return false
						end
				end
		end
		return true
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

