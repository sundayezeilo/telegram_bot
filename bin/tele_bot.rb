require 'nokogiri'
# require 'open-uri'
require 'httparty'
require 'telegram/bot'
require 'country_lookup'
require_relative '../lib/scraper.rb'
require_relative '../lib/api_keys.rb'
require_relative '../lib/output.rb'

chat_id_log = {}

Telegram::Bot::Client.run(TELEGRAM_API_TOKEN) do |bot|
  bot.listen do |message|
    if message.text == '/start'
      unless chat_id_log[message.chat.id.to_s]
        chat_id_log[message.chat.id.to_s] = message.chat.id
        text = welcome_message
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}#{text}")
      end
    elsif message.text == '/end'
      chat_id_log.delete(message.chat.id.to_s)
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    elsif message.text.match(%r{\A/weather +\w+}) # matches weather plus one or more spaces at the start of a string, then one or more characters that follows
      city = message.text.slice('/weather'.length, message.text.length).lstrip
      if !city
        bot.api.send_message(chat_id: message.chat.id, text: 'City not provided. Try again!')
      else
        url = 'http://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + OPENWEATHERMAP_API_KEY
        weather_html = HTTParty.get(url).to_s
        weather = Scraper.parse_json(weather_html)
        if weather['cod'] == '404' || weather['message'] == 'city not found'
          bot.api.send_message(chat_id: message.chat.id, text: 'City not found! Provide a valid city.')
        else
          chat_id = message.chat.id
          text = Format.output_message(weather)
          bot.api.send_message(chat_id: chat_id, text: text)
        end
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Invalid input format. Try again!\r\nEnter /weather <city> or /weather <city>,<country code> to get weather info")
    end
  end
end
