require 'helper'

class TestOctopartRuby < Test::Unit::TestCase
  
  context "Client Initialization" do
    
    should "require an api key" do
      Octopart.api_key = nil
      
      assert_raise APIKeyNotSet do
        Octopart::Client.new()
      end
    end
    
    should "set the api key" do
      client = Octopart::Client.new('123456789')
     
      assert_equal '123456789', client.api_key
    end
    
    should "match the module's api key" do
      key = 12345678
      Octopart.api_key = key
      
      assert_equal Octopart.api_key, Octopart::Client.new(key).api_key
    end
    
    should "require parameters" do
      client = Octopart::Client.new('123456789')
      
      assert_raise ArgumentError do
        client.category()
        client.categories()
        client.parts()
        client.part()
        client.search_parts()
        client.suggest_parts()
        client.match_part()
        client.part_attribute()
        client.part_attributes()
        client.bom_match()
      end
    end
    
  end
  
  context "Category API Methods" do
    
    setup do
      @client = Octopart::Client.new('123456789')
    end
    
    should "get one category" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/categories/get?id=4174&apikey=123456789", :body => fixture_file("category.json"))
      category = @client.category(4174)
      
      assert_not_nil category
      assert_equal 4174, category["id"]
      assert_equal "Single Components", category["nodename"]
    end
    
    should "get multiple categories with the category() method" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/categories/get_multi?ids=%5B4215%2C4174%2C4780%5D&apikey=123456789", :body => fixture_file("category_multi.json"))
      categories = @client.category([4215,4174,4780])
      
      assert_not_nil categories
      assert_equal 3, categories.count
      assert_equal "Single Components", categories.first["nodename"]
      assert_equal 232613, categories.last["num_parts"]
    end
    
    should "get multiple categories" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/categories/get_multi?ids=%5B4215%2C4174%2C4780%5D&apikey=123456789", :body => fixture_file("category_multi.json"))
      categories = @client.categories([4215,4174,4780])
      
      assert_not_nil categories
      assert_equal 3, categories.count
      assert_equal "Single Components", categories.first["nodename"]
      assert_equal 232613, categories.last["num_parts"]
    end
    
    should "search for categories" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/categories/search?q=resistor&start=0&limit=10&apikey=123456789", :body => fixture_file("category_search.json"))
      
      assert_raise ArgumentError do
        @client.search_categories('t')
        @client.search_categories('test', 150, -2)
      end
      
      search = @client.search_categories('resistor', 0, 10)
      
      assert_not_nil search
      assert_equal 10, search["results"].count
    end
    
  end
  
  context "Part API Methods" do
    
    setup do
      @client = Octopart::Client.new('123456789')
    end
    
    should "get one part" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/get?uid=39619421&apikey=123456789", :body => fixture_file("part.json"))
      part = @client.part(39619421)
      
      assert_not_nil part
      assert_equal 19.237164999999997, part["avg_price"][0]
      
    end
    
    should "get multiple parts with the part() method" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/get_multi?uids=%5B39619421%2C29035751%2C31119928%5D&apikey=123456789", :body => fixture_file("part_multi.json"))
      parts = @client.part([39619421,29035751,31119928])
      
      assert_not_nil parts
    end
    
    should "get multiple parts" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/get_multi?uids=%5B39619421%2C29035751%2C31119928%5D&apikey=123456789", :body => fixture_file("part_multi.json"))
      part_numbers = [39619421,29035751,31119928]
      parts = @client.parts(part_numbers)
      
      assert_not_nil parts
      assert_equal part_numbers.count, parts.count
    end
    
    should "search for parts" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/search?q=resistor&start=10&limit=20&apikey=123456789", :body => fixture_file("part_search.json"))
      
      assert_raise ArgumentError do
        @client.search_parts('t')
        @client.search_parts('test', 150, -2)
      end
      
      search = @client.search_parts('resistor', 10, 20)
      
      assert_not_nil search
      assert_equal 20, search["results"].count
    end
    
    should "suggest parts" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/suggest?q=sn74f&limit=5&apikey=123456789", :body => fixture_file("part_suggest.json"))
      
      assert_raise ArgumentError do
        @client.suggest_parts('t')
        @client.suggest_parts('test', 15)
      end
      
      suggestion = @client.suggest_parts('sn74f')
      
      assert_not_nil suggestion
      assert_equal 1908, suggestion["hits"]
      assert_equal 5, suggestion["request"]["limit"]
    end
    
    should "match part" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/match?manufacturer_name=texas%2Binstruments&mpn=SN74LS240N&apikey=123456789", :body => fixture_file("part_match.json"))
      match = @client.match_part('texas instruments', 'SN74LS240N')
      
      assert_not_nil match
    end  
  
  end
  
  context "Part Attribute API Methods" do
    
    setup do
      @client = Octopart::Client.new('123456789')
    end
    
    should "get a part attribute" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/partattributes/get?fieldname=capacitance&apikey=123456789", :body => fixture_file("attribute.json"))
      attribute = @client.part_attribute('capacitance')
      
      assert_not_nil attribute
      assert_equal "PartAttribute", attribute["__class__"]
      assert_equal 5, attribute.keys.count
    end
    
    should "get multiple part attributes with the part_attribute() method" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/partattributes/get_multi?fieldnames=%5Bcapacitance%2Cresistance%5D&apikey=123456789", :body => fixture_file("attribute_multi.json"))
      attributes = @client.part_attribute(["capacitance","resistance"])
      
      assert_not_nil attributes
      assert_equal 2, attributes.count
      assert_equal "number", attributes.last["type"]
    end
    
    should "get multiple part attributes" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/partattributes/get_multi?fieldnames=%5Bcapacitance%2Cresistance%5D&apikey=123456789", :body => fixture_file("attribute_multi.json"))
      attributes = @client.part_attributes(["capacitance","resistance"])
      
      assert_not_nil attributes
      assert_equal 2, attributes.count
      assert_equal "number", attributes.last["type"]
    end
  
  end
  
  context "BOM API Methods" do
    
    setup do
      @client = Octopart::Client.new('123456789')
    end
    
    should "match BOM to parts" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/bom/match?lines=%5B%7B%22mpn%22%3A%22SN74LS240N%22%2C%22manufacturer%22%3A%22Texas%20Instruments%22%7D%5D&apikey=123456789", :body => fixture_file("bom.json"))
      
      assert_raise ArgumentError do
        @client.bom_match('test')
      end
      
      bom = @client.bom_match({"mpn" => "SN74LS240N", "manufacturer" => "Texas Instruments"})
      
      assert_not_nil bom
    end
  
  end
  
  context "Helper Methods" do
    
    setup do
      @client = Octopart::Client.new('123456789')
    end
    
    should "match part with match()" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/match?manufacturer_name=texas%2Binstruments&mpn=SN74LS240N&apikey=123456789", :body => fixture_file("part_match.json"))
      match = @client.match('texas instruments', 'SN74LS240N')
      
      assert_not_nil match
    end
    
    should "search for parts with search()" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/parts/search?q=resistor&start=10&limit=20&apikey=123456789", :body => fixture_file("part_search.json"))
      
      assert_raise ArgumentError do
        @client.search('testing', 'resistor')
        @client.search('parts','t')
        @client.search('parts','test', 150, -2)
      end
      
      search = @client.search('parts', 'resistor', 10, 20)
      
      assert_not_nil search
      assert_equal 20, search["results"].count
    end
    
    should "search for categories with search()" do
      FakeWeb.register_uri(:get, "http://octopart.com/api/v2/categories/search?q=resistor&start=0&limit=10&apikey=123456789", :body => fixture_file("category_search.json"))
      
      assert_raise ArgumentError do
        @client.search('testing', 'resistor')
        @client.search('testing')
        @client.search('t')
        @client.search('categories', 'test', 150, -2)
      end
      
      search = @client.search('categories', 'resistor', 0, 10)
      
      assert_not_nil search
      assert_equal 10, search["results"].count
    end
    
  end
  
end
