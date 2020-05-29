require 'nokogiri'
require 'httparty'
require 'telegram/bot'
require 'country_lookup'
require_relative '../lib/scraper.rb'
require_relative '../lib/api_keys.rb'
require_relative '../lib/tele_bot.rb'

bot = Telebot.new(TELEGRAM_API_TOKEN)

bot.run
