# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

class AmazonScraper
  attr_accessor :document
  def initialize
    url = 'https://www.amazon.co.uk/s?k=omorovicza&crid=17SRMTUMR1BVD&sprefix=omor%2Caps%2C148&ref=nb_sb_ss_i_3_4'
    unparsed_document = HTTParty.get(url)
    @document ||= Nokogiri::HTML(unparsed_document)
  end

  def scrape_data
    # require 'pry'; binding.pry
  end

  scraper = AmazonScraper.new
  scraper.scrape_data
end
