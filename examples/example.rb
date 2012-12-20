require "rubygems"
require 'octopart-ruby'

@octopart = Octopart::Client.new('02566ff6')

# Fetch a category object by its id
puts @octopart.category(4174)

# Fetch multiple category objects by their ids
puts @octopart.categories([4215,4174,4780])

# Execute search over category objects
puts @octopart.search_categories('resistor')

# Fetch a part object by its id
puts @octopart.part(39619421)

# Fetch multiple part objects by their ids
puts @octopart.parts([39619421,29035751,31119928])

# Execute search over part objects
puts @octopart.search_parts('resistor')

# Suggest a part search query string
puts @octopart.suggest_parts('sn74f')

# Match (manufacturer,mpn) to part uids
puts @octopart.match_part('texas instruments', 'SN74LS240N')

# Fetch a partattribute object by its id
puts @octopart.part_attribute('capacitance')

# Fetch multiple partattribute objects by their ids
puts @octopart.part_attributes(["capacitance","resistance"])

# Match lines of a BOM to parts
puts @octopart.bom_match({"mpn_or_sku"=> "60K6871", "manufacturer"=> "Texas Instruments"})
