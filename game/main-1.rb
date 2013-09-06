# encoding: utf-8

require 'sdl'
require 'image'

SCREEN_W = 640
SCREEN_H = 480
BOTTOM   = 410

SDL.init(SDL::INIT_EVERYTHING)
SDL::TTF.init
screen = SDL.set_video_mode(SCREEN_W, SCREEN_H, 16, SDL::SWSURFACE)


gun = Gun.new(screen)
ufo = Ufo.new(screen)

en1 = Enemy.new(screen, 30,  ufo)
en1.speed = 0.3


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

  # エイリアンを落とす


  # エイリアンが大砲に当たったか


  # ゲームウィンドウを表示する
  screen.fill_rect(0, 0,      SCREEN_W, BOTTOM,          [46, 41, 48])
  screen.fill_rect(0, BOTTOM, SCREEN_W, SCREEN_H-BOTTOM, [0,  0,  0 ])

  # ＨＰを表示する


  # キャラクターを表示する
  gun.put
  ufo.put
  en1.put

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
