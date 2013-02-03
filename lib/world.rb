require 'chipmunk'

class World
  WIDTH = 6000
  HEIGHT = 4500
  DT = 1.0 / 20.0

  attr_reader :window, :camera
  
  def initialize(window)
    @space = CP::Space.new
    @space.damping = 0.5

    @window = window
    @things = []
  end
  
  def add_camera(camera)
    @camera = camera
    @things << camera
  end
  
  def add(thing)
    @things << thing
    @space.add_body thing.body
    @space.add_shape thing.shape
  end
  
  def draw
    @things.each {|t| t.draw @camera }
  end
  
  def step
    @things.each {|t| t.step }
    @space.step DT
  end
  
  def self.zero
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
  
  def step
  end
  
  def is_in_world?
    (0..World::WIDTH).include?(body.p.x) && (0..World::HEIGHT).include?(body.p.y)
  end
  
  def draw(camera)
     offset = [GameWindow::WIDTH / 2 - camera.body.p.x, GameWindow::HEIGHT / 2 - camera.body.p.y]
     relative_position = [@shape.body.p.x + offset[0], @shape.body.p.y + offset[1]]

     @image.draw_rot(relative_position[0] - @image.width / 2.0, relative_position[1] - @image.height / 2.0, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end
end
