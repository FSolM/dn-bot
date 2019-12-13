# frozen_string_literal: true

# This class generates a new session when the bot is started; it'll work as an storage for characters
class Session
  def initialize
    @char_list = []
  end

  def add_char(character)
    @char_list.add(character)
  end

  def delete_char(character)
    @char_list.each_with_index do |char, index|
      if character == char
        @char_list.delete_at(index)
        return true
      end
    end
    false
  end

  def exists?(character)
    @char_list.include?(character)
  end
end
