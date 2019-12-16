# frozen_string_literal: true

# This class generates a new session when the bot is started; it'll work as an storage for characters
class Session
  attr_reader :char_list

  def initialize
    @char_list = []
  end

  def close
    @char_list = nil
  end

  def add_char(character)
    @char_list << character
  end

  def delete_char(char_name)
    @char_list.each_with_index do |char, index|
      @char_list.delete_at(index) if char_name == char.name
    end
  end

  def update_char(char_name, attribute, value)
    char = update_value(get_char(char_name), attribute, value)
    delete_char(char_name)
    add_char(char) 
  end

  def mod_char(char_name, attribute, value)
    char = mod_value(get_char(char_name), attribute, value)
    delete_char(char_name)
    add_char(char)
  end

  def exists?(char_name)
    @char_list.each do |char|
      return true if char_name == char.name
    end
  end

  private
  def get_char(char_name)
    @char_list.each do |char|
      return char if char_name == char.name
    end
  end

  def update_value(char, attribute, value)
    attribute == 'health' ? char.health = value : char.stats[attribute] = value
    char
  end

  def mod_value(char, attribute, value)
    attribute == 'health' ? char.health += value : char.stats[attribute] += value
    char
  end
end
