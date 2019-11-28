pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function srr(st,x,y,r)
	srand(flr(st)+x*6+y*70)
	return rnd(r)
end
::w::
st=t()*1.5
xi=50
yi=50
w=25+sin(st/7)*3.9
h=20+cos(st/7)*2.9
xcam=-64+sin(st/15)*63.9
ycam=-64+cos(st/20)*63.9

cls()

e=max(0,min(((st-flr(st))*7)^2,1-((st-flr(st))*1.4)^2))

color(5)
colo=6
rndex=0
for i=0,min(st/2,2) do
	for x=-1,xi do
		i11=0
		for y=-1,yi,2 do
			-- confirm we're on screen in x
			i41=xcam+x*w+w+w/2+srr(st,x+1,y+1,9.9)*e
			if 0<=i41 then
				-- confirm in y
				i52=ycam+y*h+h+h+srr(st,y+2+rndex,x,9.9)*e
				i62=ycam+y*h+h+h+srr(st,y+2+rndex,x+1,9.9)*e
				if 0<=i52 and 0<=i62 then
					i11=xcam+x*w+srr(st,x,y+rndex,9.9)*e
					i12=ycam+y*h+srr(st,y+rndex,x,9.9)*e
					i21=xcam+x*w+w+srr(st,x+1,y+rndex,9.9)*e
					i22=ycam+y*h+srr(st,y+rndex,x+1,9.9)*e
					i31=xcam+x*w+w/2+srr(st,x,y+1+rndex,9.9)*e
					i32=ycam+y*h+h+srr(st,y+1+rndex,x,9.9)*e
					i42=ycam+y*h+h+srr(st,y+1+rndex,x+1,9.9)*e
					i51=xcam+x*w+srr(st,x,y+2+rndex,9.9)*e
					i61=xcam+x*w+w+srr(st,x+1,y+2+rndex,9.9)*e
					line(i11,i12,i21,i22)
					line(i11,i12,i31,i32)
					line(i31,i32,i21,i22)
					line(i31,i32,i41,i42)
					line(i31,i32,i51,i52)
					line(i31,i32,i61,i62)
					if 127<i12 then
						break
					end
				end
			end
		end
		if 127<i11 then
			break
		end
	end
	color(colo)
	colo+=1
	rndex+=.1
end

--print(stat(1),0,0,8)

flip()goto w
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
