pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- https://twitter.com/jordi_ros/status/1364879169272885248

cls()
poke(24364,7)

for i=0,6 do
	pal(i,({0,2,136,137,9,10,7})[i+1],1)
end

-- start rendering loop
::_::

-- draw 350 smal circles per loop
for i=0,350 do
	x=rnd(64)
	y=rnd(64)
	j=0
	n=20+20*cos(t()/2)
	for k=0,5 do
		m=k/6
		a=64-x+n*sin(m)b=64-y+n*cos(m)
		if (sqrt(a*a+b*b)<52) then
			j+=1
		end
	end
	circfill(x,y,j/6+1,j)
end

flip()goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000