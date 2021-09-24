pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- https://twitter.com/theoremnd/status/1308126294815670272

-- start the drawing loop!
::_::
cls()

-- make the first four colours:
--  0,1,2,3
-- a nice pretty gradient
pal(3,8)

-- slow time down a bit
m=t()/2

-- z is how deep into the
-- background these cubes go,
-- and the .4 affects how many
-- cubes exist between the
-- start and end depths
for z=.8,1.6,.4 do
	-- k == colour
	k=z*2
	
	-- j is the y, i is the x.
	-- loops through from top->bottom,
	-- left->right, and draws each
	-- line going back.
	for j=-3,2 do
		for i=-3,2 do
			-- the cos and sin here only
			-- exist to shift the cubes
			-- around in a circle. the
			-- *z+64 is why the cubes
			-- further back are more
			-- affected by the camera
			-- (and end up looking more
			-- stretched!)
			x=8+16*i+cos(m)*16
			y=8+16*j+sin(m)*16
			
			-- closer point
			a=x*z+64
			b=y*z+64
			
			-- further away point
			c=x*(z+.2)+64
			d=y*(z+.2)+64
			
			line(a,b,c,d,k)
			
			-- if we're on the bottom-right
			-- of a cube, then draw the close
			-- and far faces of it
			if(i%2==0 and j%2==0) then
				rect(e,f,a,b,k)
				rect(c,d,g,h,k)
			end
			
			-- remember this column's x points
			-- (so the face-drawing rect's can
			-- refer to them)
			e=a
			g=c
		end
		
		-- remember this row's y points
		-- (so the face-drawing rect's can
		-- refer to them)
		f=b
		h=d
	end
end

-- show this frame on the screen
flip()
goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
