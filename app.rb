# frozen_string_literal: true

require 'telegram/bot'
Dir['./lib/*.rb'].each { |file| require file }

token = Token.new

general_stats = %i[ATK DEF AGL DEX INT CHA]

b = BotCalls.new
s = Session.new

def start(bot)
  bot.send('Hello there traveler, ready to start the journey?')
  bot.send('If you are new to this bot, please consider running the /help command to familiarize yourself with this bot')
end

def help(bot)
  bot.send('To roll a dice, run /roll followed by the type of dice you wanna roll; for example: /roll 10 to roll a 10 faced die')
  bot.send('To show party, use the /show command')
  bot.send("To show just the party's health, use the /show command followed by health, like /show health")
  bot.send('To create a new character, run the command /create')
  bot.send("To delete an existing character, run /delete followed by the character's name")
  bot.send("To reset a character stat, run /set followed by the character's name, and stat")
  bot.send("To either add or remove from an existing value, use the /mod command, followed by the character's name, stat, and how much to add or delete; for example /mod John Doe health -1")
  bot.send('/set & /mod can also be used to tweak the health of a character, instead of the attribute to modify, use health')
  bot.send('To end the session, run /end')
end

def show_alt_text(bot)
  bot.send("It's dangerous to go alone")
  bot.send('To add a new party member, use the /create command')
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

def unknown_char(bot)
  bot.send('Perhaps the archives are incomplete...')
  bot.send('Seems like the character you tried to search is not present in the party')
end

def unknown_attr(bot)
  bot.send("You can't do that! I'll shoot you or something")
  bot.send('You can only modify an attribute or a health value')
end

Telegram::Bot::Client.run(token.id) do |bot|
  b.bot = bot
  bot.listen do |message|
    b.msg = message
    case message.text
    when '/start'
      start(b)
    when '/help'
      help(b)
    when %r{^/roll}
      if message.text.match(/4|6|8|10|12|20|100$/)
        b.send(rand(1..message.text.split(' ')[1].to_i))
      else
        unknown_roll(b)
      end
    when %r{^/show}
      if s.char_list.length.positive?
        if message.text.match(/health$/i)
          s.char_list.each { |char| b.send("#{char.name}: #{char.health}") }
        else
          s.char_list.each do |char|
            b.send(char.name)
            b.send(char.race)
            general_stats.each do |stat|
              b.send("#{stat}: #{char.stats[stat]}")
            end
          end
        end
      else
        show_alt_text(b)
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
      arr = message.text.split(' ')
      char_name = arr[1...(arr.length - 2)].join(' ')
      if s.exists?(char_name)
        if arr[-2].match(/health/i)
          s.update_char(char_name, 'health', arr[-1].to_i)
          b.send("Health modified to #{arr[-1].to_i}")
        elsif arr[-2].match(/atk|def|agl|dex|int|cha/i)
          s.update_char(char_name, arr[-2].upcase!, arr[-1].to_i)
          b.send("#{arr[-2]} modified to #{arr[-1].to_i}")
        else
          unknown_attr(b)
        end
      else
        unknown_char(b)
      end
    when %r{^/mod}
      b.send('Twice the pride, double the fall')
      arr = message.text.split(' ')
      char_name = arr[1...(arr.length - 2)].join(' ')
      if s.exists?(char_name)
        if arr[-2].match(/health/i)
          s.mod_char(char_name, 'health', arr[-1].to_i)
          b.send("Health modified to #{arr[-1].to_i}")
        elsif arr[-2].match(/atk|def|agl|dex|int|cha/i)
          s.mod_char(char_name, arr[-2].upcase!, arr[-1].to_i)
          b.send("#{arr[-2]} modified to #{arr[-1].to_i}")
        else
          unknown_attr(b)
        end
      else
        unknown_char(b)
      end
    when '/end'
      b.send('Until we see next time travelers')
      s.close
    else
      unknown_command(b)
    end
  end
end
