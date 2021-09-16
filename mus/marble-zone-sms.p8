pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
music(0)

::w::
st=t()
cls(12)
function yo(i);return 80-sin(st*.8+i*.005)*20.9;end
sx=40+flr(sin(st*.4)*25.8)
for i=0,30 do;x=20+i*10+((i+st)%1)*-60;y=yo(x);circ(x,y-10,3,10);end
rectfill(0,0,sx,127,12)
for x=0,127 do;y=yo(x);line(x,128,x,y,4);end
circfill(sx,yo(sx)-10,8,1)
flip();goto w
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010300021825018130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600020034200332003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300000065000655000000000000605000000000000000006050000000000000000000000000000000000000650006550000000000000000000000000000000000000000000000000000000000000000000000
010300002195021950219302192021920219202192021920239502395023930239202392023920239202392024950249502493024920249202492024920249202895028950289302892028920289202892028920
010600000065500000000000000000000000000000000000006550000000000000000000000000000000000000655000000000000000000000000000000000000065500000000000000000000000000000000000
010600002f9702f9702f9402f9302f9402f9402f9222f9222f9702f9702f9402f9302d9402d9402d9202d9202f9702f9702f9402f9302f9422f9422f9222f9222f9702f9702f9402f9302d9402d9402d9202d920
010600002f9702f9702f9402f9302f9402f9402f9222f9222f9702f9702f9402f9302d9402d9402d9202d9202f9702f9702f9402f9302d9402d9402d9202d9202897028970289402893024940249402492024920
010600002b9702b9702b9402b9302b9402b9452b9222b9222d9702d9702d9402d9302994029940299202992029970299702994029930299402994029920299202997029970299402993029940299402992029920
010600002995029950299402993029940299402992029920299502995029940299302994029940299202992029950299412994029920299302993029920299202994029940299402992029931299302992029920
010600002983029812268302681221830218121d8301d812268302681221830218121d8301d8121a8301a81221830218121d8301d8121a8301a81215830158121d8301d8121a8301a81215830158121183011812
0106000009130091310910100100091300913109101001001013010131101010c100101301013110101001000e1300e1310e1010c1000e1300e1310e1010c1001013010131101010c1001013010131101010c100
010600000e1300e1310e101001000e1300e1310e101001001513015131151010c100151301513115101001001113011131111010c1001113011131111010c1001513015131151010c1001513015131151010c100
010600002f7522f7522f7422f7522f7722f7722f7422f7422f7522f7522f7422f7522d7722d7722d7422d7422f7522f7522f7422f7522f7722f7722f7422f7422f7522f7522f7422f7522d7722d7722d7422d742
010300002177221772217722177221772217722177221772237722377223772237722377223772237722377224772247722477224772247722477224772247722877228772287722877228772287722877228772
010600002f7522f7522f7422f7522f7722f7722f7422f7422f7522f7522f7422f7522d7722d7722d7422d7422f7522f7522f7422f7522d7722d7722d7422d7422875228752287422875224772247722474224742
010600002b7522b7522b7422b7522b7722b7722b7422b7422d7522d7522d7422d7522977229772297422974229752297522974229752297722977229742297422975229752297422975229772297722974229742
01060000297022972229742267222674221722217421d7221d742267222674221722217421d7221d7421a7221a74221722217421d7221d7421a7221a74215722157421d7221d7421a7221a742157221574211722
010600002d9702d9702d9402d9302d9402d9402d9222d9222d9702d9702d9402d9302b9402b9402b9202b9202d9702d9702d9402d9302d9422d9422d9222d9222d9702d9702d9402d9302b9402b9402b9202b920
010600002d7522d7522d7422d7522d7722d7722d7422d7422d7522d7522d7422d7522b7722b7722b7422b7422d7522d7522d7422d7522d7722d7722d7422d7422d7522d7522d7422d7522b7722b7722b7422b742
0106000007130071310710100100071300713107101001000e1300e1310e1010a1000e1300e1310e101001000b1300b1310b101091000b1300b1310b101091000e1300e1310e1010a1000e1300e1310e1010a100
010600002d9702d9702d9402d9302d9402d9402d9222d9222d9702d9702d9402d9302b9402b9402b9202b9202d9702d9702d9402d9302f9402f9402f9202f9202f9702f9702f9402f9302f9402f9302f9102f910
010600002d7522d7522d7422d7522d7722d7722d7422d7422d7522d7522d7422d7522b7722b7722b7422b7422d7522d7522d7422d7522f7722f7722f7422f7422f7522f7522f7422f7522f7722f7622f7322f732
010600002997029970299402993029940299402992229922299702997029940299302894028940289202892028970289702894028930289402894028920289202897028970289402893028940289402892028920
010600002975229752297422975229772297722974229742297522975229742297522877228772287422874228752287522874228752287722877228742287422875228752287422875228772287722874228742
010600002897028970289402893028940289402892228922289702897028940289302894028940289202892028970289702894028930289402894028920289202897028970289402893028940289402892028920
__music__
00 090a144c
01 0b0c1311
00 0b0d1511
00 0b0e1612
00 170f1012
00 0b18191a
00 0b1b1c1a
00 0b1d1e1a
02 0b1f5e1a

