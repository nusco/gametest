require_relative 'world'

class Player < Thing
  def initialize(world)
    super(world, "img/rocket.png", 100, 100)

    shape.e = 0.7
    shape.u = 0.3

    warp World.zero
  end

  def spin(amount)
    body.apply_impulse(CP::Vec2.new(0, amount), CP::Vec2.new(shape.radius, 0))
  end

  def chase(x, y)
    @target = CP::Vec2.new(x, y)
  end
  
  def step
    unless is_in_world?
      edge_bounce = (World.zero - body.p).normalize * 2000
      body.apply_impulse(edge_bounce, CP::Vec2.new(0, 0))
      return
    end
    return unless @target

    to_target = (@target - body.p).normalize * 200
    body.a += (to_target.to_angle - body.a) / 20
    body.apply_impulse(to_target * 3, CP::Vec2.new(0.0, 0.0))
    @target = nil
  end
end

class Asteroid < Thing
  def initialize(world)
    super(world, "img/asteroid.png", 200, 100)

    shape.e = 0.2
    shape.u = 0.1

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
