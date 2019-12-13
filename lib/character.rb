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

  def mod_atk(value)
    @stats[:ATK] += value
  end

  def mod_def(value)
    @stats[:DEF] += value
  end

  def mod_agl(value)
    @stats[:AGL] += value
  end

  def mod_dex(value)
    @stats[:DEX] += value
  end

  def mod_int(value)
    @stats[:INT] += value
  end

  def mod_cha(value)
    @stats[:CHA] += value
  end

  def mod_health(value)
    @health += value
  end
end
