require 'time'

module Format  
  def self.output_time(t_raw, timezone)
    Time.at(t_raw, in: timezone).strftime("%I:%M %p\r\n%A, %B %d, %Y\r\n")
  end

  def self.output_message(weather)
    city = weather['name']
    cloud_cond = weather['weather'].first['description'].split(' ').map(&:capitalize).join(' ')
    temp_cel = (weather['main']['temp'] - 273.15).round
    temp_fah = ((weather['main']['temp'] - 273.15) * 1.8 + 32).round
    pressure = weather['main']['pressure']
    humidity = weather['main']['humidity']
    wind_speed = weather['wind']['speed']
    local_time = output_time(weather['dt'], weather['timezone'])
    country = Country.with_postal_code[weather['sys']['country']]

    "#{city}, #{country}"\
    "\r\nLocal Time: #{local_time}"\
    "\r\nWeather:"\
    "\r\nTemperature: #{temp_cel}°C | #{temp_fah}°F"\
    "\r\nCloud Condition: #{cloud_cond}"\
    "\r\nPressure: #{pressure} hPa"\
    "\r\nHumidity: #{humidity}%"\
    "\r\nWind Speed: #{wind_speed} m/s"
  end

  def self.welcome_message
    "\r\nEnter /weather <city> or /weather <city>,<country code> to get weather info."\
    "\r\nSend /end to end the chat. Use /start to start again next time."
  end
end
