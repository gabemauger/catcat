pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--sjooter--
--ref: https://www.lexaloffle.com/bbs/?tid=3948
--license: cc4-by-nc-sa

--changes:
---sprites
---ship.h
---removed health spawns/sprites
---removed stars
---adjusted bullet box-collider
---new enemy sprite concept sketch

--future changes:
---enemy flight pattern/movement
---fixed ship fire rate
---enemy health implemented
---multiple enemy designs

function _init()
 t=0
 
 ship = {
  sp=1,
  x=60,
  y=100,
  h=1,
  p=0,
  t=0,
  imm=false,
  box = {x1=0,y1=0,x2=7,y2=7}}
 bullets = {}
 enemies = {}
 explosions = {}
 
 start()
end

function respawn()
 local n = flr(rnd(9))+2
 for i=1,n do
  local d = -1
  if rnd(1)<0.5 then d=1 end
 add(enemies, {
  sp=6,
  m_x=i*16,
  m_y=-20-i*8,
  d=d,
  x=-32,
  y=-32,
  r=12,
  box = {x1=0,y1=0,x2=7,y2=7}
 })
 end

end



function start()
 _update = update_game
 _draw = draw_game
end

function game_over()
 _update = update_over
 _draw = draw_over
end

function update_over()

end

function draw_over()
 cls()
 print("game over",50,50,4)
end


function abs_box(s)
 local box = {}
 box.x1 = s.box.x1 + s.x
 box.y1 = s.box.y1 + s.y
 box.x2 = s.box.x2 + s.x
 box.y2 = s.box.y2 + s.y
 return box

end

function coll(a,b)
 -- todo
 local box_a = abs_box(a)
 local box_b = abs_box(b)
 
 if box_a.x1 > box_b.x2 or
    box_a.y1 > box_b.y2 or
    box_b.x1 > box_a.x2 or
    box_b.y1 > box_a.y2 then
    return false
 end
 
 
 return true 
 
 
end

function explode(x,y)
 add(explosions,{x=x,y=y,t=0})
end

function fire()
 local b = {
  sp=3,
  x=ship.x,
  y=ship.y,
  dx=0,
  dy=-3,
  box = {x1=3,y1=0,x2=4,y2=4}
 }
 add(bullets,b)
end

function update_game()
 t=t+1
 if ship.imm then
  ship.t += 1
  if ship.t >30 then
   ship.imm = false
   ship.t = 0
  end
 end
 
 for ex in all(explosions) do
  ex.t+=1
  if ex.t == 13 then
   del(explosions, ex)
  end
 end
 
 if #enemies <= 0 then
  respawn()
 end
 
 for e in all(enemies) do
  e.m_y += 1.3
  e.x = e.r*sin(e.d*t/50) + e.m_x
  e.y = e.r*cos(t/50) + e.m_y
  if coll(ship,e) and not ship.imm then
    ship.imm = true
    ship.h -= 1
    if ship.h <= 0 then
     game_over()
    end
  
  end
  
  if e.y > 150 then
   del(enemies,e)
  end
 
 end
 
 for b in all(bullets) do
  b.x+=b.dx
  b.y+=b.dy
  if b.x < 0 or b.x > 128 or
   b.y < 0 or b.y > 128 then
   del(bullets,b)
  end
  for e in all(enemies) do
   if coll(b,e) then
    del(enemies,e)
    ship.p += 1
    explode(e.x,e.y)
   end
  end
 end
 if(t%6<3) then
  ship.sp=1
 else
  ship.sp=2
 end
 
 if btn(0) then ship.x-=1 end
 if btn(1) then ship.x+=1 end
 if btn(2) then ship.y-=1 end
 if btn(3) then ship.y+=1 end
 if btnp(4) then fire() end
end


function draw_game()
 cls()
 
 print(ship.p,9)
 if not ship.imm or t%8 < 4 then
  spr(ship.sp,ship.x,ship.y)
 end
 
 for ex in all(explosions) do
  circ(ex.x,ex.y,ex.t/2,7)
 end
  
 for b in all(bullets) do 
  spr(b.sp,b.x,b.y)
 end
 
 for e in all(enemies) do
  spr(e.sp,e.x,e.y)
 end
 
 for i=1,4 do
  if i<=ship.h then 
  spr(33,80+6*i,3)
  else
  spr(34,80+6*i,3)
  end
 end
end
__gfx__
00000000000000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007007000070070000077000000000000000000007700770000707700000000000000000000000000000000000000000000000000000000000000000
00700700000770000007700000077000000000000000000007077070007070077707700000000000000000000000000000000000000000000000000000000000
00077000007777000077770000077000000000000000000000777700007700770777770000000000000000000000000000000000000000000000000000000000
00077000077007700770077000000000000000000000000000777700070707077770077000000000000000000000000000000000000000000000000000000000
00700700077007700770077000000000000000000000000007077070007077700770007000000000000000000000000000000000000000000000000000000000
00000000070700700700707000000000000000000000000007700770077070777707707000000000000000000000000000000000000000000000000000000000
00000000000070000007000000000000000000000000000000000000000707707777007000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000070077777770777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000007777000777777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000070700000000777000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000007077707070007000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000007000777777077000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000070770000000770000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000007007777777700000000000000000000000000000000000000000000000000000000000
