require 'time'
require 'net/http'
require 'country_lookup'

class BotUser
  def initialize(bot:, message:)
    @bot = bot
    @message = message
  end

  def send_welcome_message
    @bot.api.send_message(chat_id: @message.chat.id, text: "Hello, #{@message.from.first_name}\r\n#{HelpMessage.new(bot: @bot, message: @message).help_msg}")
  end

  def reply_invalid_format
    @bot.api.send_message(chat_id: @message.chat.id, text: "Invalid input format. Try again!\r\n" + HelpMessage.new(bot: @bot, message: @message).help_msg)
  end
end

class WeatherInfo
  def initialize(bot:, message:)
    @bot = bot
    @message = message
  end

  def send_response
    city = @message.text.slice('/weather'.length, @message.text.length).lstrip
    if !city
      @bot.api.send_message(chat_id: @message.chat.id, text: 'City not provided. Try again!')
    else
      url = URI('http://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + OPENWEATHERMAP_API_KEY)
      weather_html = Net::HTTP.get(url)
      weather = Scraper.parse_json(weather_html)
      if weather['cod'] == '404' || weather['message'] == 'city not found'
        @bot.api.send_message(chat_id: @message.chat.id, text: 'City not found! Provide a valid city.')
      else
        @bot.api.send_message(chat_id: @message.chat.id, text: Format.output_message(weather))
      end
    end
  end
end

class HelpMessage
  def initialize(bot:, message:)
    @bot = bot
    @message = message
  end

  def send_response
    @bot.api.send_message(chat_id: @message.chat.id, text: help_msg)
  end

  def help_msg
    "\r\nEnter /weather <city> or /weather <city>,<country code> to get weather info."\
    "\r\nSend /end to end the chat. Use /start to start again next time."
  end
end

class MessageHandler
  attr_reader :bot, :message

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def handle_message
    case @message.text
    when '/start'
      BotUser.new(bot: @bot, message: @message).send_welcome_message
    when '/end'
      @bot.api.send_message(chat_id: @message.chat.id, text: "Bye, #{@message.from.first_name}!")
    when %r{\A/weather +\w+}
      WeatherInfo.new(bot: @bot, message: @message).send_response
    when '/help'
      HelpMessage.new(bot: @bot, message: @message).send_response
    else
      BotUser.new(bot: @bot, message: @message).reply_invalid_format
    end
  end
end
