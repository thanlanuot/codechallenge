class SearchsController < ApplicationController
  def index
  end
  
  def call
    data = {
      data: []
    }
    is_search = false
    is_search = true if params[:lat].present? || params[:lng].present? || params[:distance].present?
    
    if current_user && is_search
      address = {
        lat: params[:lat], 
        lng: params[:lng]
      }
      data = SearchService.new(current_user.instagram_token).call(address, params[:distance])
    end
    
    result = {
      "draw": 1,
      "recordsTotal": data[:data].size,
      "recordsFiltered": data[:data].size,
      "data": data[:data]
    }
    result["error"] = data[:error] if data[:error]
    
    render :json => result
  end
end