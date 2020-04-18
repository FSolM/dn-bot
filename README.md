# DnBot

#### A Telegram Bot that manages a DnD party

## About

`DnBot` is a Telegram bot that works as a party manager and dice roller for simple DnD parties.

The bot can manage an assortment of dice rolls, and can save the members of a party with their stats and health.

## Details

The bot is available at `t.me/doublednbot` in the telegram app.

## Installation

This bot was made using [atiplugin's telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) framework; follow it's instructions for the installation of the base framework.

To use the bot, change this line in `app.rb` with our own Token access code

```ruby
token = Token.new
```

And then simply compile the code.

This project contains a Testing Suite that can be access by executing the command

```
$ rspec
```

## Known Issues

Multiple messages or commands in a row may result in the bot crashing, please, wait until the bot has responded to send another message.

## Planned Implementations

- Better flow in the bot
- Managing multiple commands without breaking the bot
- More options to customizable options

## Docs

If you have any questions regarding the commands, the bot can execute `/help` and will display a list of all available commands.

## Contact

Carlos Sol: [@FSolM](https://github.com/FSolM)
