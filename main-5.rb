# encoding: utf-8

require 'sdl'
require './image'

SCREEN_W = 640
SCREEN_H = 480
BOTTOM   = 410

SDL.init(SDL::INIT_EVERYTHING)
SDL::TTF.init
screen = SDL.set_video_mode(SCREEN_W, SCREEN_H, 16, SDL::SWSURFACE)

bom = Bom.new(screen)
gun = Gun.new(screen)
ufo = Ufo.new(screen)

en1 = Enemy.new(screen, 30,  ufo)
en1.speed = 0.3
en2 = Enemy.new(screen, 140, ufo)
en2.speed = 0.5

ufo_hp = SCREEN_W - 100
you_hp = SCREEN_W - 100

font = SDL::TTF.open('font/ehsmb.ttf', 20)

loop do
  while event=SDL::Event2.poll
    case event
    when SDL::Event2::Quit
      exit
    when SDL::Event2::KeyDown
      exit if event.sym == SDL::Key::ESCAPE
    end
  end

  # 大砲を動かす
  SDL::Key.scan
  if SDL::Key.press?(SDL::Key::LEFT)
    gun.x -= 2
  end
  if SDL::Key.press?(SDL::Key::RIGHT)
    gun.x += 2
  end

  if gun.x < 0
    gun.x = 0
  end
  if gun.x >= SCREEN_W - 100
    gun.x = SCREEN_W - 100
  end


  # ミサイルを発射させる
  if SDL::Key.press?(SDL::Key::SPACE)
    bom.launch(gun)
    bom.speed = 0.5
  end

  if bom.y > 0
    bom.y -= bom.speed
  end


  # エイリアンを落とす
  if en1.y > BOTTOM - en1.h
    ufo.x = rand(SCREEN_W - ufo.w)
    en1.reset(30)
    en1.speed = 0.3
  end
  en1.y += en1.speed

  # エイリアン２を落とす
  if en2.y > BOTTOM - en2.h
    ufo.x = rand(SCREEN_W - ufo.w)
    en2.reset(140)
    en2.speed = 0.5
  end
  en2.y += en2.speed


  # ＵＦＯがミサイルに当たったか
  if ufo.hit(bom, 80)
    ufo_hp -= 30
    bom.y = -50
  end
  break if ufo_hp <= 0

  # エイリアンが大砲に当たったか
  if en1.hit(gun, 30)
    you_hp -= 40
    ufo.x = rand(SCREEN_W - ufo.w)
    en1.reset(30)
    en1.speed = 0.3
  end
  break if you_hp <= 0

  # エイリアン２が大砲に当たったか
  if en2.hit(gun, 30)
    you_hp -= 80
    ufo.x = rand(SCREEN_W - ufo.w)
    en2.reset(140)
    en2.speed = 0.5
  end
  break if you_hp <= 0


  # ゲームウィンドウを表示する
  screen.fill_rect(0, 0,      SCREEN_W, BOTTOM,          [46, 41, 48])
  screen.fill_rect(0, BOTTOM, SCREEN_W, SCREEN_H-BOTTOM, [0,  0,  0 ])

  # ＨＰを表示する
  screen.fill_rect(10, BOTTOM + 40, you_hp, 20, [255, 255, 0])
  font.draw_solid_utf8(screen, "#{you_hp}", SCREEN_W - 80, BOTTOM + 40, 255, 255, 255)
  screen.fill_rect(10, BOTTOM + 10, ufo_hp, 20, [255, 0, 0])
  font.draw_solid_utf8(screen, "#{ufo_hp}", SCREEN_W - 80, BOTTOM + 10, 255, 255, 255)

  # キャラクターを表示する
  bom.put if bom.y > 0
  gun.put
  ufo.put
  en1.put
  en2.put

  screen.update_rect(0, 0, 0, 0)
end


# ゲームオーバーを表示する
font = SDL::TTF.open('font/ehsmb.ttf', 50)
if you_hp <= 0
  screen.fill_rect(0, 0, SCREEN_W, SCREEN_H, [255, 0, 0])
  font.draw_solid_utf8(screen, "GAME OVER...", 150, 200, 0, 0, 0)
elsif ufo_hp <= 0
  screen.fill_rect(0, 0, SCREEN_W, SCREEN_H, [255, 255, 0])
  font.draw_solid_utf8(screen, "MISSION CLEAR!!", 100, 200, 0, 0, 0)
end
screen.update_rect(0, 0, 0, 0)


sleep(3)
exit
