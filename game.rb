require_relative "board.rb"
require_relative "player.rb"

# Notes:
# Debugger currently in bishop move case
# Pawn is still able to move 2 pieces after first move
# There is no game over check
# No castling, no en passant, no pawn to back row

class Game
  def initialize(player1, player2)
    @board = Board.new
    @current_player = Player.new(player1, @board)
    @next_player = Player.new(player2, @board)
    assign_colors
    @board.current_player = @current_player.color
  end

  def assign_colors
    colors = [:white, :black]
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
    switch_players! unless @current_player.color == :white
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

  end

  def game_over?
    false
  end

end

g = Game.new('Bill', 'Susan')
g.play
