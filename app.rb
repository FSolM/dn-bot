require 'telegram/bot'
require './lib/minified_expressions'

token = '1037457443:AAHWAVRxWLvb5oDRyYuUmZM70KOCxs_vbRo'

b = BotCalls.new

# Flow Methods
def start(bot)
  bot.send('Hello there traveler, ready to start the journey?')
  bot.send('If you are new to this bot, please consider running the /help command to familiarize yourself with this bot')
  # Generates new Session
end

def help(bot)
  bot.send('To roll a dice, run /roll followed by the type of dice you wanna roll; for example: /roll 10 to roll a 10 faced die')
  bot.send('To end the session, run /end')
end

def roll(bot, msg)
  dice = msg.split(' ')[1].to_i
  bot.send(rand(1..dice))
end

def stop(bot)
  bot.send('Until we see next time travelers')
  # Destroys current Session
end

# Catch Methods
def unknown_command(bot)
  bot.send('Are you speaking in an ancient tongue?')
  bot.send('If you forgot a command, try running /help')
end

def unknown_roll(bot)
  bot.send('Seems like you tried an invalid roll')
  bot.send('You can roll 4, 6, 8, 10, 12, 20 and 100 faced dies')
end

Telegram::Bot::Client.run(token) do |bot|
  b.bot = bot
  bot.listen do |message|
    b.msg = message
    case message.text
    when '/start'
      start(b)
    when '/help'
      help(b)
    when /^\/roll/
      if message.text.match(/4|6|8|10|12|20|100$/)
        roll(b, message.text)
      else
        unknown_roll(b)
      end
    when '/stop'
      stop(b)
    else
      unknown_command(b)
    end
  end
end
