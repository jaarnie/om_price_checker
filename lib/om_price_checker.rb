# frozen_string_literal: true

class OmPriceChecker
  attr_accessor :liberty, :amazon, :spaceNK, :omorovicza

  DATE = Time.now.to_s.split.first

  def initialize
    @liberty = LibertyScraper.new
    @amazon = AmazonScraper.new
    @spaceNK = SpaceNKScraper.new
    @omorovicza = OmoroviczaScraper.new
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
    write_to_csv("space_nk_#{DATE}", data)
  end

  def omorovicza_list
    data = omorovicza.scrape_data
  end

  def create_comparison
    arr = []
    liberty_list.each_with_index do |liberty_hash, _index|
      hash = {
        name: liberty_hash[:name],
        liberty_price: {
          liberty_standard_price: liberty_hash[:price][:standard_price],
          liberty_sale_price: liberty_hash[:price][:sale_price]
        }
      }
      space_nk_list.select do |space_nk_hash|
        unless liberty_hash[:name].include?(space_nk_hash[:name])
          next
        end # needs to be strict comparison

        new_hash = {
          space_nk_price: {
            spaceNK_standard_price: space_nk_hash[:price][:standard_price],
            spaceNK_sale_price: space_nk_hash[:price][:sale_price]
          }
        }

        cheaper_price_hash = {
          cheapest_location: 'loc',
          cheapest_standard_price: cheapest_standard_price(liberty_hash[:price][:standard_price], space_nk_hash[:price][:standard_price])
        }

        hash.merge!(new_hash).merge!(cheaper_price_hash)
        arr << hash
      end
    end
    write_compare_to_csv("comparison_#{DATE}", arr)
  end

  def cheapest_standard_price(price_a, price_b)
    price_to_integer = ->(i) { i.split[-1].delete('£').to_i }
    price_array = [price_a, price_b].map(&price_to_integer)

    a = price_array[0]
    b = price_array[1]

    price_array.min.to_s.prepend('£') if a != b
  end

  def cheapest_location(loc_a, loc_b); end

  def write_compare_to_csv(file_name, data)
    CSV.open("#{file_name}.csv", 'wb') do |csv|
      headers = %w[names liberty_price liberty_sale_price space_nk_price space_nk_sale cheapest_location cheapest_standard_price]
      csv << headers
      data.each do |hash|
        csv << [
          hash[:name],
          hash[:liberty_price][:liberty_standard_price],
          hash[:liberty_price][:liberty_sale_price],
          hash[:space_nk_price][:spaceNK_standard_price],
          hash[:space_nk_price][:spaceNK_sale_price],
          hash[:cheapest_location],
          hash[:cheapest_standard_price]
        ]
      end
    end
  end

  def write_to_csv(file_name, data)
    CSV.open("#{file_name}.csv", 'wb') do |csv|
      headers = %w[names details standard_price sale_price promo]
      csv << headers
      data.each do |hash|
        csv << [
          hash[:name],
          hash[:info][:details],
          hash[:price][:standard_price],
          hash[:price][:sale_price],
          hash[:price][:promo]
        ]
      end
    end
  end
end
