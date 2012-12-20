# Public: A simple ruby wrapper for the Octopart.com API
# All methods are module methods and should be called on the Octopart module.
#
# Examples
#
#   Octopart::Client.new('apikey')
#   
module Octopart
  
  # Public: An Octopart.com API Client
  # 
  #
  # Examples
  #
  #   Octopart::Client.new('apikey')
  #
  class Client
    
    include HTTParty
    base_uri 'http://octopart.com/api/v2'
    format :json
    
    
    # Public: The API key for the client
    attr_reader :api_key
    
    # Public: Initialize an Octopart client
    #
    # api_key -  The API key to use
    # You can get an Octopart API key at http://octopart.com/api/register
    def initialize(api_key=nil)
      @api_key = api_key
      @api_key ||= Octopart.api_key
      
    end
    
    
    # Public: Fetch a category object by its id
    #
    # id  - The id of a category object
    #
    # Examples
    #
    #   category(4174)
    #   # => category hash
    #
    # Returns a category hash
    def category(id)
      if id.is_a? Array
        categories(id)
      else
        response = self.class.get('/categories/get', :query => {:id => id, :apikey => @api_key})
        validate_response(response)
      end
    end
    
    
    # Public: Fetch multiple category objects by their ids
    #
    # ids  - Array of category object ids
    #
    # Examples
    #
    #   categories([4215,4174,4780])
    #   # => category hash
    #
    # Returns a category hash
    def categories(ids)
      raise(ArgumentError, 'ids must be an array') unless ids.is_a?Array
      response = self.class.get('/categories/get_multi', :query => {:ids => "[#{ids.join(",")}]", :apikey => @api_key})
      validate_response(response)
    end
    
    # Public: Execute search over category objects
    #
    # q - Query string
    # start - Ordinal position of first result. First position is 0. Default is 0
    # limit - Maximum number of results to return. Default is 10
    #
    # Examples
    #
    #   search_categories('resistor')
    #   # => category hash
    #
    # Returns a category hash
    def search_categories(query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters and start/limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 100) &&limit.between?(0,100))    
      response = self.class.get('/categories/search', :query => {:q => query, :start => start, :limit => limit, :apikey => @api_key})
      validate_response(response)
    end
    
    # Public: Fetch a part object by its id
    #
    # uid  - the id of a part object 
    #
    # Examples
    #
    #   part(39619421)
    #   # => part hash
    #
    # Returns a part hash
    def part(uid)
      if uid.is_a? Array
        parts(uid)
      else
        response = self.class.get('/parts/get', :query => {:uid => uid, :apikey => @api_key})
        validate_response(response)
      end
    end
    
    # Public: Fetch multiple part objects by their ids
    #
    # uids - JSON encoded list of part object ids. Max number of ids is 100.
    #
    # Examples
    #
    #   parts([39619421,29035751,31119928])
    #   # => parts hash
    #
    # Returns a part hash
    def parts(uids)
      raise(ArgumentError, 'uids must be an array') unless uids.is_a?Array
      response = self.class.get('/parts/get_multi', :query => {:uids => "[#{uids.join(",")}]", :apikey => @api_key})
      validate_response(response)
    end
     
    # Public: Execute search over part objects
    #
    # query - Query string 
    # start - Ordinal position of first result. First position is 0. Default is 0. Maximum is 1000.
    # limit - Number of results to return. Default is 10. Maximum is 100.
    #
    # Examples
    #
    #   search_parts('capacitor')
    #   # => part hash
    #
    #   search_parts('capacitor', 50)
    #   # => part hash
    #
    #   search_parts('capacitor', 100, 25)
    #   # => part hash
    # 
    # Returns a part hash
    def search_parts(query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters, start < 1000, and limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 1000) &&limit.between?(0,100))
      response = self.class.get('/parts/search', :query => {:q => query, :start => start, :limit => limit, :apikey => @api_key})
      validate_response(response)
    end
     
    # Public: Suggest a part search query string
    #
    # q - Query string. Minimum of 2 characters.
    # limit - Maximum number of results to return. Default is 5. Maximum is 10.
    #
    # Examples
    #
    #   suggest_parts('sn74f')
    #   # => parts hash
    #
    #   suggest_parts('sn74f', 10)
    #   # => parts hash
    #
    # Returns a part hash
    def suggest_parts(query, limit=5)
      raise(ArgumentError, 'query must be a string > 2 characters, and limit must be < 10') unless (query.is_a?(String) && query.length > 2 && limit.between?(0,10))
      response = self.class.get('/parts/suggest', :query => {:q => query.split(' ').join('+'), :limit => limit, :apikey => @api_key})
    end
     
    # Public: Match (manufacturer,mpn) to part uids
    #
    # manufacturer_name - Manufacturer name
    # mpn - Manufacturer part number
    #
    # Examples
    #
    #   match_part('Texas Instruments', 'SN74LS240N')
    #   # => parts hash
    #
    # Returns a part hash
    def match_part(manufacturer_name, mpn)
      response = self.class.get('/parts/match', :query => {:manufacturer_name => manufacturer_name, :mpn => mpn, :apikey => @api_key})
      validate_response(response)
    end
    
    # Public: Fetch a partattribute object by its id
    #
    # fieldname - The fieldname of a partattribute object
    #
    # Examples
    #
    #   part_attribute('capacitance')
    #   # => partattribute hash
    #
    # Returns a partattribute hash
    def part_attribute(fieldname)
      if fieldname.is_a? Array
          part_attributes(fieldname)
      else
        response = self.class.get('/partattributes/get', :query => {:fieldname => fieldname, :apikey => @api_key})
        validate_response(response)
      end
    end
    
    # Public: Fetch multiple partattribute objects by their ids
    #
    # fieldnames - The fieldnames of a partattribute objects
    #
    # Examples
    #
    #   part_attributes(['capacitance', 'resistance'])
    #   # => partattribute hash
    #
    # Returns a partattribute hash
    def part_attributes(fieldnames)
      raise(ArgumentError, 'fieldnames must be an array') unless fieldnames.is_a?Array
      response = self.class.get('/partattributes/get_multi', :query => {:fieldnames => "["+fieldnames.map{|v| "\"#{v}\""}.join(',')+"]", :apikey => @api_key})
      validate_response(response)
    end
     
    # Public: Match lines of a BOM to parts
    #
    # lines - hash made up of the following optional parameters:
    #          q - Free form query 
    #          mpn - MPN string 
    #          manufacturer - Manufacturer name 
    #          sku - Supplier SKU string 
    #          supplier - Supplier name 
    #          mpn_or_sku - Match on MPN or SKU 
    #          start=0 - Ordinal position of first item 
    #          limit=3 - Maximum number of items to return 
    #          reference - Arbitrary reference string to differentiate results
    #
    # Examples
    #
    #   bom_match({"mpn_or_sku"=> "60K6871", "manufacturer" => "Texas Instruments"})
    #   # => match hash
    #
    # Returns a match hash
    def bom_match(lines)
      raise(ArgumentError, 'lines must be a hash') unless lines.is_a?(::Hash)
      response = self.class.get('/bom/match', :query => {:lines => "[{"+lines.map{|k,v| "\"#{k}\":\"#{v}\""}.join(',')+"}]", :apikey => @api_key})
      validate_response(response)
    end
    
    # Public: Helper method for searches
    #
    # type - String name of the type
    # query - Query string 
    # start - Ordinal position of first result. First position is 0. Default is 0. Maximum is 1000.
    # limit - Number of results to return. Default is 10. Maximum is 100.
    #
    # Examples
    #
    #   search_parts('parts', 'capacitor')
    #   # => part hash
    #
    #   search_parts('categories', 'capacitor', 50)
    #   # => part hash
    #
    #   search_parts('parts', 'capacitor', 100, 25)
    #   # => part hash
    # 
    # Returns a part hash
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
