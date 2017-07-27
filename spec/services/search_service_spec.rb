require "rails_helper"

describe "Search Service" do
  before :each do
    @service = SearchService.new('token')
    
    HTTPResponse = Struct.new(:response) do
      def parsed_response
        response
      end
    end
  end
  
  it "should return array of items if success" do
    results = JSON.parse(File.read("#{Rails.root}/spec/fixtures/search_results.json"))
    allow(SearchService).to receive(:get).and_return(HTTPResponse.new(results))
    
    response = {
      data: results["data"],
    }
    expect(@service.call).to eq(response)
  end
  
  it "should return error if there is error when calling Instagram search" do
    results = JSON.parse(File.read("#{Rails.root}/spec/fixtures/errors.json"))
    allow(SearchService).to receive(:get).and_return(HTTPResponse.new(results))
    
    response = {
      data: [],
      error: results["meta"]["error_message"]
    }
    expect(@service.call).to eq(response)
  end
end