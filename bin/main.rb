require_relative '../lib/parser.rb'
require_relative '../lib/api_keys.rb'
require_relative '../lib/tele_bot.rb'
require 'telegram/bot'


def run_bot(token)
  @id_array = []
  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      @id_array.push(message.chat.id) unless @id_array.include?(message.chat.id)
      MessageHandler.new(bot, message).handle_message
    end
  end
end


run_bot(TELEGRAM_API_TOKEN)

# @id_array.delete(message.chat.id) if 