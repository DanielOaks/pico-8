pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- toy box jam demo cart
-- by that tom hall & friends
-- sprites/sfx/code: that tom hall
-- sprites/sfx: lafolie
-- platforming anims: toby hefflin
-- music: gruber
-- additional code: see functions
-- if you did a function that is
-- uncredited, let me know!
-------------------------------
-- this contains a set of
-- creative assets to play
-- with. everyone has the same
-- set of "toys"... what will
-- you make of 'em?
--
-- the democart also has demos
-- of the various uses of
-- special sprites and supplied
-- functions.
-------------------------------
-- resources:
--
-- random useful sprites
--  (just go look!)
-- random useful sfx
-- -00-21:sfx
-- -22-59:songs
-- -60-63:sfx

-- songs: by gruber
-- 00 happy land
-- 06 chill
-- 12 scary dungeon
-- 18 fight
-- 21 evil
-- 23 defeat
-- 24 celebrate
-- 25 puzzle
-- 29 sand

-- 33 read or wait my dude by that tom hall
-- (not on gruber level, but useful)
-------------------------------
function _init()
	--direction and walk anim
	north=1
	east=2
	south=3
	west=4
	walkspeed=1
	walkframe=1 -- not used really
	walk={}
	walk={0,1,2,3,2,1}
 -- animation counters
	twoframe=0 --two frame anims
 threeframe=2 -- three frame anims
	fourframe=1 -- four frame anims
 fiveframe=3 -- five frame anims
 sixframe=4 -- six frame anims
 maxdelay=16
 framedelay=maxdelay-1
 
 frame60=0
 spinner="\\!/-" -- 4-frame text spinner
 --dude info
  dude={}
 dude.x = 60 -- center of screen
 dude.y = 60 --
 dude.facing=east
 dude.going=0 -- set if move
 
 
 wallpos=0
 ----------------------------
 -- state to show off interesting
 gs_idle=0
 gs_title=1
 gs_ninjoe=2
 gs_explodestars=3
 gs_colorize=4
 gs_paletteanims=5
 gs_rpgstuff=6
 gs_traintracks=7
 gs_uifont=8 --rwin, win, printc, double, outline
 gs_easingfunctions=9
 gs_pipes=10
 
 -- set up demo data
 init_stars()
 init_walkers() -- colorizable
 game={}
 game.state=gs_title 

 choose_explodeplace()
 setup_rwin()
 backcolor=1
 frame_counter=0
 -- for ord and chr, sprint
 setup_asciitables()
 init_pipes()
 trainx=0

 -- hardcoded easing 
 ease={0,1,2,4,8,16,32,64,80,88,92,94,95}
 ei=1
 edelta=abs(ease[1]-ease[2])/8
 edir=1
 shipx=0
 music(0)

end

--------------------------------
function choose_explodeplace()
 explodex = flr(rnd(100)+20)
 explodey = flr(rnd(100)+20)
end

--------------------------------
function init_stars()
 -- stars for space stuff
 -- you have to declare tables
 -- with ={} or their direct contents
 starsx={} -- x location of star
 starsy={} -- y location of star
 starsc={} -- color of star (darker = moves slower)
 numstars=40 -- decent number for not cluttery
 for i=1,numstars do
  starsx[i]=rnd(128) -- 0-127
  starsy[i]=rnd(128) -- 0-127
  --colors dark gray, light gray, white
  starsc[i]=5+flr(rnd((i%3)+.5)) -- 5, 6, 7 
  -- this with be 5, 6, or 7 without a fractional part
  -- i added +.5 to get more foreground stars
 end
 -- pick a direction! 0-3
 -- 0= up
 -- 1= upright
 -- 2= right
 -- 3= downright
 -- 4= down
 -- 5= downleft
 -- 6= left
 -- 7= upleft
 stars_direction=flr(rnd(8)) -- 0-7 integers
end
--------------------------------
function init_walkers()
 -- colorizable walking monsters
 walkerx={} -- x location 
 walkery={} -- y location 
 walkerc={} -- color 
 numwalkers=8 -- decent number for not cluttery
 for i=1,numwalkers do
  walkerx[i]=(i-1)*16-- 0-127
  walkery[i]=rnd(128) -- 0-127
  walkerc[i]=8+flr((i%4)+.5) -- 8,9,10 
 end
end

-------------------------------
function setup_rwin(_x,_y,_w,_h,_c1,_c2)
 if _x==nil then
  x=0 -- location of window x
  y=0 -- location of window y
  w=12 -- width, min 12
  h=12 -- height, min 12
  c1=6 -- default inside gray
  c2=7 -- default white border
 else
  x=_x -- location of window x
  y=_y -- location of window y
  w=_w -- width, min 12
  h=_h -- height, min 12
  c1=_c1 -- default inside gray
  c2=_c2 -- default white border
 end
end
----------------------------
-- sets up ascii tables
-- by yellow afterlife
-- https://www.lexaloffle.com/bbs/?tid=2420
-- btw after ` not sure if 
-- accurate
function setup_asciitables()
 chars=" !\"#$%&'()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[\\]^_`|██▒🐱⬇️░✽●♥☉웃⌂⬅️🅾️😐♪🅾️◆…➡️★⧗⬆️ˇ∧❎▤▥~"
 -- '
 s2c={}
 c2s={}
 for i=1,#chars do
  c=i+31
  s=sub(chars,i,i)
  c2s[c]=s
  s2c[s]=c
 end
end
---------------------------
function asc(_chr)
 return s2c[_chr]
end
---------------------------
function chr(_ascii)
 return c2s[_ascii]
end


-->8
-- update tab
-------------------------------
function _update60()
 local old_gs, temp
 
 old_gs=game.state
 -- update state, check input
 framedelay-=1
 if (framedelay==0) then
  twoframe = (twoframe+1) % 2 --two frame anims
  threeframe = (threeframe+1) % 3 --two frame anims
  fourframe = (fourframe+1) % 4 -- four frame anims
  fiveframe = (fiveframe+1) % 5 -- five frame anims
  sixframe = (sixframe+1) % 6 -- six frame anims
  framedelay=maxdelay
  scroll_tile(16) -- scroll water down
 end --framedelay
 frame60 = (frame60+1) % 60
 wallpos=(wallpos+.5)%128
 trainx=(trainx+.5)%144

 move_stars(stars_direction)
 move_walkers()
 if (btnp(⬅️)) then
  game.state -= 1
  if (game.state<1) game.state=gs_pipes 
 elseif (btnp(➡️)) then
  game.state += 1
  if (game.state>gs_pipes) game.state=gs_title 
 end -- if 
  -- change music on state change
 if (old_gs != game.state) then
  if (game.state == gs_ninjoe) then music(18)
  elseif (game.state==gs_explodestars) then music(6)
  elseif (game.state==gs_title) then music(0)
  elseif (game.state==gs_colorize) then music(29)
  elseif (game.state==gs_paletteanims) then music(33)
  elseif (game.state==gs_rpgstuff) then music(12)
  elseif (game.state==gs_traintracks) then music(25)
  elseif (game.state==gs_uifont) then music(29)
  elseif (game.state==gs_easingfunctions) then music(6)
  elseif (game.state==gs_pipes) then music(29)
  end -- state
 end -- music

--lafolie
--must tick after state change handling!
tick_pipes(old_gs~=game.state)

 -- move ship toward next easing point
 if (game.state==gs_easingfunctions) then
  shipx+=edelta -- always 1 or -1
  if (edir==1) then 
   temp=ceil(shipx) -- check for arrived
  else
   temp=flr(shipx)
  end
  -- see if we are at the next ease point
  if (flr(shipx)==ease[ei+edir]) then
    edelta=(abs(ease[ei]-ease[ei+edir])/8)*edir
    ei+=edir -- next dest in table
    if (ei==#ease or ei==1) then 
     edir = -edir -- reverse table
     edelta = -edelta -- reverse dir
    end -- reverse
  end -- flr shipx
 end -- gamestate
end -- fn


----------------------------
function move_stars(direction)
 for i=1,numstars do
  -- here we see what direction we are moving the stars
  -- for up, we subtract the movement in y direction
  -- for others, the same x and y, plus or minus
  -- for a final version, i'd have a "move table"
  -- containing the deltax and deltay, but this will
  -- be a lot clearer what we are doing
  move=(starsc[i]-4)/2 -- how far to move this star
  if (direction==0) then -- up
   starsy[i]=(starsy[i]-move)%128
  elseif (direction==1) then -- upright
   starsx[i]=(starsx[i]+move)%128
   starsy[i]=(starsy[i]-move)%128
  elseif (direction==2) then -- right
   starsx[i]=(starsx[i]+move)%128
  elseif (direction==3) then -- down right
   starsx[i]=(starsx[i]+move)%128
   starsy[i]=(starsy[i]+move)%128
  elseif (direction==4) then -- down
   starsy[i]=(starsy[i]+move)%128
  elseif (direction==5) then -- down left
   starsx[i]=(starsx[i]-move)%128
   starsy[i]=(starsy[i]+move)%128
  elseif (direction==6) then -- left
   starsx[i]=(starsx[i]+move)%128
  elseif (direction==7) then -- up left
   starsx[i]=(starsx[i]-move)%128
   starsy[i]=(starsy[i]-move)%128
  end
 if (frame60==0 and game.state == gs_explodestars) stars_direction=flr(rnd(8))
 end
end
----------------------------
function move_walkers()
 move=1
 for i=1,numwalkers do
  walkery[i]=(walkery[i]+move)%128
 end
 if (twoframe==0 and game.state==gs_colorize) sfx(19+rnd(3))
end
-->8
--draw tab
-------------------------------
function _draw()
 cls()
 --title bar on bottom
 sprint("<              >",0,15)
 if (game.state==gs_title) then
  -- instructions
  -- use left and right arrows
  draw_stars()
  printc("welcome to the",40,9)
  printc("toy box jam",48,7)
  printc("demo cart",56,9)
  print("⬅️➡️ for demos",34,72,4)
  
  sprintc("toy box jam",15)
 elseif (game.state==gs_ninjoe) then
  sprintc("ninjoe anims",15,8)
  -- draw idle
  spr((128+twoframe),20,20)
  print("idle"..twoframe+1,16,30,7)
  -- draw combat roll
  if (threeframe==0) spr(148,20,40)
  if (threeframe==1) spr(149,20,40)
  if (threeframe==2) spr(133,20,40)
  print("roll"..twoframe+1,16,50,7)

  -- draw duck & crawl?
  spr((150),60,40)
  spr((150+twoframe),85,40)
  print("duck  crawl",56,50,7)
 
  -- draw jump l r
  if (threeframe==0) spr(130,80,60)
  if (threeframe==1) spr(131,80,60)


  -- draw run l r
  spr((144+fourframe),60,20)
  print("run"..fourframe+1,56,30,7)
  -- draw jump l r
  if (threeframe==0) spr(130,80,60)
  if (threeframe==1) spr(131,80,60)
  if (threeframe==2) spr(130,80,60)

  print("jump"..twoframe+1,76,70,7)
  -- draw climb
  if (fourframe==0) spr((160),80,20)
  if (fourframe==1) spr((161),80,20)
  if (fourframe==2) spr((160),80,20,1,1,true,false)
  if (fourframe==3) spr((161),80,20)
  print("climb"..fourframe+1,76,30,7)
 
  --draw fall
  spr((163+twoframe),20,60)
  print("fall"..twoframe+1,16,70,7)
  -- draw die
  spr((132+threeframe),60,60)
  print("die"..fourframe+1,56,70,7)

  --draw zapper gun attack
  spr((165+twoframe),20,80)
  print("zap"..twoframe+1,16,90,7)

  --draw melee attack
  if (sixframe==0) spr(176,45,80)
  if (sixframe>0 and sixframe<=5) spr(177,45,80)
  if (sixframe==1) then
   --make other colors transparent
   --make this frame's whip ones whip color
   palt(4,true) --particle btm
   palt(9,true) --particle mid
   palt(10,true) -- particle top
   palt(1,true) -- landed whip
   pal(5,13) -- change gray to whip
   spr(178,53,80)
   palt() -- restore all of it
   pal()
  end
  if (sixframe==2) then
   --make other colors transparent
   --make this frame's whip ones whip color
   palt(4,true) --particle top
   palt(9,true) --particle mid
   palt(10,true) -- particle btm
   palt(5,true) -- curled whip
   pal(1,13) -- change dk blue to whip
   spr(178,53,80)
   palt() -- restore all of it
   pal()
  end
  if (sixframe==3) then
   --make other colors transparent
   --make this frame's whip ones whip color
   palt(4,true) --particle top
   palt(9,true) --particle mid
   --palt(10,true) -- particle btm
   palt(5,true) -- curled whip
   pal(1,13) -- change dk blue to whip
   spr(178,53,80)
   palt() -- restore all of it
   pal()
  end

  if (sixframe==4) then
   palt(4,true) --particle top
   --palt(9,true) --particle mid
   palt(10,true) -- particle btm
   palt(5,true) -- curled whip
   pal(1,13) -- change dk blue to whip
   spr(178,53,80)
   palt() -- restore all of it
   pal()
  end
  if (sixframe==5) then
   --palt(4,true) --particle top
   palt(9,true) --particle mid
   palt(10,true) -- particle btm
   palt(5,true) -- curled whip
   pal(1,13) -- change dk blue to whip
   spr(178,53,80)
   palt() -- restore all of it
   pal()
  end
  print("attack"..sixframe+1,41,90,7)
 
  -- draw possessed walk
  if (fourframe==0) spr((179),75,80)
  if (fourframe==1) spr((180),75,80)
  if (fourframe==2) spr((181),75,80)
  if (fourframe==3) spr((180),75,80)
  print("possessed"..fourframe+1,72,90,7)

  -- draw frozen
  spr(152,20,100)
  print("frozen",18,110,7)

  -- draw swim
  if (fourframe==0) spr((135),50,100)
  if (fourframe==1) spr((136),50,100)
  if (fourframe==2) spr((137),50,100)
  if (fourframe==3) spr((136),50,100)
  print("swim"..fourframe+1,48,110,7)

  --draw zipline
  line(75,95,95,105,5)
  spr((167+twoframe),80,100)
  print("zipline"..twoframe+1,78,110,7)

 
  --wally (wall slide)
  line(0,0,0,128,13)
  spr(162,1,wallpos)
  pset(1+rnd(3),wallpos+(rnd(4)-2),6)
  print("<- wall slide",9,2,7)

  --floor slide 
  line(8,17,127,17,4)
  spr(151,wallpos,9)
  pset(wallpos-(rnd(4)-2)+8,16-rnd(2),6)
  pset(wallpos-(rnd(4)-2)+2,16-rnd(2),6)
  print("/ ",90,12,7)
  print("floor slide",84,6,7)
 elseif (game.state==gs_explodestars) then
  -- show off explosions / star field
  draw_stars() 
  draw_explosion()
  sprintc("blast/stars",15,9)
 elseif (game.state==gs_colorize) then
  -- stuff
  draw_walkers()
  sprintc("colorizing",15,9)
 elseif (game.state==gs_paletteanims) then
  -- stuff
  draw_paletteanims()
  printc("make some colors transparent",90,9)
  printc("and change others cleverly",98,9)
  printc("to animate thing with 1 sprite",106,9)
  
  sprintc("palette anims",15,9)
 elseif (game.state==gs_rpgstuff) then
  -- stuff
  draw_rpg()
  printc("the rpg actor has",74,9)
  printc("changeable colors so you",82,9)
  printc("can modify hair, skin,",90,9)
  printc("equipment, clothes...",98,9)
  printc("even make a robe...",106,9)
  sprintc("rpg stuff",15,9)
 elseif (game.state==gs_traintracks) then
  -- stuff
  draw_tracks()
  sprintc("train tracks",15,9)
 elseif (game.state==gs_uifont)  then
  --rwin, win, printc, double, outline
  draw_uifont()
  sprintc("ui and font",15,9)
 elseif (game.state==gs_easingfunctions) then
  -- stuff
  draw_stars()
  --ship draw at shipx with easing slowdown
  spr(76,16+shipx,30)
  printc("honestly, there are just",74,9)
  printc("tons of easing function",82,9)
  printc("types. just google pico-tween",90,9)
  printc("or pico-8 easing functions.",98,9)
  printc("you can crappily hardcode too!",106,9)

  sprintc("easing fns",15,9)
 elseif (game.state==gs_pipes) then
  -- stuff
  draw_pipes()
  sprintc("pipes",15,9)
 end -- big state if
end -- draw
-------------------------------
function draw_explosion()
 spr(67+fourframe,explodex,explodey,1,1,false,false)
 spr(67+fourframe,explodex+8,explodey,1,1,true,false)
 spr(67+fourframe,explodex,explodey+8,1,1,false,true)
 spr(67+fourframe,explodex+8,explodey+8,1,1,true,true)
 if (fourframe==3 and framedelay==1) then
  choose_explodeplace() -- keep exploding in random places
  sfx(6)
 end
end

----------------------------
function draw_stars()
  -- draw stars color c at x,y
  for i=1,numstars do
   pset(starsx[i],starsy[i],starsc[i])
  end
end
----------------------------
function draw_walkers()

 for x=0,15 do
  for y=0,15 do
   spr(10,x*8,y*8)
  end
 end
 
 for i=1,numwalkers do
  -- if color = 8, same
  if (walkerc[i]==9) then
   pal(8,9) -- red to orange
   pal(2,4) -- purple to brown
  elseif (walkerc[i]==10) then
   pal(8,10) -- red to yellow
   pal(2,9) -- purple to orange
  end
  spr(100+twoframe,walkerx[i],walkery[i])
  pal() -- restore
 end -- for
end -- fn
-------------------------------
-- show how changing different
-- parts of palette each frame
-- can make an animation with 
-- just one sprite!
function draw_paletteanims()
 draw_rwin(8,24,108,60,1,12)
 draw_spinner()
 draw_stomper()
 draw_robotmine()
 draw_container()
end

-------------------------------
function draw_spinner()
 -- spinner
 if (fiveframe==0) then
  --pal (7,0) -- white
  palt(13,true) -- grayple
  palt(1,true) -- dk blue
  palt(2,true) -- dk pruple
  palt(5,true) -- dk gray
  spr(0,30,30)
  palt()
 elseif (fiveframe==1) then
  palt(7,true) -- white
  pal (13,7) -- grayple
  palt(1,true) -- dk blue
  palt(2,true) -- dk pruple
  palt(5,true) -- dk gray
  spr(0,30,30)
  pal()
  palt()
 elseif (fiveframe==2) then
  palt(7,true) -- white
  palt(13,true) -- grayple
  pal(1,7) -- dk blue
  palt(2,true) -- dk pruple
  palt(5,true) -- dk gray
  spr(0,30,30)
  pal()
  palt()
 elseif (fiveframe==3) then
  palt(7,true) -- white
  palt(13,true) -- grayple
  palt(1,true) -- dk blue
  pal (2,7) -- dk pruple
  palt(5,true) -- dk gray
  spr(0,30,30)
  pal()
  palt()
 elseif (fiveframe==4) then
  palt(7,true) -- white
  palt(13,true) -- grayple
  palt(1,true) -- dk blue
  palt(2,true) -- dk pruple
  pal (5,7) -- dk gray
  spr(0,30,30)
  pal()
  palt()
 end
end
-------------------------------
function draw_stomper()
 -- alien stomper
 if (fourframe==0) then
  --left foot down  
  pal(15,9)
  pal(3,4)
  palt(11,true)
  --right foot up  
  pal(13,9)
  pal(5,9)
  palt(6,true)
  
  --tongue not out
  palt(8,true)
  palt(14,true)
 elseif (fourframe==1) then 
  --left foot down  
  pal(15,9)
  pal(3,4)
  palt(11,true)
  --right foot up  
  pal(13,9)
  pal(5,9)
  palt(6,true)
  
  --tongue out 1
  pal(8,14)
  palt(14,true)
 elseif (fourframe==2) then 
  --left foot up  
  palt(15,true)
  pal(3,9)
  pal(11,9)
  --right foot down  
  pal(13,4)
  palt(5,true)
  pal(6,9)   
  --tongue out 2
  pal(8,14)
  -- flash eyes
  pal(1,12)
  --pal(14,0) cuz already pink
 elseif (fourframe==3) then
  --left foot up  
  palt(15,true)
  pal(3,9)
  pal(11,9)
  --right foot down  
  pal(13,4)
  palt(5,true)
  pal(6,9)   
   --tongue out 1
  pal(8,14)
  palt(14,true)
 end
 -- now draw it with pal adjusted
 spr(96,80,30)
 pal()
 palt()

end
-------------------------------
function draw_robotmine()
 if (fourframe==0) then
  pal(7,13) -- white>dk gray 
  pal(9,10) -- orange > yellow
  pal(1,2) -- dk blue> dk purple 
 elseif (fourframe==1) then
  pal(7,6) -- white>lt gray 
  --pal(9,10) -- orange > yellow
 elseif (fourframe==2) then
  --pal(7,5) -- white>dk gray 
  pal(9,4) -- orange > brown
 elseif (fourframe==3) then
  pal(7,6) -- white>lt gray 
  --pal(9,10) -- orange > yellow
 end
 -- robot mine draw!
 spr(97,30,70)
 pal()
end
-------------------------------
function draw_container()
--glowing container
 if (fourframe==0) then
  pal(14,4) -- highlight 
  pal(2,2) -- rest
 elseif (fourframe==1) then
  pal(14,9) -- highlight 
  pal(2,4) -- rest
 elseif (fourframe==2) then
  pal(14,10) -- highlight 
  pal(2,9) -- rest
 elseif (fourframe==3) then
  pal(14,9) -- highlight 
  pal(2,4) -- rest
 end
 spr(109,80,70)
 pal()
end
------------------------------
function draw_rpg()
 --grass, water
 palt(0,false)
 for x=0,15 do
  for y=0,14 do
   if (y<2 or y>8) then spr(10,x*8,y*8)
   elseif (y==2 or y==8) then spr(12,x*8,y*8)
   else spr(16,x*8,y*8)
   end -- if
  end -- y
 end -- x
 --house and foliage
 spr(22,112,104)
 spr(11,120,88)
 spr(33,120,96)
 spr(32,120,104)
 spr(32,120,112)
 spr(32,112,112)
 spr(33,104,112)
 spr(11,96,112)
 
 --castle
 spr(23,40,8)
 --mountains
 spr(20,0,0)
 spr(20,8,0)
 spr(21,0,8)

 palt(0,true)
 --dude
 pal(9,4)
 pal(14,10)
 pal(15,10)
 spr(24+twoframe,112,88)
 pal()
 --boat
 spr(54,48,56)
 --piers
 spr(36,72,56) 
 spr(36,24,24)
end
-------------------------------
function draw_tracks()
 palt(0,false)
 for x=0,15 do
  spr(37,x*8,64)
  if (x!=15) spr(36,64,x*8)
  if (x<8) spr(37,x*8,0)
 end -- x
 --intersection
 spr(38,64,64)
 --curve
 spr(39,64,0,1,1,true,false)
 palt()
 
 spr(40,trainx,63)
 spr(42,trainx-8,63) 
 spr(42,trainx-16,63) 
end
-------------------------------
  --rwin, win, printc, double, outline
function draw_uifont()
 draw_win(0,0,32,32,6,7)
 draw_rwin(95,0,32,32,4,9)
 print("window",5,14,0)
 print("rounded",98,14,10)
 
 rectfill(0,36,127,80,2)
 palt(5,true) -- remove backgnd
 palt(6,true) -- remove lines
 palt(0,false) -- shadow draws
 sprint("just letters",0,5,9)
 sprintc("centered -bkgnd",7,10,7,2)
 palt(1,false)
 pal(5,4)
 sprintxy("sprint@x,y",20,68+fourframe,9)
 pal()
 palt()
 printc("normal centered print",90,7)
 printo("outlined print",40,100,7,9)
 dsprintxy("big",40,10,10,9,8)
end

-------------------------------------------------------------------------------------------
--pipes
--=========================================================================================
--=========================================================================================
--=========================================================================================
--=========================================================================================
--=========================================================================================
--=========================================================================================
--=========================================================================================
--=========================================================================================
--=========================================================================================
--cardinal directions
-- 0: left
-- 1: right
-- 2: up
-- 3: down

--pipe directions
-- 0: no pipe
-- 1: x
-- 2: y
-- 3: xy

--bitmask values
--[[
      1
    +-----+
    |     | 2
    8 |     |
    +-----+
      4

]]
-- pipelut=
-- {
--  175,
--  157,
--  172,
--  159,
--  156,
--  140,
--  158,
--  173,
--  174,
--  141,
--  158,
--  142,
--  158,
--  158,
--  158
-- }
--pipelut[0]=141

function init_pipes()
  pipex=rnd()>0.5 and 0 or 15
  pipey=flr(rnd(15))--15 to prevent drawing over status bar
  pipefield={}
  pipemap={}
  pipetime=0
  prevpipe=nil
  oldpipemove=0
  lastpipemove=flr(rnd(4))
  pipemovechance=0.0625
  for y=0,14 do
    pipefield[y]={}
    for x=0,15 do
      placepipe(0,x,y)
    end
    -- pipefield[n]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    -- pipemap[n]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    -- pipefield[n][0]=0
    -- pipefield[n][0]=0
  end
  prevpipe=nil
  oldpipemove=1
  placepipe(1)
end

-- function checkfield(x,y)
--  if pipefield[y] and pipefield[y][x] then

--  end
--  return false
-- end

function placepipe(dir,px,py)
  local newpipe,mask={dir=dir,mask=0,spr=10},0
  px=px or pipex
  py=py or pipey
  printh("px: "..px)
  printh("py: "..py)
  if newpipe.dir>0 then
    --if prevpipe.dir==newpipe.dir then
      newpipe.spr=dir==1 and 141 or 156
    if not prevpipe then
      newpipe.spr=142
    elseif prevpipe.dir~=newpipe.dir then
      if lastpipemove==0 then
        if oldpipemove==2 then
          prevpipe.spr=142
        else
          prevpipe.spr=174
        end
      elseif lastpipemove==1 then
        if oldpipemove==2 then
          prevpipe.spr=140
        else
          prevpipe.spr=172
        end
      elseif lastpipemove==2 then
        if oldpipemove==0 then
          prevpipe.spr=172
        else
          prevpipe.spr=174
        end
      elseif lastpipemove==3 then
        if oldpipemove==0 then
          prevpipe.spr=140
        else
          prevpipe.spr=142
        end
      end
    end
    --calculate mask
    -- if(checkfield(x,y-1))mask+=1
    -- if(checkfield(x+1,y))mask+=2
    -- if(checkfield(x,y+1))mask+=4
    -- if(checkfield(x+1,y))mask+=8
  end

  newpipe.mask=mask
  --newpipe.spr=pipelut[mask]

  pipefield[py or pipey][px or pipex]=newpipe
  prevpipe=newpipe
end

function tick_pipes(reset)
  if(reset)init_pipes()
  pipetime+=1
  
  if pipetime>20 then
    pipetime=0
    --choose a direction to move
    local changedir=rnd()<pipemovechance
    oldpipemove=lastpipemove
    if changedir and lastpipemove<2 then
      --move up/down
      lastpipemove=rnd()<0.5 and 2 or 3
      pipemovechance=0.0625
    elseif changedir then
      --move left/right
      lastpipemove=rnd()<0.5 and 0 or 1
      pipemovechance=0.0625
    else
      pipemovechance+=0.0625
    end

    --move
    if lastpipemove==0 then
      pipex-=1
    elseif lastpipemove==1 then
      pipex+=1
    elseif lastpipemove==2 then
      pipey-=1
    else
      pipey+=1
    end

    --wrap
    if(pipex<0)pipex+=16
    if(pipex>15)pipex-=16
    if(pipey<0)pipey+=15
    if(pipey>14)pipey-=15

    placepipe(lastpipemove<2 and 1 or 2)
  end
end

function draw_pipes()
  local x,y=pipex*8,pipey*8
  for ny=0,14 do
    for nx=0,15 do
      local sprid=pipefield[ny][nx].spr
      spr(sprid,nx*8,ny*8)
    end
  end
  rect(x,y,x+7,y+7,15)
end


-->8
-- support library
-------------------------------
-- scroll tile
-- see that water tile?
-- this scrolls it down by 1
function scroll_tile(_tile)
 local temp
 local sheetwidth=64 -- bytes
 local spritestart=0 -- starts at mem address 0x0000
 local spritewide=4 -- 8 pixels=four bytes
 local spritehigh=sheetwidth*8 -- how far to jump down
 local startcol=_tile%16
 local startrow=flr(_tile/16)
 
 if (_tile>255) return
 -- save bottom row of sprite
 temp=peek4(spritestart+(startrow*sheetwidth*8)+(7*sheetwidth)+startcol*spritewide) -- 7th row
 for i=6,0,-1 do
  poke4(spritestart+(startrow*sheetwidth*8)+((i+1)*sheetwidth)+startcol*spritewide,peek4(spritestart+(startrow*sheetwidth*8)+(i*sheetwidth)+startcol*spritewide)) 
 end
 --now put bottom row on top!
 poke4(spritestart+(startrow*sheetwidth*8)+startcol*spritewide,temp) 
end 

-------------------------------
-- print string s at x y with
-- color c and outline optional
function print6(_s,_x,_y,_c,_o)
end
-------------------------------
-- collision detection function;
-- returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function checkcollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-------------------------------
function printc(_str,_y,_c)
 len=#_str
 where=63-(len*2)
 if (where<0) where=0
 print(_str,where,_y,_c)
end
-------------------------------
function printo(str, x, y, c0, c1)
for xx = -1, 1 do
 for yy = -1, 1 do
 print(str, x+xx, y+yy, c1)
 end
end
print(str,x,y,c0)
end
-------------------------------
-- sprite print
-- _c = letter color
-- _c2 = line color
-- _c3 = background color of font
-- collapse all these sprite
-- printing routines into one
-- function if you want!
function sprint(_str,_x,_y,_c,_c2,_c3)
 local i, num
 palt(0,false) -- make sure black is solid
 if (_c != nil) pal(7,_c) -- instead of white, draw this
 if (_c2 != nil) pal(6,_c2) -- instead of light gray, draw this
 if (_c3 != nil) pal(5,_c3) -- instead of dark gray, draw this
 -- make color 5 and 6 transparent for font plus shadow on screen
  
 for i=1,#_str do
  num=asc(sub(_str,i,i))+160
  spr(num,(_x+i-1)*8,_y*8)
 end
 pal()
end
-------------------------------
-- sprite print centered on x
function sprintc(_str,_y,_c,_c2,_c3)
 local i, num
 _x=63-(flr(#_str*8)/2)
 palt(0,false) -- make sure black is solid
 if (_c != nil) pal(7,_c) -- instead of white, draw this
 if (_c2 != nil) pal(6,_c2) -- instead of light gray, draw this
 if (_c3 != nil) pal(5,_c3) -- instead of dark gray, draw this
 -- make color 5 and 6 transparent for font plus shadow on screen
  
 for i=1,#_str do
  num=asc(sub(_str,i,i))+160
  spr(num,_x+(i-1)*8,_y*8)
 end
 pal()
end
-------------------------------
-- sprite print at x,y pixel coords
function sprintxy(_str,_x,_y,_c,_c2,_c3)
 local i, num
 palt(0,false) -- make sure black is solid
 if (_c != nil) pal(7,_c) -- instead of white, draw this
 if (_c2 != nil) pal(6,_c2) -- instead of light gray, draw this
 if (_c3 != nil) pal(5,_c3) -- instead of dark gray, draw this
 -- make color 5 and 6 transparent for font plus shadow on screen
  
 for i=1,#_str do
  num=asc(sub(_str,i,i))+160
  spr(num,_x+(i-1)*8,_y)
 end
 pal()
end
-------------------------------
-- double-sized sprite print at x,y pixel coords
function dsprintxy(_str,_x,_y,_c,_c2,_c3)
 local i, num,sx,sy
 palt(0,false) -- make sure black is solid
 if (_c != nil) pal(7,_c) -- instead of white, draw this
 if (_c2 != nil) pal(6,_c2) -- instead of light gray, draw this
 if (_c3 != nil) pal(5,_c3) -- instead of dark gray, draw this
 -- make color 5 and 6 transparent for font plus shadow on screen
 -- (btw you can use this technique
 -- just to draw sprites bigger)
 for i=1,#_str do
  num=asc(sub(_str,i,i))+160
  sy=flr(num/16)*8
  sx=(num%16)*8
  sspr(sx,sy,8,8,_x+(i-1)*16,_y,16,16)
 end
 pal()
end
-------------------------------
function draw_rwin(_x,_y,_w,_h,_c1,_c2)
 -- would check screen bounds but may want to scroll window on?
 if (_w<12 or _h<12) return(false) -- min size
 -- okay draw inside
 rectfill(_x+3,_y+1,_x+_w-3,_y+_h-1,_c1) -- x big middle bit
 line(_x+2,_y+3,_x+2,_y+_h-3,_c1) -- x left edge taller
 line(_x+1,_y+5,_x+1,_y+_h-5,_c1) -- x left edge shorter
 line(_x+_w-2,_y+3,_x+_w-2,_y+_h-3,_c1) -- x right edge taller
 line(_x+_w-1,_y+5,_x+_w-1,_y+_h-5,_c1) -- x right edge shorter
 --now the border left side
 line(_x,_y+5,_x,_y+_h-5,_c2) -- x longest leftmost edge
 line(_x+1,_y+3,_x+1,_y+4,_c2) -- x 2 left top
 line(_x+1,_y+_h-4,_x+1,_y+_h-3,_c2) -- x 2 left btm
 pset(_x+2,_y+2,_c2)  -- x 1 top dot
 pset(_x+2,_y+_h-2,_c2)  -- x 1 btm dot
 line(_x+3,_y+1,_x+4,_y+1,_c2)  -- x 2 top curve
 line(_x+3,_y+_h-1,_x+4,_y+_h-1,_c2)  -- x 2 btm curve
 --now the border right side
 line(_x+_w,_y+5,_x+_w,_y+_h-5,_c2) -- x longest leftmost edge
 line(_x+_w-1,_y+3,_x+_w-1,_y+4,_c2) -- x 2 left top
 line(_x+_w-1,_y+_h-4,_x+_w-1,_y+_h-3,_c2) -- x 2 left btm
 pset(_x+_w-2,_y+2,_c2)  -- x 1 top dot
 pset(_x+_w-2,_y+_h-2,_c2)  -- x 1 btm dot
 line(_x+_w-3,_y+1,_x+_w-4,_y+1,_c2)  -- x 2 top curve
 line(_x+_w-3,_y+_h-1,_x+_w-4,_y+_h-1,_c2)  -- x 2 btm curve
 -- top and bottom!
 line(_x+5,_y,_x+_w-5,_y,_c2) -- x top
 line(_x+5,_y+_h,_x+_w-5,_y+_h,_c2) -- x bottom
end
-------------------------------
-- draw simple rectangular window
-- with a frame
function draw_win(_x,_y,_w,_h,_c1,_c2)
 rectfill(_x,_y,_x+_w,_y+_h,_c1)
 rect(_x,_y,_x+_w,_y+_h,_c2)
end
------------------------------
--map collide by enargy
function issolid(x,y,flag)
 local tx = flr(x/tw)
 local ty = flr(y/th)
 tileid = mget(tx,ty)
 return fget(tileid,flag)
end
__gfx__
00012000606660666066606660666066606660666066606616666661feeeeee87bbbbbb30000004000000030000300000b0dd030777777674f9f4fff7999a999
07d1257000000000000000000000000000000000007777006d6666d6e8888882b3333331040000000300000003000030d3000b0d76777777fffff9f49999979a
057d57d0666066606660566060333306608888066676d75062444426e8811882b33773310000040000000300000003b0000b030077777677ff4fffff99a99999
22566d11000000000000000000333300008888000077770064222246e8866882b3366531000400000003000000b00bb0b0030000777677779fff9ff999997997
11d6652206660666066605666033330660888806067d675664442446e8877282b3355131400000003000000030b30b003000dd0b677777774fffff9fa9999979
0d75d750000000000000000000331300008818000077770064222a96e8822182b33113310000000400000003003b00030b00000377777776ff4fffff999a9999
07521d70660666066606660660331306608818066605550664424446e8888882b33333310400000003000000030b00000300b00076777777ff9ff9ff99999799
0002100000000000000000000033330000888800000000006422224682222222311111110000400000003000000030000dd030b077776777f9ffff4f979999a9
111c111c7ccc7cc70000000005500550005070500500700000dddd00656565650d0aa000000aa000760000000766660006566650777777500007a90000000070
11c111c177ccc7cc000000000765676005076005000760050dddddd0666666650df99f000df99f0006500000766550000666666576666650000a0000000006d6
1c111c11c77ccc7c00000000076007605076660050766700dddddddd662226650de11e000de11e0700650000664500000659405676565650000aa90000006d60
c111c111cc77ccc7076007600765676050766605007676000555555066666665d55660070d66660200065006650450000009400076666650000a00000006d000
111c111c7cc77ccc07656760076007600766767007667670066666606655566509066602d5d6609200006560650045000009400076565650000a0000076d0000
11c111c1c7cc77cc0760076000000000576676655761166506dd6c6066111665000cc092090cc00200000650600004500009400076565650007aa9007dd6d000
1c111c11cc7cc77c1765676100000000766767667610016606dd6c606611166500c11c0200c11c000000604500000045000940000766650000a00a006d06d000
c111c1117cc7cc771d211d2100000000565655656610016606dd6660cc444ccc044004400440044000060004000000040009400000555000009aa900076d0000
0bb3b3b030bbb0030150051001500510940000499999999994000049000099997667060000065000d777777dd55550000076dc0000999900000000000007d000
bb3b3b350bbb3300157556511575515194544449444444444444444400094444641605000065d650566666657665d650075555d0094444900000000000766d00
b3b33333bb3bbb305757651557576515945555490550055004555550009440006666666065616560566666657661656001c6dc109444444900000000076666d0
b3333335b3b3b33505766650057656509400004904500450045004500944000011111156006176d011111155766176d007cc6d50999aa9990000000000044000
0b4334503bbb3b3505666650056565509400004904500450045004509945400076d176d57661110076d176d57661110007cc6d50955aa5590007d00000094000
0009450033b3b355575665155516551594544449045004500454445094405400656165606161d650656165607661d65007cc6d509544444900766d0000094000
0009450003335550156551511155515194555549444444444455554494000544d650d65064616560d650d6507661656007cc6d5095444449076666d000094000
095454540033350301500510015005109400004999999999940000499400004900000000766176d000000000d55176d00066d500999999990004400000094000
000990000777770000077000007dd500007665000554455000007000067666500007000099999999750705607776777677777776777777767777777677777776
049aa94075666660007667000007500007666650554444550000770000565100007a900090040405565656507665766576666665766666657766665576666665
49a99a940065d56000077000077665507666666545444454000076700067650007aaa90094444445057775007665766576555565766776657676656576666665
9a9aa9a900666660076666707766665576565565455a9554000077770067650007aaa90090004005767766606555655576566765767665657667566576666665
9a9aa9a900655d60765555677666666576666665411a911407007000006765000a99990094444445057665007677767776566765767665657667566576666665
49a99a94006666606500005676666665765565654445544476666667006765007556559095555555565656506576657676577765766556657676656576666665
049aa940006777775650056577666655766666654444444407666670006765000aaaa90000055000750605606576657676666665766666657766665576666665
00499400005555500567765007766550655555555444444500777700067666500000000005064005000000005565556565555555655555556555555565555555
00000000000005d9007a4200000000000000000900009999900a000000000000000000000049400000040000a7a9999900076000000000000001000000000000
0e82e82000555d5507a9942000000000000909aa009999aa09000a900009000009009090049a94000049400004a994400007610000111000001c10000eeeee20
e788888205d6d5550a999940000000000000aaaa09a9aaaa00009000008aa800008aa80049a7a940049a9400097999400007610001ccc10001c7c1007262626c
e88888825d7ddd500a99994000000009090a9a9a099a9909a000000000a77a9009a77a009a777a9449a7a94009a99990707765071c777c1001c7c10015252520
0888882056dddd500a9999400000a09a00a9a9a999a997900090000009a77a0000a77a9049a7a940049a9400099a99407667665601ccc10001c7c10002e50000
0088820055ddd5500ae999400000099a09aa9a7799a970000a000000008aa800008aa800049a940000494000009994007676656500111000001c10005e200000
000820000555550007fe9420000099a70aa9a7779aa090000900000000009000090900900049400000040000000a900007655651000000000001000025200000
0000000000555000007942000009aa779aaa97779aa90000000000000000000000000000000400000000000007a9994000766510000000000000000000000000
000550000005500005677650000550000567765000ddd0000000000000033000060aa05065656565757575751111111111111111111111112888888212888821
00566500005666000567765000566500567777650d666d0003333330033bb33006aa00505dddddd66060606015555555555555555555555188eeee88288ee882
0567765066677760567777650567765067766776d67666d033bbbb3333b77b3306a00a506d5555d5575757571565505050505050505556518ea77ae888eaae88
5677776577777776567777655675576577655677d66666d03b7777b33b7777b30600aa505d5cc6d6060606061555550505050505050555518e7777e88ea77ae8
6777777677777777677557765675576556500565dd666d503b7777b33b7777b3060aa0506d5cc6d5757575751555505050505050505555518e7777e88ea77ae8
77777777666775577777777705677650050000500dddd50033bbbb3333b77b3306aa00505d5666d6606060601555550505050505050555518ea77ae888eaae88
56666665005677505666666500566500000000000055500003333330033bb33006a00a506dddddd55757575715655050505050505055565188eeee88288ee882
05555550000566000555555000055000000000000000000000000000000330000600aa5055555555060606061555555555555555555555512888888212888821
00aaaa000007000000dddd0000dddd000022220050222205bb0bb0bb0b0bb0b00000bbb000000000000990003bb1000000666000000770000076660000766600
0a999940000e00000d7cc7d00d7cc7d0552882550528825003abba30b3abba3b000b1b1ba000bbb000007900b3b3b10006000600007755000702826007282060
a979979400e88000d70cc07dd77cc77d22588522225885220bbbbbb00bbbbbb00a0bbbbbb00b1b1b009a9990bb3bbb1060700060077665500602825006282050
a71991740e111800d77cc77dd70cc07d271881722708807203baab3003baab30b00b3707b00bbbbb0979a99913b3b3b160000060775555550066550000665500
a9999994e8191880dccccccddccccccd2888888228888882b003300b00033000b00bbb00b00b370799a999790bbb3bb160000060775e275507d75d6007d75d60
a992299408111820dcc11ccddcc11ccd28881882288188820b3bb3b00b3bb3b0bb0bbbb0bb0bb3309997aa9901b3b3b106000600775227557d7dd5d67d7dd5d6
b30880d5008882000dccccd00dceecd0028888299288882000bbbb00b0bbbb0b0bb0bbbbbbb0bbbb0999a990001bbb3000666000777776557d7dd5d57d7dd5d5
ff0ee0660008200000dddd0000dddd0099222290092222990bb33bb000b33b0000bbbbb00bbbbbb0009a99000001110b00000000055555500665565006655650
08000080a00700b00056650000077000004aa4000077770000777700000000076776d7765000000000d7cd0009aaaa900000567700a7777d0007700000077000
0000000007a00bba056766500076650044a77a4407666670000666700000007676675665650000000d77ccd09a1aa1a9000567760a6666dd0076670000700700
00880800077bba7b5676666500766500aa7777aa71166117a0776657000007667667566566500000d777cccd9a5aa5a905677775a7777d5d0766667007000070
8008e808b0b7aab067666666007665004aa77aa4712662177a6666660000766676675665666500007777cccc9aaaaaa95677775076666d5d7666666770000007
008ee80000ba7ab0666666660076650004a77a40066116606d666666000766667667566566665000dcccdddd09affa900567777676666d5d0005500000077000
000888000b7b77ab56666665007665004a7aa7a405666650d05661150076666676675665666665000dccddd09a9aa9a95677766576666d5d0006600000700700
000000800ab0b7aa05666650076666504aa44aa4006116000006665007666666766756656666665000dcdd00a900009a6777655076666dd00006600007000070
08008000ab0000a00056650006555550aa4004aa0056650000665000766666666552155666666665000dd0009a9009a9776650006ddddd000006600070000007
2002821000028210202000000006822d02822222020220d000000000000000000000000000000000007665000076650005555555555555555555555055677655
0211111122111111022282100026cdcd1111110002200d0000000000000000000000000000000000075006500750065055666666666666666666665556555565
11ddcdcd01ddcdcd001111110216ddddddcdcddd21ddd00002000000000000000000000000000000065006500650000056676767676767676767766556677665
006ddddd106ddddd66ddcdcd0016dddd66666d0081cddd0022ddd000000000000000000000000000766666657666666556777777777777777777776556677665
006d5ddd006d5ddd600ddddd0015ddd066dddd001ddddd008dddd000002282000202820002222200766166657663666556777676767676767676776555677655
0065111d0065111d0005ddd00052111056d111111c66d1111dddd1000221166600211110002282dd766166657663666556766676666666666767766556555565
00520010005200100552211100520010052200000d6661001d66611100666c10011dddd000111110766666657666666556776756666666667577666556677665
0502001005020010500200100502001000502000000552221d666222666dddc066666666666dddd0655555556555555556766665555555555667766556677665
0028210020000000002821002200000002228200005000000000000000000000c0c6cc0000777700056650000000000056677665555575555566765555555555
02111110222821000211111002282100221116660205002002022210202221000cccccc0071111605600650007a00a7056776665565755665555555556677665
d21ddcd60111111021ddcdcd0111111000666c10022560220022822102282210cdd7d7d071111115607006000a9009a056677665565757676565565655555555
d1dd66660ddddcd0666ddddd0dddcdc0066dddcd101d5682011111111111111006ddddd071100115600006000000000056776665575757777576755757777775
00d66d00066dddd06066dd00066dddd05555dd0011ddd62206ddcdcd0ddcdcd00d665ddd71100115560065000000000056677665575756766557675675555557
202211000066dd00001221000066dd00021dd00000dd661260d5dddd6d5dddd000c5ccc071111115056694500a90000056776665565756666565565655677655
02000010002212000110020000221100200100000dd6dc116552ddd16522dd11005c00c0061111500000094507a0000056677665565755665555555556776665
0000000100012000000000200002100000100000d000c1105220011152220001050c00c000555500000000940000000056776665555575555567665556677665
0028226000000000628210000022000022000000222200001112000006822d0026822d0077777777002820000077770056776675555755555677666556776665
002222600028220026111100081d0000820d0000228110001112800026cdcd0016cdcd0000000000028e8200076566d056676756665575656577666556677665
061221600022222006dcdc00621d0000612d000011dcd00011dc600016dddd0006dddd000600600608e7e8007665666d56777667676575657667766555776655
06d11dd0061221160ddddd00611c0200611c0200d66665d5dddd656506dddd0006dddd000000000008eee8007665556d56677777777575757777766575555557
0dd1d1d00dd11ddd05dddd006cdd52016cdd5201dddd0d00ddd6060005ddd00005ddd00000500500028e82007666666d56667676767575756767666557777775
005111000dd1d1dd522dd0d0d66d5211d6665211211100001112000005221110052211100000000000282000076666d056666666666575656666666555555555
0015000000551110220100000d6652100dd6521020001000100020005002000150020001010100100028200000dddd0055666666665575656666665556677665
00105000001051000110000000dd510000dd51002000010010000200500000005000000000000000002820000000000005555555555755555555555055555555
062281100000000000400000202821000028210000282100000000000000000000000000000000007777777711111100566666660015d0005666666500000000
6d6dcdc00000122240900040111111102111111021111110030100000606330000003300000000007555555717777610655115510015d0006666666600000000
506dddd0000dd18090a040900ddbdbd00ddbdbd01ddbdbd003013300663138300031383000077000756556571777610065155551001d50006000000601111110
506dddd0000ddd11a00090a40666dddd1666dddd0666dddd00313830633313300633133000766700755555571776610051155551000d15006000000605555550
5006ddd000ddddd10405a00900d5dd0000d5dd0000d5dd00003313303331301363313013005665007555555717667610655115110001d5006000000605555550
00021111002d6dd00905004a005111000052110000521100033130131110000011100000000550007565565716116761655551510001d0006000000605155150
000200010222166d0a5000900520001005002000052201001110000010000000100000000000000075555557010016716555515100105d006000000605111150
0002000020011006dd1110a05020000050010000500001001000000000000000000000000000000077777777000001105111111500150d000000000005111150
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
55555555555775555775775557757755555775555775577557777555555775555557755555577555775557755557755555555555555555555555555555555775
55555555555770555770770577777775557777755770770057777055555770555577005555557755577577005557705555555555555555555555555555557700
55555555555770555500500557707700577770005507700555770775555500555577055555557705777777755777777555555555577777755555555555577005
55555555555500555555555577777775550777755577077557707700555555555577055555557705577077005557700055775555550000005555555555770055
55555555555775555555555557707700577777005770077057707705555555555557755555577005770057755557705555770555555555555577555557700555
55555555555500555555555555005005550770055500550055775775555555555555005555550055500555005555005557700555555555555577055555005555
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
55777755555775555777775557777755555777755777777555777755577777755577775555777755555775555557755555557755555555555577555557777755
57700775557770555500077555000775557707705770000057700005550007705770077557700775555770555557705555577005557777555557755555000775
57705770555770555577770055577700577007705777775557777755555577005577770055777770555500555555005555770055555000055555775555577700
57705770555770555770000555550775577777705500077557700775555770055770077555500770555775555557755555577555557777555557700555550005
55777700557777555777777557777700550007705777770055777700555770555577770055777700555770555557705555557755555000055577005555577555
55500005555000055500000055000005555555005500000555500005555500555550000555500005555500555577005555555005555555555550055555550055
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
55777755557777555777775555777755577777555577777555777775557777555775577555777755555577755775577557755555575555755775577555777755
57700775577007755770077557700775577007755770000057700000577000055770577055577005555557705770770057705555577557705777577057700775
57707770577777705777770057705500577057705777775557777755577077755777777055577055555557705777700557705555577777705777777057705770
57705000577007705770077557705775577057705770000557700005577057705770077055577055577557705770775557705555577777705770777057705770
55777775577057705777770055777700577777005577777557705555557777005770577055777755557777005770577555777775577007705770577055777700
55500000550055005500000555500005550000055550000055005555555000055500550055500005555000055500550055500000550055005500550055500005
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
55777755557777555777775555777775577777755775577557755775577557755775577557755775577777755777775557755555577777555557755555555555
57700775577007755770077557700000555770005770577057705770577777705577770055777700550077005770000555775555550077055577775555555555
57777700577057705777770055777755555770555770577057705770577777705557700555577005555770055770555555577555555577055770077555555555
57700005577077005770077555500775555770555770077055777700577007705577775555577055557700555770555555557755555577055500550055555555
57705555557707755770577057777700555770555577770055577005570055705770077555577055577777755777775555555775577777055555555557777775
55005555555005005500550055000005555500555550000555550055550555505500550055550055550000005500000555555500550000055555555555000000
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000050000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000
00000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000060000000000000000000000909099909000099009909990999000009990099000009990909099900000000000000000000000000000000000000
00000000000000000000000000000000000909090009000900090909990900000000900909000000900909090000000000000000000000000000000000000000
00000000000000000000000000000000000909099009000900090909090990000000900909000000900999099000000000000000000000000000000000000000
00000000000000000000000000000000000999090009000900090909090900000000900909000000900909090000000000000000000000000000000000000000
00000000000000000000000000000000000999099909990099099009090999000000900990000000900909099900000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000777007707070000077700770707005007770777077700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000070070707070000070707070707000000700707077700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000070070707770000077007070070000000700777070700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000070070700070000070707070707000000700707070700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000070077007770000077707700707000007700707070700000000000000000000000000005000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000005000000000000000000000000099009990999009900000099099909990999000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000090909000999090900000900090909090090000000000000000000000000000005000000000000000000
00000000000000000000000000000000000000000000090909900909090900000900099909900090000000000000000000000000000000000000000000000050
00000000000000006000000000000000000000000000090909000909090900000900090909090090000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000099909990909099000000099090909090090000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000444440004444400000044400440444000004400444044400440044000000000000000000000000000000000000000
00000000000000000000000000000000004440044044004440000040004040404000004040400044404040400000000000000000000000000000000000000000
00000000000000000000000000000000004400044044000440000044004040440000004040440040404040444000000000000000000000000000000000000000
00000000000000000000000000000000004440044044004440000040004040404000004040400040404040004000000000000000000000000000000000000000
00000000000000000000000000000000000444440004444400000040004400404000004440444040404400440000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000050000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
55557755555555555555777777555777755577557755555555557777755557777555775577555555555555577755577775557555575555555555555555775555
55577005555555555555557700057700775557777005555555557700775577007755577770055555555555557705770077557755770555555555555555577555
55770055555555555555557705557705770555770055555555557777700577057705557700555555555555557705777777057777770555555555555555557755
55577555555555555555557705557705770555770555555555557700775577057705577775555555555577557705770077057777770555555555555555577005
55557755555555555555557705555777700555770555555555557777700557777005770077555555555557777005770577057700770555555555555555770055
55555005555555555555555005555500005555500555555555555000005555000055500550055555555555000055500550055005500555555555555555500555
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666

__gff__
000101010181010001000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000c0000040400000000000000000000000000000000000000000000000000000000000c0c00000000000000000001000000000000000001000000
0000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002e1502e1502f1502f1502f150351503715000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
000200002e5502e5503555035550166003a5503a55037500345003350034500385000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000200001c620385503455031550305502e5502d5501d6201d6201d6001d600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000006500065000650006551305014050140501405014050140501405013050110500e0500b0500905008050070500605005050050500505006050070500105001030010230000000000000000000000000
000400000024000231062002100000240002310022100213190001a00023000280000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002a750267502a7500070032750377003970039700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
0004000036630236701f6711c6511b6511b6511a6511a6511a630176310e631066310463102631016310063100631006110061100611006110061100611006110061101600006000060000300003000030000300
000200000b3240d331103411c341233412634127341293412c3312e32500300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
000700180062307623000000762300623000000000000623076230000007623006230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000307342b751237511d75117751127510d75108751037310271501713007050c7000a700077000670004700027000170000700007000070000700007000070000700017000070000700007000070000700
000200002f3402f3412f33136334363413634136331363313632136321363213631136315383003f3000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
00010000312502b250252502025019250122500e2500e6300e6300e6351520010200072000420000200002000d20009200082000820000200002000120026100121001e100061000d10019100251000c10024100
0006000019150201501c150231502313519130201301c130231302312519120201201c120231202311519110201101c1102311023115001000010000100001000010000100001000010000100001000010000100
000900000b6500b6500b6531c6001c6501c650156300e630096300763005610036100161001615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001c6301c630232541c35120353173501b3501935422230246002460025600266002660027600156000f6000b6000760006600056000460004600046000020000200002000020000200002000020000200
0003000028630286301e6501a650186501664014640106400f6400c630096300663005630026100161001610016102750020500235002c5002e50022500295002e500325001f5002a5002d500265002a5001c500
000300000863111631206003365032651306512a651226511a651136410d641086410463101631006110061500000000000000000000000000000000000000000000000000000000000000000000000000000000
0003000017630106300e6500e6301063213652186521e6522a6523663236632306323062221622126220661200612006120161200612006150060000600006000060000600006000060000600006000060000600
010c00201125411255052550000000000112541125505255000000000011254112550525500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100000705005050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200000205004050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300000005002050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f000005135051050c00005135091351c0150c1351d0150a1351501516015021350713500000051350000003135031350013500000021351b015031351a0150513504135000000713505135037153c7001b725
010f00000c03300000300152401524615200150c013210150c003190151a01500000246153c70029515295150c0332e5052e5150c60524615225150000022515297172b71529014297152461535015295151d015
010f000007135061350000009135071351f711000000510505135041350000007135051351c0151d0150313503135021350000005135031350a1050a135000000113502135031350413505135000000a13500000
010f00000c033225152e5153a515246152b7070a145350150c003290153200529005246152501526015220150c0331e0251f0252700524615225051a0152250522015225152201522515246150a7110a0001d005
011400000c0330253502525020450e6150252502045025250c0330253502525020450e6150252502045025250c0330252502045025350e6150204502535025250c0330253502525020450e615025250204502525
011400001051512515150151a5151051512515150151a5151051512515150151a5151051512515150151a5151051512515170151c5151051512515170151c5151051512515160151c5151051512515160151c515
011400001c5151e5151a515150151c5151e5151a015155151c5151e5151a515150151c5151e5151a015155151c5151e51517015230151c5151e51517015230151c5151e515165151c0151c5151e515160151c515
011400000c0330653506525060450e6150652506045065250c0330653506525060450e6150652506045065250c0330952509045095350e6150904509535095250c0330953509525090450e615095250904509525
0114000020515215151c5151901520515215151c0151951520515215151c5151901520515215151c0151951520515215151c0151901520515215151c01525515285152651525515210151c5151a5151901515515
01180000021100211002110021120e1140e1100e1100e1120d1140d1100d1100d1120d1120940509110091120c1100c1100c1100c1120b1110b1100b1100b1120a1100a1100a1100a11209111091100911009112
01180000117201172011722117221d7201d7201d7221d7221c7211c7201c7201c7201c7221c72218720187221b7211b7201b7201b7201b7221b7221d7221d7221a7201a7201a7201a7201a7221a7221672016722
011800001972019720197221972218720187201872018720147201472015720157201f7211f7201d7201d7201c7201c7201c7221c7221a7201a7201a7221a7251a7201a7201a7221a72219721197201972219722
011800001a7201a7201a7221a7221c7201c7201c7221c7221e7201e7202172021720247212472023720237202272022720227202272022722227221f7201f7202272122720227202272221721217202172221722
0118000002114021100211002112091140911009110091120e1140e1100c1100c1120911209110081100811207110071100711007112061110611006110061120111101110011100111202111021100211002112
0118000020720207202072220722217202172021722217222b7212b72029720297202872128720267202672526720267202672026720267222672228721287202672026720267202672225721257202572225722
010e00000c0231951517516195150c0231751519516175150c0231951517516195150c0231751519516175150c023135151f0111f5110c0231751519516175150c0231e7111e7102a7100c023175151951617515
010e000000130070200c51000130070200a51000130070200c51000130070200a5200a5200a5120a5120a51200130070200c51000130070200a51000130070200c510001300b5200a5200a5200a5120a5120a512
010e00000c0231e5151c5161e5150c0231c5151e5161c5150c0231e5151c5161e5150c0231c5151e5161c5150c0230c51518011185110c0231c5151e5161c5150c0231e7111e7102a7100c023175151951617515
010e0000051300c02011010051300c0200f010051300c02011010051300c0200f0200f0200f0120f0120f012061300d02012010071300e02013010081300f0201503012020140101201015030120201401012010
018800000074400730007320073200730007300073200732007300073200730007320073000732007320073200732007300073000730007320073000730007300073200732007300073000732007300073200732
01640020070140801107011060110701108011070110601100013080120701106511070110801707012060110c013080120701106011050110801008017005350053408010070110601100535080170701106011
018800000073000730007320073200730007300073200732007300073200730007320073000732007320073200732007300073000730007320073000730007300073200732007300073000732007300073200732
0164002006510075110851707512060110c0130801207011060110501108017070120801107011060110701108011075110651100523080120701108017005350053408012070110601100535080170701106511
010a000024045270352d02523045260352c02522045250352b02522035250352b02522035250252b01522725257252b71522715257152b71522715257152b7151700017000170001700017000130000c00000000
010a000021705247052a7052072523715297151f72522715287151f71522715287151f71522715287151f71522715287151f71522715287151f70522705287051770017700177001770017700137000c70000700
010c00000f51014510185101b510205102451011510165101a5101d510225102651013510185101c5101f5102451028510285102851028510285102851028515240042450225504255052650426502265050e500
010c000014730187301b730207302473027730167301a7301d730227302673029730187301c7301f73024730287302b730307403073030730307303072030715247042470225704257052670426702267050e700
011200000843508435122150043530615014351221502435034351221508435084353061512215054250341508435084350043501435306150243512215034351221512215084350843530615122151221524615
011200000c033242352323524235202351d2352a5111b1350c0331b1351d1351b135201351d135171350c0330c0332423523235202351d2351b235202352a5110c03326125271162c11523135201351d13512215
0112000001435014352a5110543530615064352a5110743508435115152a5110d43530615014352a511084150d4350d4352a5110543530615064352a5110743508435014352a5110143530615115152a52124615
011200000c033115152823529235282352923511515292350c0332823529216282252923511515115150c0330c033115151c1351d1351c1351d135115151d1350c03323135115152213523116221352013522135
0112000001435014352a5110543530615064352a5110743508435115152a5110d435306150143502435034350443513135141350743516135171350a435191351a1350d4351c1351d1351c1351d1352a5011e131
011200000c033115152823529235282352923511515292350c0332823529216282252923511515115150c0330c033192351a235246151c2351d2350c0331f235202350c033222352323522235232352a50130011
011600000042500415094250a4250042500415094250a42500425094253f2050a42508425094250a425074250c4250a42503425004150c4250a42503425004150c42500415186150042502425024250342504425
011600000c0330c4130f54510545186150c0330f545105450c0330f5450c41310545115450f545105450c0230c0330c4131554516545186150c03315545165450c0330c5450f4130f4130e5450e5450f54510545
0116000005425054150e4250f42505425054150e4250f425054250e4253f2050f4250d4250e4250f4250c4250a4250a42513425144150a4250a42513425144150a42509415086150741007410074120441101411
011600000c0330c4131454515545186150c03314545155450c033145450c413155451654514545155450c0230c0330c413195451a545186150c033195451a5451a520195201852017522175220c033186150c033
010b00200c03324510245102451024512245122751127510186151841516215184150c0031841516215134150c033114151321516415182151b4151d215224151861524415222151e4151d2151c4151b21518415
010200002067021670316602f65031650336503365033650386503f6503f650326502f6502f650006002f6502e6502d650006002b650296502760024650216001e65019600116500a60000630066000161000010
010200000e6510c6530a6520b653056530000000000000000e6510c6530a652000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000013535000002b5070000037535000001f507000002b5350000000000000001f53500000000000000013505000002b5070000037535000001f507000002b5350000000000000001f535000000000000000
011000000062200622006220062202622026220262202622006220062200622006220262202622026220262200622006220062200622026220262202622026220062200622006220062202622026220262202622
__music__
00 16174344
00 16174344
01 16174344
00 16174344
00 18194344
02 18194344
00 1a424344
01 1a1b4344
00 1a1b4344
00 1a1c4344
00 1a1c4344
02 1d1e4344
01 1f204344
00 1f214344
00 1f204344
00 1f214344
00 22234344
02 1f244344
01 25264344
00 25264344
02 27284344
00 292a4344
03 2b2c4344
04 2d2e4344
04 2f304344
01 31324344
00 31324344
00 33344344
02 35364344
01 37384344
00 393a4344
00 373b4344
02 393b4344
03 3e424344

