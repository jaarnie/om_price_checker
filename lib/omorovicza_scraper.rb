# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

class OmoroviczaScraper
  attr_accessor :document, :names

  COLLECT_TEXT = ->(x) { x.text.split.join(' ') }

  def initialize
    moisturisers_url = 'https://www.omorovicza.com/uk/skincare/moisturisers.html'
    unparsed_document = HTTParty.get(moisturisers_url)
    @document ||= Nokogiri::HTML(unparsed_document)
  end

  def scrape_data
    names = document.css('.product-item-link').map(&COLLECT_TEXT)
    links = document.css('.product.photo.product-item-photo').map { |x| x['href'] }
    standard_prices = document.css('[data-product-price]').map(&COLLECT_TEXT)

    create_hash_array(names, links, standard_prices)
  end

  def create_hash_array(names, links, standard_prices)
    item_array = []

    names.each_with_index do |_value, index|
      item = {
        name: names[index],
        info: {
          details: nil,
          link: 'https://www.spacenk.com' + links[index],
          image: nil
        },
        price: {
          standard_price: standard_prices[index].split.last,
          sale_price: nil,
          savings_percentage: nil
        }
      }
      item_array << item
    end
    item_array
  end
end
