require 'gosu'
require 'chipmunk'
require_relative 'world'
require_relative 'things'

class GameWindow < Gosu::Window
  WIDTH = 800
  HEIGHT = 600

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Concept"

    @world = World.new(self)
    
    @player = Player.new(@world)
    Camera.new(@world, @player)
    400.times { Asteroid.new(@world) }
  end

  def update
    @player.turn_left if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    
    @world.step
  end
  
  def draw
    @world.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
