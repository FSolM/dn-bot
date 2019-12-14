# frozen_string_literal: true

require 'telegram/bot'
Dir['./lib/*.rb'].each { |file| require file }

# Rework Methods
# Check if minified_expressions can handle bot connection
# Make a general method for checking if selected character exist in a session

token = '1037457443:AAHWAVRxWLvb5oDRyYuUmZM70KOCxs_vbRo'

general_stats = %i[ATK DEF AGL DEX INT CHA]

b = BotCalls.new
s = Session.new

# Catch Methods
def unknown_command(b)
  b.send('Are you speaking in an ancient tongue?')
  b.send('If you forgot a command, try running /help')
end

def unknown_roll(b)
  b.send('Seems like you tried an invalid roll')
  b.send('You can roll 4, 6, 8, 10, 12, 20 and 100 faced dies')
end

def unknown_char(b)
  b.send("This isn't the character that you're looking for...")
  b.send("It seems like the bot couldn't find the specified character, check if you type it's name right")
end

Telegram::Bot::Client.run(token) do |bot|
  b.bot = bot
  bot.listen do |message|
    b.msg = message
    case message.text
    when '/start'
      b.send('Hello there traveler, ready to start the journey?')
      b.send('If you are new to this bot, please consider running the /help command to familiarize yourself with this bot')
    when '/help'
      b.send('To roll a dice, run /roll followed by the type of dice you wanna roll; for example: /roll 10 to roll a 10 faced die')
      b.send('To show party, use the /show command')
      b.send('To create a new character, run the command /create')
      b.send("To delete an existing character, run /delete followed by the character's name")
      b.send("To reset a character stat, run /set followed by the character's name, and stat")
      b.send("To either add or remove from an existing value, use the /mod command, followed by the character's name, stat, and how much to add or delete; for example /mod John Doe health -1")
      b.send('/set & /mod can also be used to tweak the health of a character, instead of the attribute to modify, use health')
      b.send('To end the session, run /end')
    when %r{^/roll}
      if message.text.match(/4|6|8|10|12|20|100$/)
        b.send(rand(1..message.text.split(' ')[1].to_i))
      else
        unknown_roll(b)
      end
    when '/show'
      if s.show.length.positive?
        s.show.each do |char|
          b.send(char.name)
          b.send(char.race)
          general_stats.each do |stat|
            b.send("#{stat}: #{char.stats[stat]}")
          end
        end
      else
        b.send("It's dangerous to go alone")
        b.send('To add a new party member, use the /create command')
      end
    when '/create'
      c = Character.new
      b.send("What's the character's name?")
      bot.listen do |msg|
        if msg.text != s.exists?(msg.text)
          c.name = msg.text
          break
        else
          b.send('Sorry, that name is already registered')
        end
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
      s.add_char(c)
      b.send("#{c.name} has been saved!")
    when %r{^/delete}
      b.send("So you've chosen death")
      char_name = message.text.split(' ').shift.join(' ')
      if s.exists?(char_name)
        s.delete_char(char_name)
        b.send("#{char_name} is no more")
      else
        unknown_char(b)
      end
    when %r{^/set}
      b.send("Are you sure you're not cheating?")
    when '/stop'
      b.send('Until we see next time travelers')
      s.close
    else
      unknown_command(b)
    end
  end
end
