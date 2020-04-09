# frozen_string_literal: true

class OmPriceChecker
  attr_accessor :liberty, :amazon, :spaceNK

  DATE = Time.now.to_s.split.first

  def initialize
    @liberty = LibertyScraper.new
    @amazon = AmazonScraper.new
    @spaceNK = SpaceNKScraper.new
  end

  def liberty_list
    data = liberty.scrape_data
    write_to_csv("liberty_#{DATE}", data)
  end

  def amazon_list
    # amazon.scrape_data
  end

  def space_nk_list
    data = spaceNK.scrape_data
    # write_to_csv("space_nk_#{DATE}", data)
  end

  def compare
    arr = []
    liberty_list.each_with_index do |hash, index|
      space_nk_list.select do |item|
        hash[:name].include?(item[:name])
        arr << item
      end
    end

    # liberty_list.each_with_index do |item, index|

    # end
    # liberty_list.each_with_index { |h, i| h.delete_if { |k, v| space_nk_list[i].key?(k) && space_nk_list[i][k] == v } }
    require 'pry'; binding.pry
  end

  def write_to_csv(file_name, data)
    CSV.open("#{file_name}.csv", "wb") do |csv|
      headers = ['names', 'details', 'standard_price', 'sale_price', 'promo']
      csv << headers
      data.each do |hash|
        csv << [hash[:name], hash[:info][:details], hash[:price][:standard_price], hash[:price][:sale_price], hash[:price][:promo]]
      end

    end
  end
end
