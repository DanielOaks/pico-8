pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
c={12,14,7,14,12}
e="transvisibilityweek♥  ♥   ♥ ♥   ♥"
::w::
srand()
r=t()*5
cls()
for j=0,5 do
for k=0,5 do
print(sub(e,j+k*5,j+k*5),(k*40+rnd(8)-r*5)%310,(j-1)*27+rnd(9)+sin(r/9+j/5)*5,c[j])
end
for i=0,200 do
pset((i*33-r*rnd(50))%128,j*27+i*.15-30,c[j])
end
end
flip()goto w
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
