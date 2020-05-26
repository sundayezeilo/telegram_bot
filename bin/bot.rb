require 'telegram/bot'
require 'nokogiri'
# require 'open-uri'
require 'httparty'
require '../lib/scraper.rb'
require '../lib/api_keys.rb'
require 'country_lookup'
require 'time'

def scraper(html)
  JSON.parse(html)
end

chat_id_log = {}

Telegram::Bot::Client.run(YOUR_TELEGRAM_API_TOKEN) do |bot|
  bot.listen do |message|
    if message.text == '/start'
      if !chat_id_log[(message.chat.id).to_s]
        chat_id_log[(message.chat.id).to_s] = message.chat.id
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}\r\nEnter /weather <city> or /weather <city>,<country code> to get weather info\r\nSend /end to end the chat. Use /start to start again next time.")
      end
    elsif message.text == '/end'
      chat_id_log.delete((message.chat.id).to_s)
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}!")
    elsif message.text.match(/\A\/weather +\w+/)   # matches weather plus one or more spaces at the start of a string, then one or more characters that follows
      city = message.text.slice("/weather".length, message.text.length).lstrip
      if !city
        bot.api.send_message(chat_id: message.chat.id, text: "City not provided. Try again!")
      else
        url = "http://api.openweathermap.org/data/2.5/weather?q="+city+"&appid="+YOUR_OPENWEATHERMAP_API_KEY
        weather_html = HTTParty.get(url).to_s
        weather = scraper(weather_html)
        if weather["cod"] == "404" || weather["message"] == "city not found"
          bot.api.send_message(chat_id: message.chat.id, text: "City not found! Provide a valid city.")
        else
          chat_id = message.chat.id
          city = weather["name"]
          cloud_cond = weather["weather"].first["description"]
          temp = (weather["main"]["temp"] - 272.15).round
          time = weather["dt"]
          local_time = Time.at(time)
          country = Country.with_postal_code[weather["sys"]["country"]]
          text = "It's #{temp}°C in #{city}, #{country}, with #{cloud_cond},\r\nLocal time: #{local_time}."

          bot.api.send_message(chat_id: chat_id, text: text)
        end
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Invalid input format. Try again!\r\nEnter /weather <city> or /weather <city>,<country code> to get weather info")
    end
  end
end

# .match(/\/weather +/)
# ^[a-zA-Z]+$ #matches only strings that consist of one or more letters only (^ and $ mark the begin and end of a string respectively).
#{"cod":"404","message":"city not found"}

# {"coord":{"lon":3.75,"lat":6.58},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":304.15,"feels_like":307.27,"temp_min":304.15,"temp_max":304.15,"pressure":1013,"humidity":70},"visibility":8000,"wind":{"speed":4.6,"deg":200},"clouds":{"all":75},"dt":1590498434,"sys":{"type":1,"id":1185,"country":"NG","sunrise":1590470904,"sunset":1590515766},"timezone":3600,"id":2332453,"name":"Lagos","cod":200}