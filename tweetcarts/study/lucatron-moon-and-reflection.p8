pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- moon and reflection study
-- luca harris
-- https://twitter.com/lucatron_/status/1111025092236959744
--
-- pixienop study

-- black night sky
cls(0)

-- the moon
circfill(30,22,15,7)

::_::
flip()

-- re-initialize the random
--  seed each loop so that rnd
--  calls below will keep the
--  same value
-- we do this because we use
--  rnd() in a loop from top
--  to bottom of the water to
--  decide various things
srand()

-- cls() only the sea
rectfill(0,50,127,127,0)

-- loop from y=50 to y=127
--  (the draw calls below use
--  y+50 everywhere)
for y=0,77 do
	-- how wide the reflection
	--  lines at this level are
	-- in the distance they're
	--  super short, and they get
	--  longer as they come closer
	-- 77 -> 0, ~exponentially
	z=77/(y+1)
	
	-- z*8 random lines per y
	--
	-- some of these overlap and
	--  are going different speeds,
	--  helps sell the shifting
	--  water effect
	for i=0,z*8 do
		
		-- x position of this line
		--
		-- rnd(160) is the base speed,
		--  because we always seed
		--  using srand above this
		--  stays the same for each
		--  line (better than storing
		--  the rnd values w/a table)
		-- t()*150/z just makes it
		--  move, /z means slower
		--  near the horizon
		-- %160 means that it'll loop
		--  back to 0 once it hits
		--  160, each line just loops~
		-- -16 so that rather than
		--  the full lines popping in
		--  on the left, they slide
		--  into the frame nicely
		x=(rnd(160)+t()*150/z)%160-16
		
		-- the width of the line,
		--  standard random-ish cos
		--  that's smaller towards
		--  the horizon
		w=cos(rnd()+t())*12/z
		
		-- only draw when the width
		--  is over zero, fun~
		if (w>0) then
			-- max(1,pget(x,49-y/2)
			--  means that the colour
			--  will always either be 1
			--  (water) or the grabbed
			--  pixel colour from top
			-- note: the 'reflection' of
			--  the black sky is really
			--  just the lines not
			--  filling in the rectfill
			--  from above
			--
			-- because x is random and
			--  the line is the same
			--  colour the whole way
			--  through, it creates real
			--  interesting shimmery
			--  reflections. this only
			--  looks good because the
			--  x-w and x+y means the
			--  colour is grabbed from
			--  the middle of the line
			line(x-w,y+50,x+w,y+50,max(1,pget(x,49-y/2)))
		end
	end
end

goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
