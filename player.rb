require 'byebug'
class Player

  attr_reader :name
  attr_accessor :color

  def initialize(name, board)
    @name = name
    @board = board
  end

  def get_input(message = nil)
    from_pos, to_pos = nil, nil
    message ||= "#{@name} it is your turn. You are #{@color[-5..-1]}."
    until from_pos && to_pos
      @board.test_moves = @board[from_pos].valid_moves if from_pos && !@board[from_pos].empty?
      @board.display.render
      puts message
      if from_pos
        puts "Move to where, #{@name}?"
        to_pos = @board.display.get_input
      else
        puts "Select #{@color[-5..-1]} piece, #{@name}:"
        from_pos = @board.display.get_input
      end
    end
    @board.test_moves = []
    [from_pos, to_pos]
  end

end

class ComputerPlayer < Player

  def get_input(message = nil)
    from_pos, to_pos = nil, nil

    # Choose Random
    # get_all_valid_moves.sample

    # Choose Random Attack
    # choose_random_attack

    # Choose Fortified Move
    sort_moves!(get_all_valid_moves) { |move| strong_move?(move)}[0]
  end

  def get_all_attacks(board = @board)
    moves = get_all_valid_moves(board)
    attacks = moves.select { |move| board[move[0]].enemy_present?(move[1])}
    [attacks, moves]
  end

  def choose_random_attack(board = @board)
    attacks, moves = get_all_attacks(board)
    attacks.count > 0 ? attacks.sample : moves.samplexit
  end

  def sort_moves!(moves, &prc)
    return moves unless block_given?
    indices = []
    moves.each_with_index { |el, i| indices << i if prc.call(el) }
    indices.each { |index| moves.unshift(moves.delete_at(index)) }
    moves
  end

  def get_all_valid_moves(board = @board)
    pieces = get_pieces_with_moves(board)
    all_valid_moves = []
    pieces.each do |piece|
      piece.valid_moves.each { |move| all_valid_moves << [piece.pos, move]}
    end
    all_valid_moves
  end

  def get_pieces_with_moves(board = @board)
    pieces = get_all_pieces(board)
    pieces.select { |piece| piece.valid_moves.count > 0}
  end

  def get_all_pieces(board = @board)
    board.grid.flatten.select { |piece| piece.color == @color }
  end

  def strong_move?(move)
    # Return true if moving into line of attack of friendly piece,
    # i.e. move is fortified by another piece's line of attack
    start, end_pos = move
    # Need to update logic here - but for now at least won't move into check
    return true if @board[start].is_a?(King)
    dup_board = @board.dup
    dup_board.move!(start, end_pos)
    dup_board[end_pos] = NullPiece.instance
    next_moves = get_all_valid_moves(dup_board)
    # make sure one of these moves can protect the freshly moved piece
    next_moves.any? { |move| move[1] == end_pos }
  end


end
