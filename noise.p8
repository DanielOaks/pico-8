pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- messy perlin noise thing
seed = 82.4
phase = 0.6

current = 0
draw_i = 0
draw_i_phase = 1
pixels_per_update = 600
ppu_first_frame = 300

cols = {
  8,9,10,11,12,13,14,
  8,9,10,11,12,13,14,
  8,9,10,11,12,13,14,
  8,2,1,12,3,9,
  8,2,1,12,3,9,
  8,2,1,12,3,9,
  8,2,1,12,3,9,
  8,2,1,12,3,9,
  8,2,1,12,3,9,
}
current_col_offset = 0
max_col = 7

cur = {}
pixcols = {}
pix = {}
pixnext = {}
gentime = seed -- start off at seed value

tag_t = 0
tag_col = 0

function nextpix()
  cur.x += 1
  if cur.x == 128 then
    cur.x = 0
    cur.y += 1
    if cur.y == 128 then
      cur.y = 0
      gentime += 0.3
      phase += 0.3

      for x=0, 128 do
        for y=0, 128 do
										val = pixnext[x][y]
										if val == nil then
												break
										end
										
          pix[x][y] = val

          if val < -0.86 then
            col = 8
          elseif val < -0.71 then
            col = 9
          elseif val < -0.57 then
            col = 10
          elseif val < -0.43 then
            col = 11
          elseif val < -0.29 then
            col = 12
          elseif val < -0.14 then
            col = 13
          elseif val < 0 then
            col = 14
          elseif val < 0.14 then
            col = 8
          elseif val < 0.29 then
            col = 9
          elseif val < 0.43 then
            col = 10
          elseif val < 0.57 then
            col = 11
          elseif val < 0.71 then
            col = 12
          elseif val < 0.86 then
            col = 13
          else
            col = 14
          end
          sset(x,y,col)
        end
      end
    end
  end
end

function _init()
  for x=0,128 do
    pix[x] = {}
    pixnext[x] = {}
  end
  
  music(0)
  cls()
  
  -- primary game loop
  -- just generate the initial image
  -- as fast as we can
  ::init::

  cur.x = 0
  cur.y = 0

		for i=0, 128*128 do
    val = noise((cur.x/128) * phase,(cur.y/128) * phase,gentime)
    pixnext[cur.x][cur.y] = val
    nextpix()
  end
  
  spr(0,0,0,16,16)
  
  music(1)
  ::start::
		for i=0, 128*13 do
    val = noise((cur.x/128) * phase,(cur.y/128) * phase,gentime)
    pixnext[cur.x][cur.y] = val
    nextpix()
  end

  current_col_offset += 1
  if current_col_offset == max_col then
    current_col_offset = 0
  end
  for i=0, max_col do
    pal(cols[i], cols[i+current_col_offset], 0)
  end
  
  spr(0,0,0,16,16)
  
  pal()
  
  goto start
end


function _updaate()
		local ppu = pixels_per_update
		if first_frame_generated == false then
				ppu = ppu_first_frame
		end

  for i=0,ppu do
    nextpix()
    val = noise((cur.x/128) * phase,(cur.y/128) * phase,gentime)
    pixnext[cur.x][cur.y] = val
  end
  tag_t += 0.02
end

function _draaw()
  draw_i += 1
  if draw_i == draw_i_phase then
    draw_i = 0
  end
  if draw_i == 0 then
    for x=0, 128 do
      for y=0, 128 do
        val = pix[x][y]
        if val == nil then
          break
        end
      
        
        sset(x,y,col)
      end
    end
    
    current_col_offset += 1
    if current_col_offset == max_col then
      current_col_offset = 0
    end
    for i=0, max_col do
      pal(cols[i], cols[i+current_col_offset], 0)
    end

    spr(0,0,0,16,16)
    
    pal()
  end

  current += 1
  if current == 16 then
    current = 0
  end
  pset(1,1,current)
  
  tag_col += 1
  if tag_col == max_col*2 then
  		tag_col = 0
  end
  print("n", 2,  100+sin(tag_t*2-0.7)*1.5, cols[tag_col/2])
  print("o", 6,  100+sin(tag_t*2-0.5)*1.5, cols[tag_col/2])
  print("i", 10, 100+sin(tag_t*2-0.3)*1.5, cols[tag_col/2])
  print("z", 14, 100+sin(tag_t*2-0.1)*1.5, cols[tag_col/2])
end



-- copyright (c) 2016 takashi kitao
-- released under the mit license
local _p_f={}
local _p_p={}
local _p_permutation={151,160,137,91,90,15,
  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
  190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
  88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,134,139,48,27,166,
  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
  102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,18,169,200,196,
  135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,
  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
  223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,155,167,43,172,9,
  129,22,39,253,19,98,108,110,79,113,224,232,178,185,112,104,218,246,97,228,
  251,34,242,193,238,210,144,12,191,179,162,241,81,51,145,235,249,14,239,107,
  49,192,214,31,181,199,106,157,184,84,204,176,115,121,50,45,127,4,150,254,
  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}

for i=0,255 do
  local t=shr(i,8)
  _p_f[t]=t*t*t*(t*(t*6-15)+10)

  _p_p[i]=_p_permutation[i+1]
  _p_p[256+i]=_p_permutation[i+1]
end

local function _p_lerp(t,a,b)
  return a+t*(b-a)
end

local function _p_grad(hash,x,y,z)
  local h=band(hash,15)
  local u,v,r

  if h<8 then u=x else u=y end
  if h<4 then v=y elseif h==12 or h==14 then v=x else v=z end
  if band(h,1)==0 then r=u else r=-u end
  if band(h,2)==0 then r=r+v else r=r-v end

  return r
end

function noise(x, y, z)
  y=y or 0
  z=z or 0

  local xi=band(x,255)
  local yi=band(y,255)
  local zi=band(z,255)

  x=band(x,0x0.ff)
  y=band(y,0x0.ff)
  z=band(z,0x0.ff)

  local u=_p_f[x]
  local v=_p_f[y]
  local w=_p_f[z]

  local a =_p_p[xi  ]+yi
  local aa=_p_p[a   ]+zi
  local ab=_p_p[a+1 ]+zi
  local b =_p_p[xi+1]+yi
  local ba=_p_p[b   ]+zi
  local bb=_p_p[b+1 ]+zi

  return _p_lerp(w,_p_lerp(v,_p_lerp(u,_p_grad(_p_p[aa  ],x  ,y  ,z  ),
                                       _p_grad(_p_p[ba  ],x-1,y  ,z  )),
                             _p_lerp(u,_p_grad(_p_p[ab  ],x  ,y-1,z  ),
                                       _p_grad(_p_p[bb  ],x-1,y-1,z  ))),
                   _p_lerp(v,_p_lerp(u,_p_grad(_p_p[aa+1],x  ,y  ,z-1),
                                       _p_grad(_p_p[ba+1],x-1,y  ,z-1)),
                             _p_lerp(u,_p_grad(_p_p[ab+1],x  ,y-1,z-1),
                                       _p_grad(_p_p[bb+1],x-1,y-1,z-1))))
end

__gfx__
00000000822000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000080c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000933000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000000000000000000300000000031000000002e0002e0002e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110002019043190351a035275211d0251e0261f025210252302323025250252702527032290462a0452b0552c0532c0652c0652f4612b0652b0562a065290552505323045200452e7311f0351f0221f01221025
010800200c6100c6100c6100c6100c6100c6100c6100c6100c6100c6100c6130c6100c6100c6100c6100c6100c6100c6100c6100c6100c6100c6100c6130c6100c6100c6100c6100c6100c6100c6100c6100c610
__music__
03 09424344
03 08424344

