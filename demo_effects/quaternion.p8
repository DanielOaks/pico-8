pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
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



