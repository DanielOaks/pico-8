pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- https://twitter.com/lucatron_/status/1203444384357683200

cls()

::_::

for i=0,1600 do
	if(i<15) then
		pal(i,({0,128,130,2,136,8,142,137,9,10,135,7})[i+1],1)
	end
	x=rnd(128)
	y=rnd(128)
	a=atan2(x-64,y-64)+.17
	d=rnd(7)
	pset(x+cos(a)*d,y+sin(a)*d/3-cos(a)*d/4,max(0,pget(x,y)+.87-rnd()))
end
circfill(64,64,5,11)

flip()
goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
