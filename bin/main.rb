require_relative '../lib/parser.rb'
require_relative '../lib/api_keys.rb'
require_relative '../lib/tele_bot.rb'
require 'telegram/bot'

def run_bot(token)
  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      MessageHandler.new(bot, message).handle_message
    end
  end
end

run_bot(TELEGRAM_API_TOKEN)
