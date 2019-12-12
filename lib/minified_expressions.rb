# This class generates a minified way of communication with the Telegram API
class BotCalls
  attr_accessor :bot, :msg
  def initialize
    @bot = nil
    @msg = nil
  end

  # Communication Methods
  def send(message)
    @bot.api.send_message(chat_id: @msg.chat.id, text: message)
  end
end
