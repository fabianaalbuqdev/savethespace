class Explosion 
  attr_reader :finished 

  def initialize(x, y, images)
    @x = x 
    @y = y  
    @images = images     
    @frame = 0  
    @frame_delay = 5     
    @counter = 0 
    @finished = false 
  end

  def update
    return if @finished 
    @counter += 1  
    if @counter >= @frame_delay   
      @counter = 0  
      @frame += 1 
      @finished = true if @frame >= @images.size
    end
  end

  def draw
    unless @finished
      @images[@frame].draw(
        @x - @images[@frame].width / 2,  
        @y - @images[@frame].height / 2, 
        ZOrder::UI  
      )
    end
  end
end
