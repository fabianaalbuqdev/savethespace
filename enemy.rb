class Enemy
  SPEED = 2  
  attr_reader :x, :y  

  def initialize  
    @x = rand(640) 
    @y = 0         
    @image = Gosu::Image.new("media/enemy.png") 
  end

  def move
    @y += SPEED 
  end

  def draw
    @image.draw(@x - (@image.width * 0.2) / 2, @y - (@image.height * 0.2) / 2, 1, 0.2, 0.2)
  end

  def off_screen?
    @y > 480 
  end
end
