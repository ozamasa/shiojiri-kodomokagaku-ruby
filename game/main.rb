# encoding: utf-8

require 'sdl'
require 'image'

SCREEN_W = 640
SCREEN_H = 480
BOTTOM   = 410

ufo_hp = SCREEN_W - 100
you_hp = SCREEN_W - 100

SDL.init(SDL::INIT_EVERYTHING)
SDL::TTF.init
screen = SDL.set_video_mode(SCREEN_W, SCREEN_H, 16, SDL::SWSURFACE)
font = SDL::TTF.open('font/ehsmb.ttf', 20)

bom = Image.new(screen, 'image/bomb.png', -50, -50, 0)
ufo = Image.new(screen, 'image/ufo.png', 50, 10, 0)
en1 = Image.new(screen, 'image/enemy.png', ufo.x + 30, ufo.y + 80, 1 / 3.0)
en2 = Image.new(screen, 'image/enemy.png', ufo.x + 85, ufo.y + 80, 2 / 3.0)
gun = Image.new(screen, 'image/gun.png', SCREEN_W - 80, BOTTOM - 115, 0)

loop do
  while event=SDL::Event2.poll
    case event
    when SDL::Event2::Quit
      exit
    when SDL::Event2::KeyDown
      sleep(10) if event.sym == SDL::Key::ESCAPE
    end
  end

  SDL::Key.scan
  if SDL::Key.press?(SDL::Key::LEFT)
    gun.x -= 2
  end
  if SDL::Key.press?(SDL::Key::RIGHT)
    gun.x += 2
  end
  if SDL::Key.press?(SDL::Key::SPACE)
    if bom.y < 0
      bom.reset(gun.x + 30, gun.y, 0.5)
    end
  end

  if bom.y < 0
    bom.reset(-50, -50, 0)
  end
  bom.y -= bom.speed

  if gun.x < 0
    gun.x = 0
  end
  if gun.x >= SCREEN_W-100
    gun.x = SCREEN_W-100
  end

  if en1.y > BOTTOM
    ufo.x = rand(SCREEN_W - 150)
    en1.reset(ufo.x + 30, ufo.y + 80, 1 / 3.0)
  end
  en1.y += en1.speed

  if en2.y > BOTTOM
    ufo.x = rand(SCREEN_W - 150)
    en2.reset(ufo.x + 85, ufo.y + 80, rand(3) / 3.0)
  end
  en2.y += en2.speed

  if bom.y > 0 and (bom.y - ufo.y - 80) < 0 and (ufo.x + 100 - bom.x - 10) > -90 and (ufo.x + 100 - bom.x - 10) < 90
    ufo_hp -= 30
    bom.reset(-50, -50, 0)
  end
  break if ufo_hp <= 0

  if (gun.y - en1.y - 50) < 0 and (en1.x + 10 - gun.x - 40) > -30 and (en1.x + 10 - gun.x - 40) < 30
    you_hp -= 40
    ufo.x = rand(SCREEN_W - 150)
    en1.reset(ufo.x + 30, ufo.y + 80, 1 / 3.0)
  end
  break if you_hp <= 0

  if (gun.y - en2.y - 50) < 0 and (en2.x + 10 - gun.x - 40) > -30 and (en2.x + 10 - gun.x - 40) < 30
    you_hp -= 80
    ufo.x = rand(SCREEN_W - 150)
    en2.reset(ufo.x + 30, ufo.y + 80, 1 / 3.0)
  end
  break if you_hp <= 0

  screen.fill_rect(0, 0,      SCREEN_W, BOTTOM,          [46, 41, 48])
  screen.fill_rect(0, BOTTOM, SCREEN_W, SCREEN_H-BOTTOM, [0,  0,  0 ])

  screen.fill_rect(10, BOTTOM + 10, ufo_hp, 20, [255, 0, 0])
  screen.fill_rect(10, BOTTOM + 40, you_hp, 20, [255, 255, 0])

  font.draw_solid_utf8(screen, "#{ufo_hp}", SCREEN_W - 80, BOTTOM + 10, 255, 255, 255)
  font.draw_solid_utf8(screen, "#{you_hp}", SCREEN_W - 80, BOTTOM + 40, 255, 255, 255)

  bom.put if bom.y > 0
  gun.put
  ufo.put
  en1.put
  en2.put

  screen.update_rect(0, 0, 0, 0)

end

font = SDL::TTF.open('font/ehsmb.ttf', 50)
if you_hp <= 0
  screen.fill_rect(0, 0, SCREEN_W, SCREEN_H,  [255, 0, 0])
  font.draw_solid_utf8(screen, "GAME OVER...", 150, 200, 0, 0, 0)
elsif ufo_hp <= 0
  screen.fill_rect(0, 0, SCREEN_W, SCREEN_H,  [255, 255,   0])
  font.draw_solid_utf8(screen, "MISSION CLEAR!!", 100, 200, 0, 0, 0)
end
screen.update_rect(0, 0, 0, 0)

sleep(3)
exit
