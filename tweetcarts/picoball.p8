pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
fc={8,7}
cols={3,4,8,9,10,11,12}

rows=9
columns=3
bx=64
by=64
r=50.9

function dist2d(x1,y1,x2,y2)
	return sqrt((x1-x2)^2+(y1-y2)^2)
end

function asin(y)
 return atan2(sqrt(1-y*y),-y)
end

cls(1)
for x=bx-r,bx+r do
	for y=by-r,by+r do
		d=dist2d(bx,by,x,y)
		--[[dd=(d/r)^3
		xx=(x-(bx-r))/(r*2)
		yy=(y-(by-r))/(r*2)
		row=ceil((yy*4)^1.6)
--		row=(flr(yy*rows)*(#cols/2)-rows/2)
		col=cols[flr((xx*columns*#cols+row*(rows/2))%#cols+1)]
]]
		col=8
		
		uvx=(bx-x)/r
		uvy=(by-y)/r
		row=ceil(uvx*abs(uvx*1.9)*rows-.5)
		col=ceil(uvy*abs(uvy*1.9)*abs(uvy*1.2)*columns)
		ex=uvy*7
		if uvx<0 then
			ex*=-1
		end
		if uvy<0 then
			ex*=-1
		end
		--row+=ex

		if d<r then
			pset(x,y,cols[flr((row+col*(#cols/2))%#cols+1)])
		end
	end
end

::w::
st=t()

for i=1,#cols do
	pal(cols[i],fc[flr((i*.3+st*5)%#fc+1)],1)
end

--[[for x=bx-r,bx+r do
	for y=by-r,by+r do
		d=dist2d(bx,by,x,y)
		angle=asin(abs(y-by)/d)
		
		xx=(x-(bx-r))/(r*2)
		xuv=(xx-.5)*2
		
		yy=(y-(by-r))/(r*2)
		yuv=(yy-.5)*2

		if xuv<=0 then
			angle=angle*-1
		end
		if yuv<0 then
			angle=angle*-1
		end
		
		nd=(d/r)^2
		
		col=cols[flr((nd)*#cols%#cols+1)]
		
		if d<=r then
			pset(x,y,col)
		end
	end
end]]

rectfill(0,0,40,5,1)
print(stat(1),0,0,7)


flip()goto w
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
