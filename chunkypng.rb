require 'chunky_png' 

png = ChunkyPNG::Image.new(10, 20, ChunkyPNG::Color::TRANSPARENT)
color = ChunkyPNG::Color::WHITE


10.times do |x| 
  20.times do |y| 
    png[x, y] = color if x > 3 && x < 7   
  end
end

png.save('media/bullet.png') 