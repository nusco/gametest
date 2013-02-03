require_relative 'world'

class Player < Thing
  def initialize(world)
    super(world, "img/rocket.png")

    shape.e = 0.2
    shape.u = 0.3
    body.m = 100
    body.i = 100

    warp World.zero
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

  def step
    unless is_in_world?
      edge_bounce = (CP::Vec2.new(World::WIDTH / 2, World::HEIGHT / 2) - body.p).normalize * 2000
      body.apply_impulse(edge_bounce, CP::Vec2.new(0, 0))
    end
  end
end

class Asteroid < Thing
  def initialize(world)
    super(world, "img/asteroid.png")

    shape.e = 0.2
    shape.u = 0.1
    body.m = 200
    body.i = 250

    warp CP::Vec2.new(rand(World::WIDTH), rand(World::HEIGHT))
  end
end

class Camera < Thing
  def initialize(world, tracked)
    world.add_camera self
    @tracked = tracked
    body = CP::Body.new(1.0, 1.0) # FIXME
    @shape = CP::Shape::Circle.new(body, 1, CP::Vec2.new(0.0, 0.0))
  end
  
  def step
    x = [@tracked.body.p.x, GameWindow::WIDTH].max
    x = [@tracked.body.p.x, World::WIDTH - (GameWindow::WIDTH / 2)].min
    y = [@tracked.body.p.y, GameWindow::HEIGHT].max
    y = [@tracked.body.p.y, World::HEIGHT - (GameWindow::HEIGHT / 2)].min
    warp CP::Vec2.new(x, y)
  end
  
  def draw(center)
    # invisible
  end
end
