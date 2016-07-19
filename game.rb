require_relative "board.rb"
require_relative "player.rb"

class Game
  def initialize(player1, player2)
    @current_player = player1
    @next_player = player2
    @board = Board.new
  end

  def switch_players!
    @current_player, @next_player = @next_player, @current_player
  end

end
