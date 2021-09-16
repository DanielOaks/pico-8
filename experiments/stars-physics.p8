pico-8 cartridge // http://www.pico-8.com
version 22
__lua__
points = {}

for i=0,50 do
	x=rnd(256)-64
	y=rnd(256)-64
	weight = flr(rnd(5))
	xd=rnd(10)-5
	yd=rnd(10)-5
	
	points[#points+1] = {
		x,y,weight,xd,yd
	}
end

function _update()
	for i=1,#points do
		info=points[i]
		
		for j=1,#points do
			if i!=j then
				dx=abs(info[1]-points[j][1])
				dy=abs(info[1]-points[j][1])
				dist = 0.394*(dx+dy) + 0.554*max(dx,dy)
			end
		end

		info[1]+=info[4]
		info[2]+=info[5]
		points[i] = info
	end
end

function _draw()
	cls()
	
	for i=1,#points do
		info=points[i]
		c=1
		if 4 < info[3] then
			c=7
		elseif 3 < info[3] then
			c=6
		elseif 2 < info[3] then
			c=5
		end
		pset(info[1],info[2],c)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000