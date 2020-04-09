require 'httparty'
require 'nokogiri'

class SpaceNKScraper
  attr_accessor :document, :names

  COLLECT_TEXT = ->(x) { x.text.split.join(' ') }

  def initialize
    url = 'https://www.spacenk.com/uk/en_GB/brands/o/omorovicza/'
    unparsed_document = HTTParty.get(url)
    @document ||= Nokogiri::HTML(unparsed_document)
    @names = document.css(".product-tile_name").map(&COLLECT_TEXT)
  end

  def scrape_data
    names = @names
    links = document.css(".js-set-scroll-value.product-tile_title").map { |x| x["href"]}
    standard_prices = document.css(".product-sales-price").map(&COLLECT_TEXT)

    create_hash_array(names, links, standard_prices)
  end

  def get_names
    names
  end

  def create_hash_array(names, links, standard_prices)
    item_array = []

    names.each_with_index do |value, index|
      item = {
        name: names[index],
        info: {
          details: nil,
          link: "https://www.spacenk.com" + links[index],
          image: nil,
        },
        price: {
          standard_price: standard_prices[index],
          sale_price: nil,
          savings_percentage: nil
        }
      }
      item_array << item
    end
    item_array
  end
end
