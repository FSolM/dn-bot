# frozen_string_literal: true

# This class generates characters so the session can be populated
class Character
  attr_accessor :name, :race, :stats, :health

  def initialize
    @name = nil
    @race = nil
    @stats = {
      ATK: nil,
      DEF: nil,
      AGL: nil,
      DEX: nil,
      INT: nil,
      CHA: nil
    }
    @health = 20
  end
end
