require 'byebug'

class Player

  attr_reader :name
  attr_accessor :color, :board

  def initialize(name, board = nil)
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
