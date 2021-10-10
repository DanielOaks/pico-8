pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _draw()
	st=t()

	-- black bg
	--cls(0)
	srand(st)
	
	if min(9.9, st/5) < rnd() then
	fillp(rnd(0b1111111111111111))
	rectfill(0,0,127,127,0)
	fillp()
	end
	
	-- paralax stars
	srand()
	for i=0,120 do
		x = (rnd(400)-st*50) % 400
		y = rnd(128)
		pset(x,y,5)
	end
	for i=0,100 do
		x = (rnd(500)-st*100) % 500
		y = rnd(128)
		pset(x,y,6)
	end
	for i=0,140 do
		x = (rnd(1000)-st*270) % 1000
		y = rnd(128)
		pset(x,y,7)
	end
	
	-- ship
	x = 25+sin(st/4)*5
	y = 64+sin(st/3)*20+cos(st/2)*8
	ovalfill(x-3+max(-1,min(1,sin(st*3)+cos(st*1.5))),y-3,x+3,y+2,12)
	ovalfill(x+sin(st*3+st*1.4),y-1,x+1,y,7)
	spr(1,x,y-8,2,2)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000033333b0822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000001133bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000111133bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000bb22b22bb2bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003bbbbbbbbbb2bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003bbbbbbbbbb2bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000bb22b22bb2bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000111133bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000001133bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000033333b0822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000