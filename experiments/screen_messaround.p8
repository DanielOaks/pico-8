pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
		music(0)
end

function _draw()
		cls()
		print("aaa " .. time())
		for i = 0x6000, 0x7fff, 0x1 do
				poke(i, band(rnd(0xff), 0x0f))
		end
end
__sfx__
010500000c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c5500c550
010800000e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e5500e550
010800001055010550105501055010550105501055010550105501055010550105501055010550105501055010550105501055010550105501055010550105501055010550105501055010550105501055010550
000800001155011550115501155011550115501155011550115501155011550115501155011550115501155011550115501155011550115501155011550115501155011550115501155011550115501155011550
__music__
01 00424344
00 01424344
00 02424344
02 03424344
