class SearchService
  include HTTParty
  base_uri 'api.instagram.com/v1'
  
  def initialize(access_token)
    @options = {access_token: access_token}
  end
  
  def call(address = {}, distance = 1)
    @options.merge!({lat: address[:lat], lng: address[:lng]})
    response = self.class.get("/media/search", query: @options, :debug_output => $stdout)
  end
  
  private
    def parse(response)
      response = response.parsed_response
      return [] if response.search.parsed_response["meta"]["code"] != 200
      return response.data
    end
end