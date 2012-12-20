# A simple ruby wrapper for the Octopart.com API
# All methods are module methods and should be called on the Octopart module.
#
# @example
#
#   Octopart::Client.new('apikey')
#   
module Octopart
  
  # An Octopart.com API Client
  # 
  #
  # @example
  #
  #   Octopart::Client.new('apikey')
  #
  class Client
    
    include HTTParty
    base_uri 'http://octopart.com/api/v2'
    format :json
    
    
    # The API key for the client
    attr_reader :api_key
    
    # Initialize an Octopart client
    #
    # @note You can get an Octopart API key at http://octopart.com/api/register
    # @param api_key [String] The API key to use
    def initialize(api_key=nil)
      @api_key = api_key
      @api_key ||= Octopart.api_key

    end
    
    
    # Fetch a category object by its id
    #
    # @param id [String] The id of a category object
    # @return [Hash] A category hash
    # @example
    #   category(4174)
    #   # => [Hash]
    def category(id)
      if id.is_a? Array
        categories(id)
      else
        response = self.class.get('/categories/get', :query => {:id => id, :apikey => @api_key})
        validate_response(response)
      end
    end
    
    
    # Fetch multiple category objects by their ids
    #
    # @param ids [Array] Array of category object ids
    # @return [Hash] A category hash
    # @example
    #   categories([4215,4174,4780])
    #   # => [Hash]
    def categories(ids)
      raise(ArgumentError, 'ids must be an array') unless ids.is_a?Array
      response = self.class.get('/categories/get_multi', :query => {:ids => "[#{ids.join(",")}]", :apikey => @api_key})
      validate_response(response)
    end
    
    # Execute search over category objects
    #
    # @param query [String] Query string
    # @param start [Integer] Ordinal position of first result. First position is 0. Default is 0
    # @param limit [Integer] Maximum number of results to return. Default is 10
    # @return [Hash] A category hash
    # @example
    #   search_categories('resistor')
    #   # => [Hash]
    def search_categories(query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters and start/limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 100) &&limit.between?(0,100))    
      response = self.class.get('/categories/search', :query => {:q => query, :start => start, :limit => limit, :apikey => @api_key})
      validate_response(response)
    end
    
    # Fetch a part object by its id
    #
    # @param uid [String] the id of a part object 
    # @return [Hash] A part hash
    # @example
    #   part(39619421)
    #   # => [Hash]
    def part(uid)
      if uid.is_a? Array
        parts(uid)
      else
        response = self.class.get('/parts/get', :query => {:uid => uid, :apikey => @api_key})
        validate_response(response)
      end
    end
    
    # Fetch multiple part objects by their ids
    #
    # @param uids [Array] JSON encoded list of part object ids. Max number of ids is 100.
    # @return [Hash] A part hash
    # @example
    #   parts([39619421,29035751,31119928])
    #   # => [Hash]
    def parts(uids)
      raise(ArgumentError, 'uids must be an array') unless uids.is_a?Array
      response = self.class.get('/parts/get_multi', :query => {:uids => "[#{uids.join(",")}]", :apikey => @api_key})
      validate_response(response)
    end
     
    # Execute search over part objects
    #
    # @param query [String] Query string 
    # @param start [Integer] Ordinal position of first result. First position is 0. Default is 0. Maximum is 1000.
    # @param limit [Integer] Number of results to return. Default is 10. Maximum is 100.
    # @return [Hash] A part hash
    # @example
    #   search_parts('capacitor')
    #   # => [Hash]
    #
    #   search_parts('capacitor', 50)
    #   # => [Hash]
    #
    #   search_parts('capacitor', 100, 25)
    #   # => [Hash]
    def search_parts(query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters, start < 1000, and limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 1000) &&limit.between?(0,100))
      response = self.class.get('/parts/search', :query => {:q => query, :start => start, :limit => limit, :apikey => @api_key})
      validate_response(response)
    end
     
    # Suggest a part search query string
    #
    # @param query [String] Query string. Minimum of 2 characters.
    # @param limit [Integer] Maximum number of results to return. Default is 5. Maximum is 10.
    # @return [Hash] A part hash
    # @example
    #   suggest_parts('sn74f')
    #   # => [Hash]
    #
    #   suggest_parts('sn74f', 10)
    #   # => [Hash]
    def suggest_parts(query, limit=5)
      raise(ArgumentError, 'query must be a string > 2 characters, and limit must be < 10') unless (query.is_a?(String) && query.length > 2 && limit.between?(0,10))
      response = self.class.get('/parts/suggest', :query => {:q => query.split(' ').join('+'), :limit => limit, :apikey => @api_key})
    end
     
    # Match (manufacturer,mpn) to part uids
    #
    # @param manufacturer_name [String] Manufacturer name
    # @param mpn [String] Manufacturer part number
    # @return [Hash] A part hash
    # @example
    #   match_part('Texas Instruments', 'SN74LS240N')
    #   # => [Hash]
    def match_part(manufacturer_name, mpn)
      response = self.class.get('/parts/match', :query => {:manufacturer_name => manufacturer_name, :mpn => mpn, :apikey => @api_key})
      validate_response(response)
    end
    
    # Fetch a partattribute object by its id
    #
    # @param fieldname [String] The fieldname of a partattribute object
    # @return [Hash] A part attribute hash
    # @example
    #   part_attribute('capacitance')
    #   # => [Hash]
    def part_attribute(fieldname)
      if fieldname.is_a? Array
          part_attributes(fieldname)
      else
        response = self.class.get('/partattributes/get', :query => {:fieldname => fieldname, :apikey => @api_key})
        validate_response(response)
      end
    end
    
    # Fetch multiple partattribute objects by their ids
    #
    # @param fieldnames [Array] The fieldnames of a partattribute objects
    # @return [Hash] A part attribute hash
    # @example
    #   part_attributes(['capacitance', 'resistance'])
    #   # => partattribute hash
    def part_attributes(fieldnames)
      raise(ArgumentError, 'fieldnames must be an array') unless fieldnames.is_a?Array
      response = self.class.get('/partattributes/get_multi', :query => {:fieldnames => "["+fieldnames.map{|v| "\"#{v}\""}.join(',')+"]", :apikey => @api_key})
      validate_response(response)
    end
     
    # Match lines of a BOM to parts
    #
    # @param lines [Hash] hash made up of the following optional parameters:
    # @option lines q [String]  Free form query 
    # @option lines mpn [String]  MPN string 
    # @option lines manufacturer [String]  Manufacturer name 
    # @option lines sku [String]  Supplier SKU string 
    # @option lines supplier [String]  Supplier name 
    # @option lines mpn_or_sku [String]  Match on MPN or SKU 
    # @option lines start [Integer] Ordinal position of first item 
    # @option lines limit [Integer] Maximum number of items to return 
    # @option lines reference [String] Arbitrary reference string to differentiate results
    # @return [Hash] A match hash
    # @example
    #   bom_match({"mpn_or_sku"=> "60K6871", "manufacturer" => "Texas Instruments"})
    #   # => [Hash]
    def bom_match(lines)
      raise(ArgumentError, 'lines must be a hash') unless lines.is_a?(::Hash)
      response = self.class.get('/bom/match', :query => {:lines => "[{"+lines.map{|k,v| "\"#{k}\":\"#{v}\""}.join(',')+"}]", :apikey => @api_key})
      validate_response(response)
    end
    
    # Helper method for searches
    #
    # @param type [String] String name of the type
    # @param query [String] Query string 
    # @param start [Integer] Ordinal position of first result. First position is 0. Default is 0. Maximum is 1000.
    # @param limit [Integer] Number of results to return. Default is 10. Maximum is 100.
    # @return [Hash] A part hash
    # @example
    #   search_parts('parts', 'capacitor')
    #   # => [Hash]
    #
    #   search_parts('categories', 'capacitor', 50)
    #   # => [Hash]
    #
    #   search_parts('parts', 'capacitor', 100, 25)
    #   # => [Hash]
    def search(type, query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters and start/limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 100) &&limit.between?(0,100))
      if type.downcase == 'part' || type.downcase == 'parts'
        search_parts(query, start, limit)
      elsif type.downcase == 'category' || type.downcase == 'categories'
        search_categories(query, start, limit)
      else
        raise(ArgumentError, "type must be either 'parts' or 'categories'")
      end
    end
    
    alias_method :match, :match_part
    
    protected
    
      def validate_response(response)
        response.code == 200 ? response.parsed_response : raise(APIResponseError, response.code)
      end
    
  end

end
