require 'gosu'
require_relative 'player'
require_relative 'bullet'
require_relative 'chunkypng'
require_relative 'enemy'
require_relative 'explosion'




module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end


class Tutorial < Gosu::Window
  def initialize
    super 640, 480 
    self.caption = "Tutorial Game" 
    @game_state = :menu 
    @font = Gosu::Font.new(32, name: "arcade.ttf") 
    @menu_image = Gosu::Image.new("media/tela_inicial.png")
    @game_over_image = Gosu::Image.new("media/the_end.png")
    @explosion_images = Gosu::Image.load_tiles("media/explosion2.gif", 64, 64)
    @explosions = []  
    @background_image = Gosu::Image.new("media/space.png", :tileable => true)
    @background_y = 0 
    @player = Player.new 
    @player.warp(320, 240) 
    @bullets = [] 
    @enemies = [] 
    @font = Gosu::Font.new(20) 
    @bullet_sound = Gosu::Sample.new("media/songbullet.wav")
    @explosion_sound = Gosu::Sample.new("media/explosion.mp3")
    @background_music = Gosu::Song.new("media/background_music.mp3")
    @background_music.volume = 0.1 
    @background_music.play(true) 
  end
  
  def update
    return unless @game_state == :playing 
    @background_y += 1
    @background_y = 0 if @background_y >= 480 
   
    if Gosu.button_down? Gosu::KB_LEFT
      @player.accelerate_left  
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      @player.accelerate_right  
    end

    @player.move  
    @bullets.each(&:move)
    @bullets.reject!(&:off_screen?)  

    if rand(100) < 2 
      @enemies.push(Enemy.new)
    end
    
    @enemies.each(&:move) 
    @enemies.reject!(&:off_screen?) 
    
    
    @bullets.dup.each do |bullet|
      @enemies.dup.each do |enemy|
        if Gosu.distance(bullet.x, bullet.y, enemy.x, enemy.y) < 25 
          @explosion_sound.play
          @explosions.push(Explosion.new(enemy.x, enemy.y, @explosion_images))
          @bullets.delete(bullet) 
          @enemies.delete(enemy) 
          @player.score += 1 
        end
      end
    end

   
    @enemies.each do |enemy|
      if Gosu.distance(enemy.x, enemy.y, @player.x, @player.y) < 30
        @explosion_sound.play
        @explosions.push(Explosion.new(enemy.x, enemy.y, @explosion_images))
        @enemies.delete(enemy) 
        @player.lose_life 
        if @player.lives <= 0
          @game_state = :game_over
        end
      end
    end
    @explosions.each(&:update)
    @explosions.reject! { |exp| exp.finished }
  end
  
  
def draw
 
  if @game_state == :menu
    draw_menu 
    elsif @game_state == :game_over
      @game_over_image.draw(0, 0, ZOrder::BACKGROUND, 640.0 / @game_over_image.width, 480.0 / @game_over_image.height)
      @font.draw_text("THE END", 202, 132, ZOrder::UI, 3.5, 3.5, Gosu::Color::BLACK)
      @font.draw_text("THE END", 198, 128, ZOrder::UI, 3.5, 3.5, Gosu::Color::BLACK)
      @font.draw_text("THE END", 200, 130, ZOrder::UI, 3.5, 3.5, Gosu::Color::RED)
      @font.draw_text("Pressione ENTER para reiniciar", 150, 400, ZOrder::UI, 1.2, 1.2, Gosu::Color::YELLOW)
      @font.draw_text("Pressione ESC para sair", 200, 450, ZOrder::UI, 1.2, 1.2, Gosu::Color::FUCHSIA)
    
  else
    @background_image.draw(0, @background_y, ZOrder::BACKGROUND)
    @background_image.draw(0, @background_y - 480, ZOrder::BACKGROUND) 
    @player.draw
    @bullets.each(&:draw)
    @enemies.each(&:draw)
    @explosions.each(&:draw)
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw_text("Lives: #{@player.lives}", 10, 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
  end
end

  def button_down(id)  
    case @game_state 
    when :menu 
      if id == Gosu::KB_RETURN 
        @game_state = :playing 
      elsif id == Gosu::KB_ESCAPE
        close 
      else
        super 
      end
    when :playing   
      if id == Gosu::KB_ESCAPE 
        close 
      elsif id == Gosu::KB_SPACE 
        @bullets.push(Bullet.new(@player.x, @player.y - 20)) 
        @bullet_sound.play 
      else
        super 
      end
    when :game_over 
      if id == Gosu::KB_RETURN 
        reset_game 
        @game_state = :playing  
      elsif id == Gosu::KB_ESCAPE  
        close 
      else
        super 
      end
    else 
      super 
    end
  end
  
  def draw_menu
  
    @menu_image.draw(0, 0, ZOrder::BACKGROUND) 
    @font.draw_text("Save the Space", 162, 102, ZOrder::UI, 2.5, 2.5, Gosu::Color::BLACK) 
    @font.draw_text("Save the Space", 160, 100, ZOrder::UI, 2.5, 2.5, Gosu::Color::YELLOW) 
    @font.draw_text("Mover para a esquerda: ←", 182, 202, ZOrder::UI, 1.5, 1.5, Gosu::Color::BLACK)
    @font.draw_text("Mover para a esquerda: ←", 180, 200, ZOrder::UI, 1.5, 1.5, Gosu::Color::GREEN)
    @font.draw_text("Mover para a direita: →", 180, 250, ZOrder::UI, 1.5, 1.5, Gosu::Color::BLACK) 
    @font.draw_text("Mover para a direita: →", 182, 252, ZOrder::UI, 1.5, 1.5, Gosu::Color::GREEN) 
    @font.draw_text("Atirar: Barra de Espaço", 182, 302, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK) 
    @font.draw_text("Atirar: Barra de Espaço", 180, 300, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE) 
    @font.draw_text("Pressione ENTER para começar!", 152, 402, ZOrder::UI, 1.2, 1.2, Gosu::Color::BLACK) 
    @font.draw_text("Pressione ENTER para começar!", 150, 400, ZOrder::UI, 1.2, 1.2, Gosu::Color::CYAN) 
    @font.draw_text("ESC para sair", 252, 452, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK) 
    @font.draw_text("ESC para sair", 250, 450, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED) 
  end

  def reset_game 
    @player = Player.new 
    @player.warp(320, 240) 
    @bullets.clear 
    @enemies.clear 
  end
end

Tutorial.new.show