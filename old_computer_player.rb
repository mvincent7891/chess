require 'byebug'

class ComputerPlayer < Player

  RANK = {Class::Queen => 0, Class::Knight => 1, Class::Bishop => 2, Class::Rook => 3, Class::Pawn => 4}

  def get_input(message = nil)
    from_pos, to_pos = nil, nil

    # *** Choose Random
    # get_all_valid_moves.sample

    # *** Choose Random Attack
    # choose_random_attack

    # *** Choose Fortified Move
    # get_weak_pieces
    # sort_moves!(get_all_valid_moves) { |move| fortified_move?(move)}[0]

    # *** Choose Fortified Attack
    f = fortified_attack
    return f if f

    # *** Choose Top Attack
    a = get_top_attack
    return a if a

    m = get_all_valid_moves
    # *** Choose Fortified Move
    g = m.select { |move| fortified_move?(move) }.sample
    return g if g

    # *** Put In check
    c = m.select { |move| put_in_check?(move) }.sample
    return c if c

    # *** Choose Random Move
    m.sample

  end

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

  def put_in_check?(move, board = @board)
    start, end_pos = move
    dup_board = @board.dup
    dup_board.move!(start, end_pos)
    dup_board.in_check?(dup_board.opposite_color(@color))
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

  def get_all_pieces(board = @board, player = @color)
    board.grid.flatten.select { |piece| piece.color == player }
  end

  def get_weak_pieces(board = @board, player = @color)
    pieces = get_all_pieces(board, player)
    weak_pieces = pieces.select { |piece| !fortified_move?([piece.pos, piece.pos]) }
  end

  def fortified_move?(move)
    # Return true if moving into line of attack of friendly piece,
    # i.e. move is fortified by another piece's line of attack
    start, end_pos = move
    color = @board[start].color
    # Need to update logic here - but for now at least won't move into check
    return true if @board[start].is_a?(King)
    dup_board = @board.dup
    dup_board.move!(start, end_pos)
    dup_board[end_pos] = Pawn.new(dup_board, dup_board.opposite_color(color), end_pos)
    next_moves = get_all_valid_moves(dup_board)
    # make sure one of these moves can protect the freshly moved piece
    next_moves.any? { |move| move[1] == end_pos }
  end


end
