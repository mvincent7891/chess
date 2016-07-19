require "singleton"

class NullPiece
  attr_reader :en_passant, :color, :pos
  include Singleton

  def initialize
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
