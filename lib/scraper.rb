require 'json'

module Scraper
  def self.parse_json(html)
    JSON.parse(html)
  end
end