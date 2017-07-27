require "rails_helper"

describe "Search Post", :type => :feature do
  context "no login" do
    it "should require login first", :js => true do
      visit root_path
      expect(page).to have_text("Login with Instagram")
    end
  end
  
  context "logged in" do
    before :each do
      @user = FactoryGirl.create(:user)
      page.set_rack_session(user_id: @user.id)
    end
    
    it "should provide search tool", :js => true do
      visit root_path
      expect(page).to have_text("Search in Instagram")
    end
    
    it "should see the list of result after entering proper coordinate", :js => true do
    end
    
    it "should allow choose coordinate from map", :js => true do
    end
    
    it "should show image gallery after having result", :js => true do
    end
  end
end