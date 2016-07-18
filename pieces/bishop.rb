require_relative 'slideable'

class Bishop < Piece
  MOVES = [[1,1], [1,-1], [-1,-1], [-1,1]]
  include Slideable

  def initialize(board, color, pos)
    @moves = MOVES
    super
  end

  def to_s
    " " + ("\u265D").encode('utf-8') + " "
  end

end
