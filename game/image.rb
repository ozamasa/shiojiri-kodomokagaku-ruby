# encoding: utf-8

class Image

  attr_accessor :x, :y, :w, :h, :speed, :image

  def initialize(screen, image_file, x, y, w, h)
    @screen = screen
    @image = SDL::Surface.load(image_file)
    @w = w
    @h = h

    @x = x
    @y = y
    @speed = 0
  end

  def put(*map)
    @screen.put(@image, @x, @y)
  end

  def hit(target, range)
    source = self
    return false if target.y <= 0 || source.y <= 0

    if (target.y - (source.y + source.h) < 0) and
       ((source.x + source.w / 2) - (target.x + target.w / 2)) > range * -1 and
       ((source.x + source.w / 2) - (target.x + target.w / 2)) < range
      return true
    end
    return false
  end

end


class Enemy < Image

  attr_accessor :ufo

  def initialize(screen, x, ufo)
    image_file = 'image/enemy.png'
    w = 37
    h = 50
    super(screen, image_file, ufo.x + x, ufo.y + 80, w, h)
    @ufo = ufo
  end

  def reset(xx)
    @x = @ufo.x + xx
    @y = @ufo.y + 80
    @speed = 0.3
  end

end


class Ufo < Image

  def initialize(screen)
    image_file = 'image/ufo.png'
    x = 50
    y = 10
    w = 200
    h = 120
    super(screen, image_file, x, y, w, h)
  end

end


class Bom < Image

  def initialize(screen)
    image_file = 'image/bomb.png'
    x = -50
    y = -50
    w = 41
    h = 51
    super(screen, image_file, x, y, w, h)
  end

  def launch(gun)
    if @y <= 0
      @x = gun.x + 30
      @y = gun.y
      @speed = 0.5
    end
  end

end


class Gun < Image

  def initialize(screen)
    image_file = 'image/gun.png'
    x = SCREEN_W - 80
    y = BOTTOM - 115
    w = 97
    h = 119
    super(screen, image_file, x, y, w, h)
  end

end


class Ban < Image

  def initialize(screen)
    image_file = 'image/bang.png'
    x = -50
    y = -50
    w = 58
    h = 72
    super(screen, image_file, x, y, w, h)
#   @image.set_color_key(SDL::SRCCOLORKEY, [255, 255, 255])
  end

end
