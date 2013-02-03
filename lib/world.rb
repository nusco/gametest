require 'chipmunk'

class World
  WIDTH = 8000
  HEIGHT = 6000
  DT = (1.0 / 60.0)
  # The number of steps to process every Gosu update
  # The Player ship can get going so fast as to "move through" a
  # star without triggering a collision; an increased number of
  # Chipmunk step calls per update will effectively avoid this issue
  SUBSTEPS = 6

  attr_reader :window
  
  def initialize(window)
    @space = CP::Space.new
    @space.damping = 0.8

    @window = window
    @things = []
  end
  
  def track(thing)
    @center = thing
  end
  
  def add(thing)
    @things << thing
    @space.add_body thing.shape.body
    @space.add_shape thing.shape
  end
  
  def draw
    @things.each {|t| t.draw(@center) }
  end
  
  def step
    @space.step DT
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
    
    @shape = CP::Shape::Circle.new(body, 25/2, CP::Vec2.new(0.0, 0.0))
    @shape.body.p = CP::Vec2.new(0.0, 0.0)
    @shape.body.v = CP::Vec2.new(0.0, 0.0)
    # Keep in mind that down the screen is positive y, which means that PI/2 radians,
    # which you might consider the top in the traditional Trig unit circle sense is actually
    # the bottom; thus 3PI/2 is the top
    @shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen
    
    world.add(self)
  end

  def body
    @shape.body
  end
  
  def warp(vect)
    @shape.body.p = vect
  end

  # Apply negative Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_left
    @shape.body.t -= 400.0/World::SUBSTEPS
  end
  
  # Apply positive Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_right
    @shape.body.t += 400.0/World::SUBSTEPS
  end
  
  # Apply forward force; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep acceleration rate constant
  # even if the number of steps per update are adjusted
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
  def accelerate
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0/World::SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  # Apply even more forward force
  # See accelerate for more details
  def boost
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0)), CP::Vec2.new(0.0, 0.0))
  end
  
  # Apply reverse force
  # See accelerate for more details
  def reverse
    @shape.body.apply_force(-(@shape.body.a.radians_to_vec2 * (1000.0/World::SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  # Wrap to the other side of the screen when we fly off the edge
  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % GameWindow::WIDTH, @shape.body.p.y % GameWindow::HEIGHT)
    @shape.body.p = l_position
  end
  
  def draw(center)
     offset = [GameWindow::WIDTH / 2 - center.body.p.x, GameWindow::HEIGHT / 2 - center.body.p.y]
     relative_position = [@shape.body.p.x + offset[0], @shape.body.p.y + offset[1]]

     @image.draw_rot(relative_position[0] - @image.width / 2.0, relative_position[1] - @image.height / 2.0, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end
end
