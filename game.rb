require_relative "board.rb"
require_relative "players.rb"

# Notes:
# Debugger currently in bishop move case
# Pawn is still able to move 2 pieces after first move
# There is no game over check
# No castling, no en passant, no pawn to back row

class Game

  # Game::COLOR1
  COLOR1 = :black
  # Game::COLOR1
  COLOR2 = :light_white

  def initialize(player1, player2)
    @board = Board.new
    @current_player = player1
    player1.board = @board
    @next_player = player2
    player2.board = @board
    assign_colors
    @board.current_player = @current_player.color
  end

  def assign_colors
    colors = [COLOR2, COLOR1]
    color1 = colors.sample
    color2 = (colors - [color1])[0]
    @current_player.color = color1
    @next_player.color = color2
  end

  def switch_players!
    @current_player, @next_player = @next_player, @current_player
    @board.current_player = @current_player.color
  end

  def play
    switch_players! unless @current_player.color == COLOR2
    until game_over?
      message = nil
      begin
        start, end_pos = @current_player.get_input(message)
        @board.move(start, end_pos)
      rescue WrongPlayer
        message = "That is not your piece! Try again."
        retry
      rescue MoveIntoCheck
        message = "That move would put you in check - try again!"
        retry
      rescue BadMove
        message = "That is not a valid move - try again!"
        retry
      rescue ArgumentError
        message = "Some other error - try again!"
        retry
      end
      switch_players!
    end

    losing_king_pos = @board.find_king(@current_player.color)
    winning_king_pos = @board.find_king(@next_player.color)
    @board[winning_king_pos].string = " " + ("\u263A").encode('utf-8') + " "
    @board[losing_king_pos].string = " " + ("\u2639").encode('utf-8') + " "
    @board.render
    puts "Game over! #{@next_player.name} wins!"

  end

  def game_over?
    @board.check_mate?(COLOR1) || @board.check_mate?(COLOR2)
  end

end

choice = nil

puts "Choose a game type (input number):"
puts "1: Human v Human"
puts "2: Computer v Human"
puts "3: Computer v Computer"

until [1,2,3].include?(choice)
  choice = gets.chomp.to_i
end

case choice
when 1
  g = Game.new(Player.new('Bill'), Player.new('James'))
when 2
  g = Game.new(Player.new('Bill'), ComputerPlayer.new('James'))
when 3
  g = Game.new(ComputerPlayer.new('Bill'), ComputerPlayer.new('James'))
end
g.play
