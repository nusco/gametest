require 'chipmunk'

class World
  WIDTH = 6000
  HEIGHT = 4500
  DT = (1.0 / 60.0)

  attr_reader :window
  
  def initialize(window)
    @space = CP::Space.new
    @space.damping = 0.9

    @window = window
    @things = []
  end
  
  def track(thing)
    @center = thing
  end
  
  def add(thing)
    @things << thing
    @space.add_body thing.body
    @space.add_shape thing.shape
  end
  
  def draw
    @things.each {|t| t.draw @center }
  end
  
  def step
    @things.each {|t| t.step @center }
    @space.step DT
  end
  
  def center
    CP::Vec2.new(WIDTH / 2, HEIGHT / 2)
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end

class Thing
  attr_reader :shape

  def initialize(world, image)
    @image = Gosu::Image.new(world.window, image, false)

    # Create the Body for the Player
    body = CP::Body.new(10.0, 150.0)
    
    @shape = CP::Shape::Circle.new(body, @image.width / 2, CP::Vec2.new(0.0, 0.0))
    @shape.body.p = CP::Vec2.new(0.0, 0.0)
    @shape.body.v = CP::Vec2.new(0.0, 0.0)
    
    @shape.body.a = (3 * Math::PI / 2.0) # angle in radians; faces towards top of screen
    
    world.add(self)
  end

  def body
    @shape.body
  end
  
  def warp(vect)
    @shape.body.p = vect
  end
  
  def step(center)
    return
    return if (body.p.x - center.body.p.x).abs > GameWindow::WIDTH || (body.p.y - center.body.p.y).abs > GameWindow::WIDTH
  end
  
  def validate_position
    warp CP::Vec2.new(@shape.body.p.x % World::WIDTH, @shape.body.p.y % World::HEIGHT)
  end
  
  def draw(center)
     offset = [GameWindow::WIDTH / 2 - center.body.p.x, GameWindow::HEIGHT / 2 - center.body.p.y]
     relative_position = [@shape.body.p.x + offset[0], @shape.body.p.y + offset[1]]

     @image.draw_rot(relative_position[0] - @image.width / 2.0, relative_position[1] - @image.height / 2.0, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end
end
