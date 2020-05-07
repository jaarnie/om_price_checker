# frozen_string_literal: true

# require "om_scraper/version"
require 'httparty'
require 'nokogiri'

class LibertyScraper
  attr_accessor :document, :names

  COLLECT_TEXT = ->(x) { x.text.split.join(' ') }

  def initialize
    url = 'https://www.libertylondon.com/uk/search?q=Omorovicza'
    unparsed_document = HTTParty.get(url)
    @document ||= Nokogiri::HTML(unparsed_document)
    @names = document.css('.product-name').map(&COLLECT_TEXT)
  end

  def scrape_data
    names = @names
    details = document.css('.product-description').map(&COLLECT_TEXT)
    links = document.css('.quick-view').map { |x| x.attributes['href'].value }
    images = document.css('.alt-img').map { |x| x['data-src'] }
    prices = document.css('.product-price').map(&COLLECT_TEXT)
    standard_prices = document.css('.price-standard').map(&COLLECT_TEXT)
    sale_prices = document.css('.price-sales').map(&COLLECT_TEXT)
    promo_messages = document.css('.product-promo').map(&COLLECT_TEXT)

    create_hash_array(names, details, links, images, standard_prices, sale_prices, promo_messages)
  end

  def get_names
    names
  end

  def get_savings_percentage(standard_price, sale_price)
    standard_price = standard_price.gsub('£', '').to_f
    sale_price = sale_price.gsub('£', '').to_f

    savings = (sale_price / standard_price * 100) - 100
    savings.round.to_s + '%'
  end

  def show_sale_price(standard_price, sale_price)
    return sale_price unless sale_price != standard_price
  end

  def create_hash_array(names, details, links, images, standard_prices, sale_prices, _promo_messages)
    item_array = []
    names.each_with_index do |_value, index|
      item = {
        name: names[index],
        info: {
          details: details[index],
          link: 'https://www.libertylondon.com' + links[index],
          image: images[index]
        },
        price: {
          standard_price: standard_prices[index] || sale_prices[index],
          sale_price: show_sale_price(standard_prices[index], sale_prices[index]),
          savings_percentage: standard_prices[index] && get_savings_percentage(standard_prices[index], sale_prices[index])
        }
      }
      item_array << item
    end
    item_array
  end
end
