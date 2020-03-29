# module OmPriceChecker
#   class Main
#   attr_accessor :liberty

#     def initialize
#       @liberty = LibertyScraper.new
#     end

#     def liberty_list
#       names = liberty.get_names
#       details = liberty.get_product_details
#       prices = liberty.get_prices
#       standard_price = liberty.get_standard_price
#       sale_price = liberty.get_sale_price
#       promo = liberty.get_promo_details
#       # write_to_csv(names)

#     end

#     def write_to_csv(names)
#       CSV.open("liberty_data.csv", "wb") do |csv|
#         require 'pry'; binding.pry
#         csv << names
#       end 
#     end

#     require 'pry'; binding.pry

#   end
# end

class OmPriceChecker
  attr_accessor :liberty

    def initialize
      @liberty = LibertyScraper.new
    end

    def liberty_list
      require 'pry'; binding.pry
      liberty.scrape_data
    end



    # def write_to_csv(names, details, standard_price, sale_price, promo)
    #   # CSV.open("liberty_data.csv", "wb") do |csv|
    #   #   require 'pry'; binding.pry
    #   #   csv << names
    #   # end 
    #   CSV.open("liberty_data.csv", "wb") do |csv|
    #     CSV.foreach('liberty_data.csv', :headers => true) do |row|
    #       require 'pry'; binding.pry
    #       names = row['names']
    #       details = row['details']
    #       standard_price = row['standard_price']
    #       sale_price = row['sale_price']
    #       promo = row['promo']
    #       csv << [names, details, standard_price, sale_price, promo]
    #       # or, to output it as a single column:
    #       # csv << ["#{fn[0]}#{ln}#{id[3,8]}"]
    #     end
    #   end
      
    # end
    

end

