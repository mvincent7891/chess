require_relative 'slideable'

class Queen < Piece
  MOVES = [[1,0], [0,-1], [0,1], [-1,0], [1,1], [1,-1], [-1,-1], [-1,1]]
  include Slideable
  def initialize(board, color, pos)
    @moves = MOVES
    super
  end

  def to_s
    " " + ("\u265B").encode('utf-8') + " "
  end

end
