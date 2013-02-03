require 'gosu'
require_relative 'world'
require_relative 'things'

class GameWindow < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  
  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Gosu Tutorial Game"

    @player = Player.new(self)
    @asteroids = Array.new
    200.times {@asteroids.push(Asteroid.new(self)) }
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    @player.move
  end

  def center
    @player
  end
  
  def draw
    @player.draw(center)
    @asteroids.each {|asteroid| asteroid.draw(center) }
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show
