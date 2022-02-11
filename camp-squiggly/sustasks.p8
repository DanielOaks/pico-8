pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
game = 1
lastgame = 2
on_menu = true

music(0)

function _update()
	if on_menu then
		if btnp(🅾️) then
			on_menu = false
		end
		return
	end

	if game == 1 then
		update_wires()
	elseif game == 2 then
		update_counting()
	end
	
	if btnp(❎) then
		game += 1
	end
	if game > lastgame then
		game = 1
	end
end

function _draw()
	cls(1)
	crect(5,6)
	crect(7,13)
	
	if on_menu then
		print("-= sustasks =-",35,41,5)
		print("   sustasks",35,41,0)
		print("a collection of familiar",16,52,1)
		print(" one-button games.",16,59,1)
		print("press    or   to play.",16,73,1)
		print("      🅾️    z",16,73,7)
		print("press    or   to try",16,83,1)
		print("      ❎    x",16,83,7)
		print(" the next game.",16,90,1)
		
		-- amogus
		spr(1,25,113)
		pal(8,10,0)
		spr(1,40,113)
		pal(8,0,0)
		spr(1,15,113)
		pal(8,2,0)
		spr(1,95,113)
		pal(8,7,0)
		spr(1,80,113)
		pal()
		return
	end
	
	if game == 1 then
		draw_wires()
	elseif game == 2 then
		draw_counting()
	end

	print("sustasks",47,11,1)
	print("wins:"..wins,27,112)
	print("resets:"..resets,70,112)
	
	print("🅾️/z to play",2,0,7)
	print("❎/x changes game",59,0,7)
end
-->8
-- wires
wchars = {"🐱","♥","♪","★"}
wcols = {3,8,1,10}
wiremap = {{},{}}
wpos = {
	{{30,27},{30,52},{30,77},{30,102}},
	{{97,27},{97,52},{97,77},{97,102}},
}
wcompleted = {false,false,false,false}
wtrying = 1
wtarget = 2
wins = 0
resets = 0

function wreset()
	wiremap = {{},{}}
	wtrying = 1
	wcompleted = {false,false,false,false}
end

function mappos(y,w)
	for x=1,4 do
		if wiremap[y][x] == w then
			return x
		end
	end
end

function update_wires()
	for s=1,2 do
		while #wiremap[s] < 4 do
			new = flr(rnd(4)+1)
			if wiremap[s][1]==new or
						wiremap[s][2]==new or
						wiremap[s][3]==new or
						wiremap[s][4]==new then
			else
				wiremap[s][#wiremap[s]+1] = new
			end
		end
	end

	wtarget = flr(time()*2%4)+1

	if btnp(🅾️) then
		if wiremap[1][wtrying] == wiremap[2][wtarget] then
			wcompleted[wiremap[1][wtrying]] = true
			wtrying += 1
			if wtrying > 4 then
				wins += 1
				wreset()
			end
			sfx(8)
		else
			sfx(9)
			resets += 1
			wreset()
		end
	end
end

function draw_wires()
	ysep=25
	x=96
	
	for y=0,3 do
		rectfill(20,25+y*ysep,107,29+y*ysep,5)
	end
	rectfill(30,20,127-30,107,13)
	for xsep=0,1 do
		for y=0,3 do
			rectfill(7+xsep*x,22+y*ysep,24+xsep*x,32+y*ysep,6)
			if #wiremap[1] != 0 then
				for s=1,2 do
					for a=1,4 do
						val=wiremap[s][a]
						print(wchars[val],14+(s-1)*93,a*25,wcols[val])
					end
				end
			end
		end
	end
	
	for w=1,4 do
		if wcompleted[w] then
			l=wpos[1][mappos(1,w)]
			r=wpos[2][mappos(2,w)]
			line(l[1],l[2],r[1],r[2],wcols[w])
		end
	end
	if wtrying != 0 and wtarget != 0 then
		l=wpos[1][wtrying]
		r=wpos[2][wtarget]
		line(l[1],l[2],r[1]-3,r[2],wcols[wiremap[1][wtrying]])
	end
	
	-- amogus
	spr(1,12,113)
	pal(8,10,0)
	spr(1,6,113)
	pal(8,0,0)
	spr(1,110,89)
	pal(8,2,0)
	spr(1,17,39)
	pal(8,7,0)
	spr(1,9,14)
	pal()
end
-->8
-- helpers

function crect(r, c)
	rectfill(r,r,127-r,127-r,c)
end
-->8
-- counting
cmap = {}
ccompleted = {false,false,false,false,false,false,false,false,false}
ccurrent = 0
ctarget = 1

function creset()
	cmap = {}
	ccompleted = {false,false,false,false,false,false,false,false,false}
	ccurrent = 0
end

bw=20
bh=20
function cbox(x,y,num,selected,completed)
	w=bw
	h=bh
	bc=6
	if selected then
		bc=11
	end
	fc=5
	if completed then
		fc=3
	end
	rectfill(x,y,x+w,y+h,bc)
	rectfill(x+1,y+1,x+w-1,y+h-1,fc)
	if num != nil then
		print(num,x+w/2-1,y+h/2-2,7)
	end
end

function update_counting()
	ctarget = flr(time()*2%9)+1

	while #cmap < 9 do
		new = flr(rnd(9)+1)
		if cmap[1]==new or
					cmap[2]==new or
					cmap[3]==new or
					cmap[4]==new or
					cmap[5]==new or
					cmap[6]==new or
					cmap[7]==new or
					cmap[8]==new then
		else
			cmap[#cmap+1] = new
		end
	end

	if btnp(🅾️) then
		if cmap[ctarget] == ccurrent+1 then
			ccompleted[cmap[ctarget]] = true
			ccurrent += 1
			if ccurrent == 9 then
				wins += 1
				creset()
			end
			sfx(8)
		else
			resets += 1
			creset()
			sfx(9)
		end
	end
end

function draw_counting()
	for i=0,8 do
		cbox(29+24*(i%3),29+24*flr(i/3),cmap[i+1],ctarget == i+1,ccompleted[cmap[i+1]])
	end

	-- amogus
	spr(1,12,113)
	pal(8,10,0)
	spr(1,6,113)
	pal()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666611111
11111666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddddddddddddddddddddddddddddddddddd00d0d0dd00d000d000dd00d0d0dd00ddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddd555ddddd0ddd0d0d0dddd0dd0d0d0ddd0d0d0ddddddd555ddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddd555ddddddddd000d0d0d000dd0dd000d000d00dd000ddddddddd555ddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddd555ddddddd0d0d0ddd0dd0dd0d0ddd0d0d0ddd0ddddd555ddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddd00ddd00d00ddd0dd0d0d00dd0d0d00dddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddd111dddddd11dd11d1ddd1ddd111dd11d111d111dd11d11ddddddd11d111ddddd111d111d111d111d1ddd111d111d111dddddddddd6611111
1111166ddddddddd1d1ddddd1ddd1d1d1ddd1ddd1ddd1dddd1ddd1dd1d1d1d1ddddd1d1d1ddddddd1ddd1d1d111dd1dd1dddd1dd1d1d1d1dddddddddd6611111
1111166ddddddddd111ddddd1ddd1d1d1ddd1ddd11dd1dddd1ddd1dd1d1d1d1ddddd1d1d11dddddd11dd111d1d1dd1dd1dddd1dd111d11ddddddddddd6611111
1111166ddddddddd1d1ddddd1ddd1d1d1ddd1ddd1ddd1dddd1ddd1dd1d1d1d1ddddd1d1d1ddddddd1ddd1d1d1d1dd1dd1dddd1dd1d1d1d1dddddddddd6611111
1111166ddddddddd1d1dddddd11d11dd111d111d111dd11dd1dd111d11dd1d1ddddd11dd1ddddddd1ddd1d1d1d1d111d111d111d1d1d1d1dddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddd11d11dd111ddddd111d1d1d111d111dd11d11ddddddd11d111d111d111dd11dddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddddddd1d1d1d1d1ddddddd1d1d1d1dd1ddd1dd1d1d1d1ddddd1ddd1d1d111d1ddd1dddddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddddddd1d1d1d1d11dd111d11dd1d1dd1ddd1dd1d1d1d1ddddd1ddd111d1d1d11dd111dddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddddddd1d1d1d1d1ddddddd1d1d1d1dd1ddd1dd1d1d1d1ddddd1d1d1d1d1d1d1ddddd1dddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddddddd11dd1d1d111ddddd111dd11dd1ddd1dd11dd1d1ddddd111d1d1d1d1d111d11ddd1ddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddd111d111d111dd11dd11dddddd77777ddddddd11d111ddddd777ddddd111dd11ddddd111d1ddd111d1d1dddddddddddddddddddddd6611111
1111166ddddddddd1d1d1d1d1ddd1ddd1ddddddd77ddd77ddddd1d1d1d1ddddddd7dddddd1dd1d1ddddd1d1d1ddd1d1d1d1dddddddddddddddddddddd6611111
1111166ddddddddd111d11dd11dd111d111ddddd77d7d77ddddd1d1d11ddddddd7ddddddd1dd1d1ddddd111d1ddd111d111dddddddddddddddddddddd6611111
1111166ddddddddd1ddd1d1d1ddddd1ddd1ddddd77ddd77ddddd1d1d1d1ddddd7dddddddd1dd1d1ddddd1ddd1ddd1d1ddd1dddddddddddddddddddddd6611111
1111166ddddddddd1ddd1d1d111d11dd11ddddddd77777dddddd11dd1d1ddddd777dddddd1dd11dddddd1ddd111d1d1d111dd1ddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddd111d111d111dd11dd11dddddd77777ddddddd11d111ddddd7d7ddddd111dd11ddddd111d111d1d1dddddddddddddddddddddddddd6611111
1111166ddddddddd1d1d1d1d1ddd1ddd1ddddddd77d7d77ddddd1d1d1d1ddddd7d7dddddd1dd1d1dddddd1dd1d1d1d1dddddddddddddddddddddddddd6611111
1111166ddddddddd111d11dd11dd111d111ddddd777d777ddddd1d1d11ddddddd7ddddddd1dd1d1dddddd1dd11dd111dddddddddddddddddddddddddd6611111
1111166ddddddddd1ddd1d1d1ddddd1ddd1ddddd77d7d77ddddd1d1d1d1ddddd7d7dddddd1dd1d1dddddd1dd1d1ddd1dddddddddddddddddddddddddd6611111
1111166ddddddddd1ddd1d1d111d11dd11ddddddd77777dddddd11dd1d1ddddd7d7dddddd1dd11ddddddd1dd1d1d111dddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddddddd111d1d1d111ddddd11dd111d1d1d111dddddd11d111d111d111dddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddd1dd1d1d1ddddddd1d1d1ddd1d1dd1dddddd1ddd1d1d111d1dddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddd1dd111d11dddddd1d1d11ddd1ddd1dddddd1ddd111d1d1d11ddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddd1dd1d1d1ddddddd1d1d1ddd1d1dd1dddddd1d1d1d1d1d1d1dddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddd1dd1d1d111ddddd1d1d111d1d1dd1dddddd111d1d1d1d1d111dd1ddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd6611111
1111166ddddddddddd00dddddddd88dddddddddddddaadddddddddddddddddddddddddddddddddddddd77ddddddddddddd22ddddddddddddddddddddd6611111
1111166dddddddddd0000dddddd8888dddddddddddaaaadddddddddddddddddddddddddddddddddddd7777ddddddddddd2222dddddddddddddddddddd6611111
1111166dddddddddd6666dddddd6666ddddddddddd6666dddddddddddddddddddddddddddddddddddd6666ddddddddddd6666dddddddddddddddddddd6611111
1111166dddddddddd6666dddddd6666ddddddddddd6666dddddddddddddddddddddddddddddddddddd6666ddddddddddd6666dddddddddddddddddddd6611111
1111166dddddddddd0000dddddd8888dddddddddddaaaadddddddddddddddddddddddddddddddddddd7777ddddddddddd2222dddddddddddddddddddd6611111
1111166dddddddddd0000dddddd8888dddddddddddaaaadddddddddddddddddddddddddddddddddddd7777ddddddddddd2222dddddddddddddddddddd6611111
1111166dddddddddd0dd0dddddd8dd8dddddddddddaddadddddddddddddddddddddddddddddddddddd7dd7ddddddddddd2dd2dddddddddddddddddddd6611111
11111666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666611111
11111666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666611111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
490b00000c63018360183500c30100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090b00000c63000360002500c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
911000000c6110c6110c6110c6110c6200c6210c6110c6210c6210c6210c6100c6210c6210c6110c6200c6100c6110c6110c6200c6200c6100c6210c6110c6210c6210c6210c6110c6210c6210c6100c6210c611
a910000000050000500005000050000500c050000500005018050000500c050000500c050000501805000050000500005000050000500c05024050180500c0500c0500005000050000500c05018051180520c050
031000001815000000181501811018100181100000018110000000c110000000c110000000c110000000c1501a2101c3200000013150131201315013120000001c110111101d1100e1500e1200e150131300c150
__music__
03 0a0b0c44

