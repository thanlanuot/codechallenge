require 'rails_helper'

describe SearchsController do
  describe "GET #index" do
    it "should render html template" do
      get :index
      expect(response).to render_template("index")
    end
    
    context "with render_views" do
      render_views
      
      it "should require login first" do
        get :index
        expect(response.body).to have_text("Login with Instagram")
      end
    
      it "should provide search tool after logged in" do
        @user = FactoryGirl.create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        get :index
        expect(response.body).to have_text("Search in Instagram")
      end
    end
  end
end