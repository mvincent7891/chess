require_relative 'slideable'

class Bishop < Piece
  MOVES = [[1,1], [1,-1], [-1,-1], [-1,1]]
  include Slideable

  def initialize(board, color, pos)
    @moves = MOVES
    super
  end


end
