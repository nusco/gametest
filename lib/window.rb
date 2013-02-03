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
    400.times { Asteroid.new(@world) }

    @world.track @player
    @draw_counter = 1
  end

  def update
    # Step the physics environment SUBSTEPS times each update
    @player.turn_left if button_down? Gosu::KbLeft
    @player.turn_right if button_down? Gosu::KbRight
    @player.accelerate if button_down? Gosu::KbUp
    
    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @world.step
  end
  
  def draw
    @draw_counter += 1
    return unless draw_counter = 10

    @world.draw
    @draw_counter = 1
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
