
module Thing
  attr_reader :x, :y

  def initialize(window, image)
    @image = Gosu::Image.new(window, image, false)
    @x = @y = @accel_x = @accel_y = @vel_x = @vel_y = @angle = 0.0
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @accel_x = Gosu::offset_x(@angle, 0.5)
    @accel_y = Gosu::offset_y(@angle, 0.5)
  end
  
  def move
    @vel_x += @accel_x
    @vel_y += @accel_y
    @x += @vel_x
    @y += @vel_y
    @x %= World::WIDTH
    @y %= World::HEIGHT
    
    @vel_x *= 0.96
    @vel_y *= 0.96
    @accel_x = @accel_y = 0
  end

   def draw(center)
     offset = [GameWindow::WIDTH / 2 - center.x, GameWindow::HEIGHT / 2 - center.y]
     position = [@x + offset.x, @y + offset.y]
     position.normalize
     @image.draw_rot(position.x, position.y, 1, @angle)
   end
end

class Player
  include Thing
  
  def initialize(window)
    super(window, "img/rocket.png")
  end
end

class Asteroid
  include Thing

  def initialize(window)
    super(window, "img/asteroid.png")
    warp(rand(World::WIDTH), rand(World::HEIGHT))
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
  end
end
