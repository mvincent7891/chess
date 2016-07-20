require 'byebug'

class ComputerPlayer < Player


  def get_input(message = nil)
    move_score = Hash.new() { |h,k| h[k] = 0 }
    moves = get_all_valid_moves(@board, @color)
    moves.each do |move|
      start, end_pos = move
      dup_board = @board.dup
      dup_board.move!(start, end_pos)
      b = RankBoard.new(dup_board, @color)
      move_score[move] = b.rank_board
    end
    move_score.max_by { |k,v| v }[0]
  end

  # Old Stuff


  def fortified_attack(board = @board)
    attacks, _ = get_all_attacks(board)
    f_attacks = attacks.select { |attack| fortified_move?(attack)}
    return f_attacks.empty? ? nil : f_attacks[0]
  end

  def attack?(move, board = @board)
    attacks, _ = get_all_attacks(board)
    attacks.include?(move)
  end

  def get_top_attack(board = @board)
    attacks, _ = get_all_attacks(board)
    attacks.sort! { |attack| RANK[@board[attack[1]].class] }
    attacks[0]
  end

  def get_rand_attack(board = @board)
    attacks, _ = get_all_attacks(board)
    return attacks.empty? ? nil : attacks[0]
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

  def get_all_valid_moves(board = @board, color = @color)
    pieces = get_pieces_with_moves(board, color)
    all_valid_moves = []
    pieces.each do |piece|
      piece.valid_moves.each { |move| all_valid_moves << [piece.pos, move]}
    end
    all_valid_moves
  end

  def get_pieces_with_moves(board = @board, color = @color)
    pieces = get_all_pieces(board, color)
    pieces.select { |piece| piece.valid_moves.count > 0}
  end

  def get_all_pieces(board = @board, color = @color)
    board.grid.flatten.select { |piece| piece.color == color }
  end

  def get_weak_pieces(board = @board, player = @color)
    pieces = get_all_pieces(board, player)
    weak_pieces = pieces.select { |piece| !fortified_move?([piece.pos, piece.pos]) }
  end

  def fortified_move?(board = @board, move, color)
    # Return true if moving into line of attack of friendly piece,
    # i.e. move is fortified by another piece's line of attack
    start, end_pos = move
    # Need to update logic here - but for now at least won't move into check
    return true if board[start].is_a?(King)
    dup_board = board.dup
    dup_board.move!(start, end_pos)
    dup_board[end_pos] = Pawn.new(dup_board, dup_board.opposite_color(color), end_pos)
    next_moves = get_all_valid_moves(dup_board, color)
    # make sure one of these moves can protect the freshly moved piece
    next_moves.any? { |move| move[1] == end_pos }
  end

end

class RankBoard
  attr_reader :pieces, :opponent_pieces, :valid_moves, :opponent_valid_moves, :board, :color, :opponent_color
  RANK = {Class::Queen => 0, Class::Knight => 1, Class::Bishop => 2, Class::Rook => 3, Class::Pawn => 4}
  WORTH = {Class::King => 5, Class::Queen => 20, Class::Knight => 10, Class::Bishop => 10, Class::Rook => 10, Class::Pawn => 2}

  def initialize(board, color)
    @board = board
    @color = color
    @opponent_color = @board.opposite_color(@color)
    @pieces = []
    @opponent_pieces = []
    @board.grid.flatten.each do |piece|
      @pieces << piece if piece.color == @color
      @opponent_pieces << piece if piece.color == @opponent_color
    end
    @valid_moves = get_all_valid_moves(@board, @color, @pieces)
    @opponent_valid_moves = get_all_valid_moves(@board, @opponent_color, @opponent_pieces)
  end

  def get_all_valid_moves(board, color, all_pieces)
    pieces = all_pieces.select { |piece| piece.valid_moves.count > 0}
    all_valid_moves = []
    pieces.each do |piece|
      piece.valid_moves.each { |move| all_valid_moves << [piece.pos, move]}
    end
    all_valid_moves
  end

  def rank_board
    score = 0
    score += score_pieces(@board, @color, @pieces)
    score -= score_pieces(@board, @opponent_color, @opponent_pieces)

    # Opponent in check?
    score += 3 if @board.in_check?(@opponent_color)

    # Move to check mate?
    score += 20 if @board.check_mate?(@opponent_color)

    score
  end

  def score_pieces(board, color, pieces)
    score = 0
    pieces.each do |piece|
      value = WORTH[piece.class]
      score += value
      # fortified = fortified?(piece.pos)
      # score += fortified ? value : -value
      in_danger = in_danger?(piece.pos, color)
      score += in_danger ? -value : 0
    end
    score
  end

  def fortified?(pos)
    dup_piece = @board[pos].dup
    @pieces -= @board[pos]
    @board[pos] = Pawn.new(@board, @opponent_color, pos)
    moves = get_all_valid_moves(@board, @color, @pieces)
    fortified = moves.any? { |move| move[1] == pos }
    @pieces += dub_piece
    @board[pos] = dub_piece
    fortified
  end

  def in_danger?(pos, color)
    if color == @color
      ans = @opponent_valid_moves.any? { |move| move[1] == pos}
    else
      ans = @valid_moves.any? { |move| move[1] == pos}
    end
    ans
  end

end
