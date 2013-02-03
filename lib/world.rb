module World
  WIDTH = 6000
  HEIGHT = 8000
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Array
  def x; self[0]; end
  def y; self[1]; end

  def x=(value)
    self[0] = value
  end

  def y=(value)
    self[1] = value
  end
  
  def normalize
    self[0] %= World::WIDTH
    self[1] %= World::HEIGHT
  end
end
