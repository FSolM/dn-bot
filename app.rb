require 'telegram/bot'
Dir['./lib/*.rb'].each do |file| require file end

# Rework Methods
# Check if minified_expressions can handle bot connection

token = '1037457443:AAHWAVRxWLvb5oDRyYuUmZM70KOCxs_vbRo'

general_stats = %i[:ATK, :DEF, :AGL, :DEX, :INT, :CHA]

b = BotCalls.new

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
      b.send('Hello there traveler, ready to start the journey?')
      b.send('If you are new to this bot, please consider running the /help command to familiarize yourself with this bot')
      # Generates new Session
    when '/help'
      b.send('To roll a dice, run /roll followed by the type of dice you wanna roll; for example: /roll 10 to roll a 10 faced die')
      b.send('To create a new character, run the command /create')
      b.send('To end the session, run /end')
    when /^\/roll/
      if message.text.match(/4|6|8|10|12|20|100$/)
        b.send(rand(1..message.text.split(' ')[1].to_i))
      else
        unknown_roll(b)
      end
    when '/create'
      c = Character.new
      b.send("What's the character's name?")
      bot.listen do |msg|
        c.name = msg.text
        break
      end
      b.send("What's #{c.name}'s race?")
      bot.listen do |msg|
        c.race = msg.text
        break
      end
      b.send("Let's set #{c.name}'s stats!")
      general_stats.each do |stat|
        b.send("What's their #{stat}?")
        bot.listen do |msg|
          c.stats[stat] = msg.text.to_i
          break
        end
      end
      b.send("#{c.name} has been saved!")
    when '/stop'
      b.send('Until we see next time travelers')
      # Destroys current Session
    else
      unknown_command(b)
    end
  end
end
