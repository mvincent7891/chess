require "singleton"

class NullPiece
  attr_reader :color, :pos
  attr_accessor :en_passant, :at_start_row
  include Singleton

  def initialize
    @at_start_row = false
    @en_passant = false
    @color = :grey
    @pos = nil
  end

  def to_s
    "   "
  end

  def empty?
    true
  end

end
