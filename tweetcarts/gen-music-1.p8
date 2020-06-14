pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
srand(1)
for i=0x00,0x1100 do
poke(0x3200+i,rnd(0xff))end
p={{18,24},{54,2,7},{54,54,6}}for i,l in pairs(p) do
for j,k in pairs(l) do
poke(0x3100+i*4+j-1,k)end
end
music(1)::w::p=stat(24)cls()fillp(t()*10)rectfill(0,0,127,127,p+1)fillp()print(p,64+sin(t())*8,t(),p+6)flip()goto w

--[[function debug_music(y,mode)
  if mode == nil then mode = 0 end
  if y < 0 then
    y = 128 - 22 + y
  end
  rectfill(0, y, 127, y+24, 0)
  rect(1, y+1, 125, y+22, 7)
  for c=0,3 do
      local p   = stat(16+c)
      local b   = stat(20+c)*25 / 32
      local col = 8
      if p > -1 then 
         col = 11 
      end
      circfill(9+c*32, 6+y, 2, col)
      print(p, 15+c*32, 4+y, 7)
      rectfill(3+c*32, 10+y, 27+c*32, 13+y, 6)
      if p >= 0 then
          rectfill(3+c*32, 10+y, 3+b+c*32, 13+y, 3)
         end
   detailchannel(c, 3+c*32, y+15,mode)
  end
 end
 function detailchannel(channel, x, y, mode)
     local notes={"c ","c#","d ","d#","e ","e#","f ","g ","g#","a ","a#","b "}
     local volus={1,1,2,2,3,3,4,4}
  local pattern=stat(16 + channel)
  local beat=stat(20 + channel)
  local val1, val2, inst, note, effe, volu, padaddr, beataddr, octave,i,j
    
  if (pattern >= 0) then
   pataddr=0x3200+pattern*68
      beataddr=pataddr+2*beat

      val1=peek(beataddr)
      val2=peek(beataddr+1)
      inst=band(val1/64, 0x03)
      inst=inst+(band(val2,0x01)*4)
      note=band(val1,0x3f)
   octave=flr(note/#notes)
      note=(note%#notes)+1
      note=notes[note]..octave
      effe=band(val2/16,0x07)
      volu=band(val2/2,0x07)

   if mode==1 then
       --volume
       for i=0,7 do
        j = 6
        if (volu>=i) then j = 3 end
         line(x+i, y+5, x+i, y+5-volus[i+1], j)
        end
    if volu > 0 then
           --note+inst in color
           print(note, x+9, y+1, inst+8)
           --effect
           if effe > 0 then
            print(effe, x+22, y+1, 7)
           end
       end
          print(note, x+9, y+1, inst+8)
   else
       -- tracker style
       if volu > 0 then
           print(note, x, y+1, 7)
           print(inst, x+13, y+1, 14)
           print(volu, x+18, y+1, 12)
                 if effe > 0 then
               print(effe, x+22, y+1, 13)
           else
            print(".", x+22, y+1, 2)
           end
          else
           print("...", x, y+1, 2)
           print(".", x+13, y+1, 2)
           print(".", x+18, y+1, 2)
              print(".", x+22, y+1, 2)
       end
   end
  end
 end
 
 t = 0
 while (not btn(4) and 
        not btn(5)) do 

 cls()
 print("",0,40,7)
 print("playing")
 print("press button to stop")
 print("music from the woo demo")

 for i=8,14 do
 for i=1,15 do
 rectfill(64+cos(t*i/150)*60,
                                     80+sin(t*i/500)*30,-- 80
          64+cos(t*i/150+0.02)*60,
          90+sin(t*i/500)*30, -- 90
          i)
 end
 end
 t = t + 0.2

 if (false) then
  for i=0,3 do
   print(stat(16+i))
   print(stat(20+i))
  end
 end

 debug_music(-1)

 flip()
 end

 music(-1,500)]]
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010400000c050000000000000000000000000000000000000c050000000000000000000000000000000000000c050000000000000000000000000000000000000c05000000000000000000000000000000000000
