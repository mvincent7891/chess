require_relative 'stepable'

class King < Piece
  MOVES = [[1,0], [0,-1], [0,1], [-1,0], [1,1], [1,-1], [-1,-1], [-1,1]]
  include Stepable
  def initialize(board, color, pos)
    @moves = MOVES
    super
  end

  def to_s
    " " + ("\u265A").encode('utf-8') + " "
  end

end
