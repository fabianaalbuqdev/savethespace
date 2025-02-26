class Bullet
  SPEED = 5 
  attr_reader :x, :y 

  def initialize(x, y)
    @x = x 
    @y = y  
    @image = Gosu::Image.new("media/bullet.png")
  end

  def move
    @y -= SPEED 
  end

  def draw
    @image.draw(@x - @image.width / 2, @y - @image.height / 2, 1)
  end

  def off_screen?
    @y < 0 
  end
end