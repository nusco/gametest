require_relative 'world'

class Player < Thing
  def initialize(world)
    super(world, "img/rocket.png")
    warp CP::Vec2.new(0, 0)
  end
end

class Asteroid < Thing
  def initialize(world)
    super(world, "img/asteroid.png")
    warp CP::Vec2.new(rand(World::WIDTH), rand(World::HEIGHT))
  end
end
