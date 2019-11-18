pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- effect-specific info
rbd_speed=50
rbd_w=14
rbd_text="pico-8!! ♥ "
rbd_scenes=3
nst_rm=0
old_rbdscene=0

_pal={7,6,13,5,135,139,3,131,12,140,1,129,137,8,136,0}
for i,c in pairs(_pal) do
        pal(i-1,c,1)
end
c={0,1,2,3,4,5,6,7,8,9,10,11,4,12,13,14}


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
		xm=sin(st*.24)*7.9
		ym=sin(st*.21)*7.9
		rbd_w=10+sin(st*.7)*5.9+cos(st*.4)+5.8
		
		for y=0,127 do
			if (flr(y+st*rbd_speed)%3) == 0 then
				rectfill(0,y,127,y+2,y+st*rbd_speed)
			end
		end
		clip(rbd_w+xm,rbd_w+ym,127-rbd_w*2,127-rbd_w*2)
		rectfill(0,0,127,127,11)
		
		-- do all your stuff here
		sc=flr(st/6)
		while rbd_scenes<=sc do
			sc-=rbd_scenes
		end
		if sc != old_rbdscene then
			nst_rm=st
		end
		nst=st-nst_rm
		if sc==0 then
			mst=st*.4
			for i=1,nst+1 do
				cx=sin(mst*.4)*64+cos(mst)*12
				cy=sin(mst*.35)*64+sin(mst*.8)*18
				for i=1,#c do
					mst-=.03
					line(64+cx,64+cy,64+cx+sin(mst)*150,64+cy+cos(mst)*150,c[i])
					if i%4==0 then
						mst-=.12
					end
				end
			end

			for i=1,#rbd_text do
				print(sub(rbd_text,i,i),rbd_w+xm+1+i*4,rbd_w+ym+5+sin(st-i*.1)*1.9,st*(#rbd_text-i))
			end
		elseif sc==1 then
			rectfill(0,0,127,127,-st)
			for x=rbd_w+xm,128-rbd_w+xm do
				for y=rbd_w+ym,128-rbd_w+ym,2 do
					pset(x,y,x+y-st*60+cos(x*.05)*3+sin(y*.02+st/3)*3.9)
				end
			end
		elseif sc==2 then
			rectfill(0,0,128,128,0)
			tst=st/2
			cs=((1+t()*.9)%1)*(#c/2)
			for i=1,250 do
				tst -= .001+sin(st/5)*.003
				cx=64+sin(tst)*30
				cy=64+cos(tst)*30
				circ(cx,cy,i/2,c[flr(#c/2+(i/250)*(#c/2)-cs)+1])
			end
		end
		
		clip()
		
		hi="pixienop @ siggraph-asia-2019"
		for i=1,#hi do
			print(sub(hi,i,i),7+i*5+sin(st*.2)*50+cos(st*.43)*4+sin(st+i*.2)*1,120+cos(st+i*.2)*1.9+2-abs(sin(st*.7))*5.9,sin(st/2))
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

