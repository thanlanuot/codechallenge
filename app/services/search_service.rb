class SearchService
  include HTTParty
  base_uri 'api.instagram.com/v1'
  
  def initialize(access_token)
    @options = {access_token: access_token}
  end
  
  def call(address = {}, distance = 1000)
    @options.merge!({lat: address[:lat], lng: address[:lng]})
    begin
      response = self.class.get("/media/search", query: @options, :debug_output => $stdout)
      parse(response)
    rescue Exception => e
      {
        data: [],
        error: e.message 
      }
    end
  end
  
  private
    def parse(response)
      response = response.parsed_response
      if response["meta"]["code"] != 200
        return {
          data: [],
          error: response["meta"]["error_message"]
        }
      end
      
      return {
        data: response["data"]
      }
    end
end