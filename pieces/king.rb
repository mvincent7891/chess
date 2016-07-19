require_relative 'stepable'

class King < Piece
  attr_accessor :string
  MOVES = [[1,0], [0,-1], [0,1], [-1,0], [1,1], [1,-1], [-1,-1], [-1,1]]
  include Stepable
  def initialize(board, color, pos)
    @moves = MOVES
    @string = nil
    super
  end

  def to_s
    @string || " " + ("\u265A").encode('utf-8') + " "
  end

end
