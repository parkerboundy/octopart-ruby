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
        self.class.get('/categories/get', :query => {:id => id, :apikey => @api_key}).parsed_response
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
      self.class.get('/categories/get_multi', :query => {:ids => "[#{ids.join(",")}]", :apikey => @api_key}).parsed_response
    end
    
    # Public: Execute search over category objects
    #
    # q - Query string
    # start - Ordinal position of first result. First position is 0. Default is 0
    # limit - Maximum number of results to return. Default is 10
    # ancestor_id - If specified, limit search to all descendants of the specified ancestor
    #
    # Examples
    #
    #   search_categories('resistor')
    #   # => search results
    #
    # Returns the duplicated String.
    def search_categories(query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters and start/limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 100) &&limit.between?(0,100))    
      self.class.get('/categories/search', :query => {:q => query, :start => start, :limit => limit, :apikey => @api_key}).parsed_response
    end
    
    # Public: Fetch a part object by its id
    #
    # uid  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def part(uid)
      if uid.is_a? Array
        parts(uid)
      else
        self.class.get('/parts/get', :query => {:uid => uid, :apikey => @api_key}).parsed_response
      end
    end
    
    # Public: Fetch multiple part objects by their ids
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def parts(uids)
      raise(ArgumentError, 'uids must be an array') unless uids.is_a?Array
      self.class.get('/parts/get_multi', :query => {:uids => "[#{uids.join(",")}]", :apikey => @api_key}).parsed_response
    end
     
    # Public: Execute search over part objects
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def search_parts(query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters and start/limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 100) &&limit.between?(0,100))
      self.class.get('/parts/search', :query => {:q => query, :start => start, :limit => limit, :apikey => @api_key}).parsed_response
    end
     
    # Public: Suggest a part search query string
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def suggest_parts(query, limit=5)
      raise(ArgumentError, 'query must be a string > 2 characters, and limit must be < 10') unless (query.is_a?(String) && query.length > 2 && limit.between?(0,10))
      self.class.get('/parts/suggest', :query => {:q => query.split(' ').join('+'), :limit => limit, :apikey => @api_key}).parsed_response
    end
     
    # Public: Match (manufacturer,mpn) to part uids
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def match_part(manufacturer_name, mpn)
      self.class.get('/parts/match', :query => {:manufacturer_name => manufacturer_name.split(' ').join('+'), :mpn => mpn, :apikey => @api_key}).parsed_response
    end
    
    # Public: Helper method for match_part(manufacturer_name, mpn)
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String. 
    def match(manufacturer_name, mpn)
      match_part(manufacturer_name, mpn)
    end
    
    # Public: Fetch a partattribute object by its id
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def part_attribute(fieldname)
      if fieldname.is_a? Array
          part_attributes(fieldname)
      else
        self.class.get('/partattributes/get', :query => {:fieldname => fieldname, :apikey => @api_key}).parsed_response
      end
    end
    
    # Public: Fetch multiple partattribute objects by their ids
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def part_attributes(fieldnames)
      raise(ArgumentError, 'fieldnames must be an array') unless fieldnames.is_a?Array
      self.class.get('/partattributes/get_multi', :query => {:fieldnames => "[#{fieldnames.join(",")}]", :apikey => @api_key}).parsed_response
    end
     
    # Public: Match lines of a BOM to parts
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def bom_match(lines)
      raise(ArgumentError, 'lines must be a hash') unless lines.is_a?(::Hash)
      self.class.get('/bom/match', :query => {:lines => "[{"+lines.map{|k,v| "\"#{k}\":\"#{v}\""}.join(',')+"}]", :apikey => @api_key}).parsed_response
    end
    
    # Public: Helper method for searches
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    # Returns the duplicated String.
    def search(type, query, start=0, limit=10)
      raise(ArgumentError, 'query must be a string > 2 characters and start/limit must be < 100') unless (query.is_a?(String) && query.length > 2 && start.between?(0, 100) &&limit.between?(0,100))
      if type == 'part' || type == 'parts'
        search_parts(query, start, limit)
      elsif type == 'category' || type == 'categories'
        search_categories(query, start, limit)
      else
        raise(ArgumentError, "type must be either 'parts' or 'categories'")
      end
    end
    
  end

end
