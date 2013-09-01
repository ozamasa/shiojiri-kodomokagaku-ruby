# encoding: utf-8

require 'sdl'

class Image

  attr_accessor :x, :y, :speed, :image

  def initialize(screen, image_file, x, y, s)
    @screen = screen
    @image = SDL::Surface.load(image_file)
    reset(x, y, s)
  end

  def reset(x, y, s)
    @x = x
    @y = y
    @speed = s + 0.1
  end

  def put(*map)
    @screen.put(@image, @x, @y)
  end

end
