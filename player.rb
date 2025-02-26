class Player
  attr_reader :x, :y, :score, :lives  

  def initialize
    @image = Gosu::Image.new("media/starfighter.bmp")  
    @beep = Gosu::Sample.new("media/beep.wav")       
    @x = @y = @vel_x = @vel_y = @angle = 0.0   
    @score = 0    
    @lives = 3    
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def score=(points)
    @score = points
  end

  def lose_life
    @lives -= 1
  end

  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end

  def accelerate_left
    @vel_x -= 0.5
  end
  
  def accelerate_right
    @vel_x += 0.5
  end
  
  def move
    @x += @vel_x
    @y = 480 - @image.height / 2  
    @x = [@x, 640 - @image.width / 2].min  
    @x = [@x, @image.width / 2].max        
    @y = 480 - @image.height / 2           
    @vel_x *= 0.95  
  end

  def draw
    @image.draw_rot(@x, @y, 1)
  end

  def score
    @score
  end
end