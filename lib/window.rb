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
  end

  def update
    # Step the physics environment SUBSTEPS times each update
    World::SUBSTEPS.times do
      # Wrap around the screen to the other side
      @player.validate_position
      
      # Check keyboard
      if button_down? Gosu::KbLeft
        @player.turn_left
      end
      if button_down? Gosu::KbRight
        @player.turn_right
      end
      
      if button_down? Gosu::KbUp
        if ( (button_down? Gosu::KbRightShift) || (button_down? Gosu::KbLeftShift) )
          @player.boost
        else
          @player.accelerate
        end
      elsif button_down? Gosu::KbDown
        @player.reverse
      end
      
      # Perform the step over @dt period of time
      # For best performance @dt should remain consistent for the game
      @world.step
    end
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
