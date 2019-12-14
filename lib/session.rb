# frozen_string_literal: true

# This class generates a new session when the bot is started; it'll work as an storage for characters
class Session
  def initialize
    @char_list = []
  end

  def close
    @char_list = nil
  end

  def show
    @char_list
  end

  def add_char(character)
    @char_list << character
  end

  def delete_char(char_name)
    @char_list.each_with_index do |char, index|
      @char_list.delete_at(index) if char_name == char.name
    end
  end

  def exists?(char_name)
    @char_list.each do |char|
      return true if char_name == char.name
    end
  end
end
