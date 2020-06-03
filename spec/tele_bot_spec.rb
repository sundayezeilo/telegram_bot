require_relative '../lib/parser.rb'
# require_relative '../lib/api_keys.rb'
require_relative '../lib/tele_bot.rb'
require 'telegram/bot'
require_relative 'spec_helper'

RSpec.describe 'BotUser' do
  describe '#send_welcome_message' do

    let(:mock_bot) { double }
    let(:mock_message) { double }
    let(:mock_chat) { double }
    let(:mock_from) { double }
    let(:mock_api) { double }

    it 'Invokes send_message on bot.api object with correct arguments' do
      allow(mock_chat).to receive(:id)
      allow(mock_message).to receive(:chat) { mock_chat }
      allow(mock_message).to receive(:from) { mock_from }
      allow(mock_from).to receive(:first_name)
      allow(mock_api).to receive(:send_message)
      allow(mock_bot).to receive(:api) { mock_api }

      user = BotUser.new(mock_bot)
      expect(mock_bot).to receive(:api)
      user.send_welcome_message(mock_message)
    end
  end
end
