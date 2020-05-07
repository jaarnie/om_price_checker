# frozen_string_literal: true

require_relative '../config/environment'

om = OmPriceChecker.new
# om.liberty_list
# om.space_nk_list
om.omorovicza_list

om.create_comparison

# om.amazon_list
