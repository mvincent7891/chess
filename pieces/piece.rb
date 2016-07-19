
class Piece
  attr_reader :color
  attr_accessor :pos, :en_passant

  def initialize(board, color, pos)
    @board = board
    @color = color
    @pos = pos
    @en_passant = false
  end

  def inspect
    inspect_hash = {"Class" => self.class, "Position" => @pos, "Color" => @color}
    p inspect_hash
  end

  def to_s
    " X "
  end

  def empty?
    false
  end

  def symbol
  end

  def valid_moves
    moves = get_valid_moves
    moves.reject { |move| move_into_check?(move)}
  end

  def dup
    eval("#{self.class.to_s}.new(@board, @color, @pos)")
  end

  def valid_moves_prime
    moves = get_valid_moves
  end

  def move_into_check?(to_pos)
    duplicate_board = @board.dup
    duplicate_board.move(@pos, to_pos)
    duplicate_board.in_check?(@color)
  end

  def enemy_present?(to_pos)
    @board.in_bounds?(to_pos) && !(@board[to_pos].empty?) &&
      @board[to_pos].color != @color
  end

  def vector_addition(current_pos, move)
    [current_pos[0] + move[0], current_pos[1] + move[1]]
  end

  def valid_move?(next_pos)
    @board.in_bounds?(next_pos) && (@board[next_pos].empty?)
  end

end
