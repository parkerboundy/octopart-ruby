module Octopart
  
  # APIKeyNotSetError is called when a client is instantiated without an api_key
  class APIKeyNotSetError < StandardError; end
    
  # APIResponseError is called when an API request returns with a code other than 200
  class APIResponseError < StandardError; end
    
end