pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- michal rostocki
-- "blue vertigo"
-- https://twitter.com/von_rostock/status/1220430044054663168
--
-- amazing blue-green tunnel
-- pixienop study

-- typical 0101,1010 fill
fillp(23130)

::_::

-- loop through every radius
--  from 16,128
for r=16,128 do
	-- nice colour ramp
	--  -num is short way to
	--  do the secret palette
	pal(r%6,({-15,1,-13,-4,12,6,7})[r%6],1)

	-- time, offset per where in
	--  the tunnel we're currently
	--  drawing. deeper in tunnel
	--  is future in time
	j=16/r+t()/8
	
	-- x centre of tunnel
	p=64+r/4*cos(j)
	-- y centre of tunnel
	q=64+r/4*sin(j)
	
	-- black centre circle
	--  circ() ignores when r<0
	circ(p,q,30-r,0)
	
	-- g,h == x,y points for the
	--  initial line segment below
	g,h=p+r,q
	
	-- loop 0->1 on each radius
	--  from middle to outside
	--  of the tunnel
	for u=0,1,r/1600 do
		w=sin(u)
		
		-- k == the plasma for this
		--  line seg. of the tunnel
		--
		-- abs(sin(u*3+j+sin(j))-w)
		--  is a typical plasma
		--  pattern, throw sin/cos on
		--  top of each other til it
		--  looks good~
		-- `u` is where we are around
		--  the circle so the u*3
		--  affects how many separate
		--  'tentacles' we have.
		-- `j` is time relative to
		--  how deep in the tunnel we
		--  are.
		--
		-- *min(r/20,3) because the
		--  pattern gets more vibrant
		--  (the brighter colours are
		--  added) as the tunnel gets
		--  closer to the camera
		k=abs(sin(u*3+j+sin(j))-w)*min(r/20,3)

		-- l == current radius of the
		--  tunnel, this changes
		--  based on the plasma value
		--  and is why the brighter
		--  colours stick out towards
		--  the centre of the tunnel,
		--  while the darker colours
		--  sink into the walls
		l=r+k

		-- centre of the tunnel +
		-- 	_current_ radius * cos(u)
		x=p+l*cos(u)
		-- centre of the tunnel +
		-- 	_current_ radius * sin(u)
		y=q+w*l
		
		-- draw this line segment lol
		line(g,h,x,y,k+flr(k+.5)*16)
		
		-- draw from this line
		--  segment to the next~
		g,h=x,y
	end
end

-- since this goes to 130% cpu
--  use, no need to use flip :d

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
