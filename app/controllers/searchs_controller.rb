class SearchsController < ApplicationController
  def index
  end
  
  def call
    data = []
    if current_user
      address = {
        lat: params[:lat], 
        lng: params[:lng]
      }
      data = SearchService.new(current_user.instagram_token).call(address, params[:distance])
    end
    
    render :json => data
  end
end