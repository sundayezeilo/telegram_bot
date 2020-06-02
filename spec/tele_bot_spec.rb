require_relative '../lib/parser.rb'
require_relative '../lib/api_keys.rb'
require_relative '../lib/tele_bot.rb'
require 'telegram/bot'
require_relative 'spec_helper'

describe BotUser do
  it 'fires run on telegram bot' do
    expect(bot).to receive(:api)
    BotUser.new(bot: bot, message: message).send_welcome_message
  end

  it 'fires listener' do
    expect(api).to receive(:send_message)
    BotUser.new(bot: bot, message: message).send_welcome_message
  end
end
