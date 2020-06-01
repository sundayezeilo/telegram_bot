require_relative '../lib/parser'
require_relative '../lib/api_keys'
require_relative '../lib/tele_bot'
require 'telegram/bot'

class TeleBot
  def run_bot(token)
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        MessageHandler.new(bot, message).handle_message
      end
    end
  end
end

TeleBot.new.run_bot(TELEGRAM_API_TOKEN)
