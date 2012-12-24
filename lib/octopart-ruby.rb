require 'httparty'

module Octopart
  
  # api_key -  The API key to use
  def self.api_key
    raise APIKeyNotSetError if @api_key.nil?
    @api_key
  end
  
  # api_key -  The API key to use
  def self.api_key=(api_key)
    @api_key = api_key
  end
  
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'octopart', 'client')
require File.join(directory, 'octopart', 'exceptions')