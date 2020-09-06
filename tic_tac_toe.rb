require 'pry'

# Board class
class Board 
  @@rounds = 0
  attr_reader :turn

  def initialize
    @turn = 0
    @state = [*1..9]
    @@rounds += 1
  end
  
  def UpdateState(marker)
    puts "Please select a location"
    cell = gets.chomp.to_i
    if cell == 0 || @state.include?(cell) == false
      puts "Invalid Selection, please select a different spot"
      UpdateState(marker)
    else
      index = @state.index(cell)
      @state[index] = marker 
      @turn += 1 
    end     
  end

  def Display
    p @state.slice(0,3)
    p @state.slice(3,3)
    p @state.slice(6,3)
  end

  def WinnerCheck
    for i in 0..2
      if i == 0
        hori = @state.slice(i,3).uniq() 
      else 
        hori = @state.slice(i*3, 3).uniq()
      end
      vert = [@state[i], @state[i+3], @state[i+6]].uniq()
      return hori[0] if hori.length() == 1
      return vert[0] if vert.length() == 1
    end
    for_cross = [@state[0], @state[4], @state[8]].uniq()
    down_cross = [@state[2], @state[4], @state[6]].uniq()
    return for_cross[0] if for_cross.length == 1
    return down_cross[0] if down_cross.length == 1
    return "tie" if @state.uniq().length == 2
    return "No Winner"
  end

end

# Player class
class Player 
  attr_reader :name, :marker, :wins
  def initialize(name, marker)
    @name = name
    @marker = marker
    @wins = 0
  end

  def IncrementWin
    @wins += 1
  end
end

# Initialize Board & Players
puts "Please provide player's name: "
playerX = Player.new(gets.chomp,"X")
puts "Please provide player's name: "
playerO = Player.new(gets.chomp,"O")
gameover = false

until gameover
  board = Board.new()
  round_over = false
  until round_over
    board.Display()

    if board.turn % 2 == 0
      board.UpdateState(playerX.marker)
    else
      board.UpdateState(playerO.marker)
    end

    case board.WinnerCheck()
      when "X" 
        playerX.IncrementWin()
        puts "#{playerX.name} won in #{board.turn} turns!"
        round_over = true        
      when "O" 
        playerO.IncrementWin()
        puts "#{playerO.name} won in #{board.turn} turns!"
        round_over = true
      when "tie"
        puts "Tie!"
        round_over = true
    end
  end

  puts "#{playerX.name}: #{playerX.wins} - #{playerO.name}: #{playerO.wins}"
  puts "Play Again? (y/n)"
  user_replay = gets.chomp
  if user_replay.downcase() == "n"
    gameover = true
  end
end