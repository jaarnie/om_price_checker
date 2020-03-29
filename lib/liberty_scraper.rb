# frozen_string_literal: true

# require "om_scraper/version"
require 'httparty'
require 'nokogiri'

class LibertyScraper
  attr_accessor :document

  COLLECT_TEXT = ->(x) { x.text.split.join(' ') }

  def initialize
    # url = "https://www.omorovicza.com/uk/"
    url = 'https://www.libertylondon.com/uk/search?q=Omorovicza'
    unparsed_document = HTTParty.get(url)
    @document ||= Nokogiri::HTML(unparsed_document)
  end

  def scrape_data
    names = document.css('.product-name').map(&COLLECT_TEXT)
    details = document.css('.product-description').map(&COLLECT_TEXT)
    links = document.css('.quick-view').map { |x| x.attributes['href'].value }
    images = document.css('.alt-img').map { |x| x['data-src'] }
    prices = document.css('.product-price').map(&COLLECT_TEXT)
    standard_prices = document.css('.price-standard').map(&COLLECT_TEXT)
    sale_prices = document.css('.price-sales').map(&COLLECT_TEXT)
    promo_messages = document.css('.product-promo').map(&COLLECT_TEXT)

    create_hash_array(names, details, links, images, standard_prices, sale_prices, promo_messages)
  end

  def create_hash_array(names, details, links, images, standard_prices, sale_prices, promo_messages)
    item_array = []
    names.each_with_index do |value, index|
      # item_array = [names[index], details[index], links[index], images[index], standard_prices[index], sale_prices[index], promo_messages[index]]
      item = {
        name: names[index],
        info: {
          details: details[index],
          link: links[index],
          image: images[index],
        },
        price: {
          standard_price: standard_prices[index],
          sale_price: sale_prices[index],
          saving_percentage: promo_messages[index],
        }
      }
      item_array << item
    end
    item_array
  end

  # scraper = LibertyScraper.new
  # scraper.scrape_data
end
