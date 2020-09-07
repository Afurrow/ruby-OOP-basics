class Player 
  attr_reader :name, :points
  attr_accessor :codemaker
  def initialize(name)
    @name = name
    @points = 0
    @codemaker = false
  end  
end

class Computer < Player 
  attr_reader :code
  def initialize(name)
    super
    @code = GetCode()
  end

  def GetCode
    @code = []
    colors = ["green", "red", "yellow", "blue", "white", "black"]
    4.times { @code << colors[rand(6)] }
    @code
  end
end

class Game
  def initialize(computer, player)
    @computer = computer
    @player = player    
  end

  def GuessCode(str)
    guess_arr = str.split(",")
    response = ""
    for i in 0..3
      if guess_arr[i].strip == @computer.code[i]
        response << "#{i+1}: Exact match\n"
      elsif @computer.code.include?(guess_arr[i].strip)
        response << "#{i+1}: In code but not location provided\n"
      else
        response << "#{i+1}: Color not in code\n"
      end
    end
    response
  end  
end

comp = Computer.new("Computer")
puts "Please enter player's name: "
player = Player.new(gets.chomp)
game = Game.new(comp, player)
puts comp.code
colors = ["green", "red", "yellow", "blue", "white", "black"] 
puts "Make a guess: (Possible colors are #{colors})"
puts game.GuessCode(gets.chomp)