pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- effect-specific info
ssrs = {}
ssr_num = 200
ssr_cam_last={0,0,0}
ssr_change={0,0,0}
ssr_maxz=100
ssr_cols={7,6,13,5,2,1}

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

function ssr_genpos(st)
		return {
			sin(st*.2)*127,
			cos(st*.1)*256,
			sin(st*.3)*14+cos(st*.1)*50
		}
end

function ssr_actualpos(x,y,z)
 -- depth hackery
 x-=64
 y-=64
 
 x*=(ssr_maxz-z)*.05
 y*=(ssr_maxz-z)*.05
 
 x+=64
 y+=64
	return {x,y}
end

function _update()
		local st = scenetime()

		-- start
		if btnp(4) then
				show_debug = not show_debug
		end

		-- effect-update stuff
		if scene_just_entered then
		 ssr_cam_last=ssr_genpos(st)
		end
		new_cam=ssr_genpos(st)
		for i=1,3 do
			ssr_change[i]=new_cam[i]-ssr_cam_last[i]
		end
		ssr_cam_last=new_cam
		
		while #ssrs < ssr_num do
			local sx=rnd(127)
			local sy=rnd(127)
			local sz=rnd(ssr_maxz)
			sx=((sx-64)*(sz/ssr_maxz))+64
			ssrs[#ssrs+1] = {
				sx,
				sy,
				sz
			}
		end
end

function _draw()
		-- start
		local st = scenetime()
		local dt = demotime()

		-- do your effect here
		cls()
		new_ssrs={}
		for i=1,#ssrs do
			s=ssrs[i]
			sx=s[1]+ssr_change[1]
		 sy=s[2]+ssr_change[2]
		 sz=s[3]+ssr_change[3]
			spos=ssr_actualpos(sx,sy,sz)
			ssx=spos[1]
			ssy=spos[2]
		 if 0<sz and sz<ssr_maxz and 0<=ssx and ssx<128 and 0<=ssy and ssy<128 then
			 sc=ssr_cols[flr(((ssr_maxz-sz)/ssr_maxz)*#ssr_cols+1)]
				pset(ssx,ssy,sc)
				new_ssrs[#new_ssrs+1] = {sx,sy,sz}
			end
		end
		ssrs=new_ssrs
		
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

