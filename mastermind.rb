class Player 
  attr_reader :name
  attr_accessor :codemaker, :points
  def initialize(name)
    @name = name
    @points = 0
    @codemaker = false
    @code = []
  end  

  def GetCode(colors)
    if @codemaker
      puts "Please enter code, separate with commas\n(Possible colors are: #{colors.join(", ")})"
      @code = gets.chomp.downcase.split(",")
    else
      @code = []
      4.times { @code << colors[rand(6)] }
      @code
    end
  end

  def GuessCode(colors, previous_guess, matches)
    if @codemaker
      guess = []
      for i in 0..3
        if matches[i] == "Match"
          guess << previous_guess[i]
        else
          guess << colors[rand(6)]
        end
      end
      guess
    else
      puts "Guess the 4 color combination, separate with a comma\n(Possible colors are: #{colors.join(", ")})"
      str = gets.chomp.downcase
      guess_arr = str.split(",")
    end
  end 
end

class Game
  attr_reader :round_over, :game_over, :turn
  def initialize(computer, player)
    @computer = computer
    @player = player    
    @colors = ["green", "red", "yellow", "blue", "white", "black"]
    @round_over = false
    @game_over = false
    @turn = 0
    @code = ["","","",""]
    @guess = ["","","",""]
    @matches = ["","","",""] 
  end

  def SetRoles()
    puts "Would you like to be the codemaker? (Y/N)\n"
    user_input = gets.chomp.downcase
    if user_input == "y"
      @player.codemaker = true
    else 
      @player.codemaker = false
    end
  end 

  def GetCode()
    @code = @player.GetCode(@colors)
  end

  def GuessCode()
    @guess = @player.GuessCode(@colors, @guess, @matches)
    puts "Guess: #{@guess.join(", ")}"
  end

  def GiveHints()
    hints = ""
    for i in 0..3
      if @guess[i].strip == @code[i].strip
        hints << "#{i+1}: Exact match!\n"
        @matches[i] = "Match"
      elsif @code.include?(@guess[i].strip)
        hints << "#{i+1}: In code but not location provided\n"
      else
        hints << "#{i+1}: Color not in code\n"
      end
    end
    @turn += 1
    if @player.codemaker
      @player.points += 1
    else 
      @computer.points += 1
    end
    if @matches.select{|x| x == "Match"}.length == 4 || @turn == 8 
      @round_over = true 
    end
    hints
  end

  def PlayAgain()
    puts "Codemaker receives #{turn} points!"
    puts "Play again? (Y/N)\n"
    str = gets.chomp.downcase
    unless str == "y"
      puts "Final: #{@player.name}: #{@player.points} - #{@computer.name}: #{@computer.points}"
      @game_over = true
    else
      @round_over = false
      @computer.GetCode(@colors)
    end
  end
end

comp = Player.new("Computer")
puts "Please enter player's name: "
player = Player.new(gets.chomp)
game = Game.new(comp, player)
until game.game_over
  game = Game.new(comp, player)
  game.SetRoles()
  game.GetCode()
  until game.round_over
    guess = game.GuessCode()
    puts "#{game.GiveHints()}\n"
  end
  game.PlayAgain()
end