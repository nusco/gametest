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
    @camera = Camera.new(@world, @player)
    400.times { Asteroid.new(@world) }
    @cursor = Gosu::Image.new(self, 'img/cursor.png')
  end

  def mouse_in_window?
    (0..WIDTH).include?(mouse_x) && (0..HEIGHT).include?(mouse_y)
  end
  
  def update
    @player.chase(@camera.body.pos.x - WIDTH / 2 + mouse_x, @camera.body.pos.y - HEIGHT / 2 + mouse_y) if mouse_in_window?
    
    @world.step
  end
  
  def draw
    @world.draw
    @cursor.draw self.mouse_x, self.mouse_y, ZOrder::Cursor
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
