pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
_pal={129,131,135,10,138,11,139,3}
for i,c in pairs(_pal) do
	pal(i-1,c,1)
end

::w::
cls()
st=t()

for x=0,127,2 do
for y=0,127,3 do
line(x,y,x,y+1,sin(x*.02+st)*cos(y*.03*sin(st*.5))*(#_pal/2-0.1)+(#_pal/2)+1)
end
end

print(stat(2),1,1,7)

flip()
goto w
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
