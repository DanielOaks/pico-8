pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
_p={0,14,8,136,2,130,141,135,138,11,139,3,131}for i,c in pairs(_p)do
pal(i-1,c,1)end::w::st=t()cls(0)for x=0,127 do
for y=0,60+sin(x/70+st)*13+cos(st/2+x/58)*15,2 do
k=(x/3+y/6+sin(st+x/50+y/30)*5+cos(st+x/100)*3.5)%6+1pset(x,y,k)pset(127-x,127-y,k+6)end
end
flip()goto w
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
