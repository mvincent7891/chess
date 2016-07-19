require 'byebug'
require_relative "display"
require_relative "pieces"

class Board
  attr_reader :display, :grid
  attr_accessor :test_moves, :current_player

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    @display = Display.new(self)
    @test_moves = []
    @current_player = nil
    populate
  end

  def populate
    set_pawns(Game::COLOR1)
    set_pawns(Game::COLOR2)
    set_back_row(Game::COLOR1)
    set_back_row(Game::COLOR2)
  end

  BACK_ROW = [:Rook, :Knight, :Bishop, :King, :Queen, :Bishop, :Knight, :Rook]
  def set_back_row(color)
    row = color == Game::COLOR1 ? 0 : 7
    @grid[row].each_index do |col|
      pos = [row, col]
      self[pos] = eval(BACK_ROW[col].to_s + ".new(self, color, pos)")
    end
  end

  def set_pawns(color)
    row = color == Game::COLOR1 ? 1 : 6
    @grid[row].each_index do |col|
      pos = [row, col]
      self[pos] = Pawn.new(self, color, pos)
    end
  end

  def move(start, end_pos)

    is_valid = !self[start].empty? &&
      self[start].valid_moves.include?(end_pos)

    raise MoveIntoCheck if self[start].pos && self[start].move_into_check?(end_pos)
    raise BadMove unless is_valid
    raise WrongPlayer if self[start].color != @current_player
    handle_pawns(start, end_pos)
    move!(start, end_pos)
  end

  def handle_pawns(start, end_pos)

    en_passant_pos = [start[0], end_pos[1]]
    if self[en_passant_pos].en_passant && (start[1] != end_pos[1])
      # taking a piece en_passant
      self[en_passant_pos] = NullPiece.instance
    end

    if self[start].at_start_row && (start[0] - end_pos[0]).abs == 2
      # flag the piece as being vulnerable to en passant
      self[start].en_passant = true
    else
      self[start].en_passant = false
    end
    queen_me!(start, end_pos)
    self[start].at_start_row = false
  end

  def queen_me!(start, end_pos)
    back_row = (end_pos[0] == 0 || end_pos[0] == 7)
    if self[start].is_a?(Pawn) && back_row
      flag = true
      while flag
        puts "Choose new piece (q = queen, r = rook, k = knight, b = bishop):"
        choice = gets.chomp
        flag = false if ['r','q','k','b'].include?(choice)
      end
      choice_class = case choice
      when 'q'
        'Queen'
      when 'r'
        'Rook'
      when 'k'
        'Knight'
      when 'b'
        'Bishop'
      end
      color = self[start].color
      self[start] = eval("#{choice_class}.new(self, color, start)")
    end
  end

  def attack?(end_pos)
    !self[end_pos].empty?
  end

  def handle_attack(end_pos)
    self[end_pos] = NullPiece.instance
  end

  def move!(start, end_pos)
    handle_attack(end_pos) if attack?(end_pos)
    self[end_pos], self[start] = self[start], self[end_pos]
    self[end_pos].pos = end_pos unless self[end_pos].is_a?(NullPiece)
    self[start].pos = start unless self[start].is_a?(NullPiece)
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end

  def dup
    duplicate_board = Board.new

    self.grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        pos = [i,j]
        if self[pos].is_a?(NullPiece)
          duplicate_board[pos] = NullPiece.instance
        else
          duplicate_board[pos] = self[pos].dup(duplicate_board)
        end
      end
    end

    duplicate_board
  end

  def render
    @display.render
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def in_check?(color)
    king_pos = find_king(color)
    opponent_pieces = @grid.flatten.select { |piece| piece.color == opposite_color(color) }
    opponent_pieces.any? {|piece| piece.valid_moves_prime.include?(king_pos)}
  end

  def check_mate?(color)
    pieces = @grid.flatten.select { |piece| piece.color == color }
    no_moves = pieces.all? { |piece| piece.valid_moves.count.zero?}
    in_check?(color) && no_moves
  end

  def opposite_color(color)
    color == Game::COLOR2 ? Game::COLOR1 : Game::COLOR2
  end

  def find_king(color)
    king_piece = @grid.flatten.select.with_index do |piece, i|
      piece.color == color && piece.is_a?(King)
    end
    king_piece[0].pos
  end

end

class MoveIntoCheck < ArgumentError
end

class WrongPlayer < StandardError
end

class BadMove < StandardError
end

# b = Board.new
# b[[0,0]] = King.new(b, :light_white, [0,0])
# b[[1,7]] = Queen.new(b, :black, [1,7])
# b[[5,5]] = Pawn.new(b, :light_white, [5,5])
# b[[5,1]] = Rook.new(b, :black, [5,1])
# b[[3,0]] = Rook.new(b, :black, [3,0])

# b.render
# p b.check_mate?(:white)


# pos_test = [3,5]
# test2 = [3,4]
# b[pos_test] = Pawn.new(b, :white, pos_test)
# b[pos_test].en_passant = true
# b[test2] = Pawn.new(b, :black, test2)
# b.test_moves = b[test2].get_valid_moves


# while true
#   from_pos, to_pos = nil, nil
#   until from_pos && to_pos
#     b.display.render
#     if from_pos
#       to_pos = b.display.get_input
#     else
#       from_pos = b.display.get_input
#     end
#   end
#   b.move(from_pos, to_pos)
#   b.display.render
# end
