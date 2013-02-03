require_relative 'world'

class Player < Thing
  def initialize(world)
    super(world, "img/rocket.png")

    shape.e = 0.2
    shape.u = 0.3
    body.m = 40
    body.i = 200

    warp world.center
  end

  def spin(amount)
    body.apply_impulse(CP::Vec2.new(0, amount), CP::Vec2.new(@image.height, 0))
  end
  
  def turn_left
    spin -1
  end
  
  def turn_right
    spin 1
  end
  
  def accelerate
    body.apply_impulse((@shape.body.a.radians_to_vec2 * 500.0), CP::Vec2.new(0.0, 0.0))
  end
  
  def step(center)
    super
    validate_position
  end
end

class Asteroid < Thing
  def initialize(world)
    super(world, "img/asteroid.png")

    shape.e = 0.2
    shape.u = 0.1
    body.m = 100
    body.i = 500

    warp CP::Vec2.new(rand(World::WIDTH), rand(World::HEIGHT))
  end
end
