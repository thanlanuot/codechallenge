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
    
    it "should see the list of result", :js => true do
      results = JSON.parse(File.read("#{Rails.root}/spec/fixtures/search_results.json"))
      response = {
        data: results["data"],
      }
      
      allow_any_instance_of(SearchService).to receive(:call).and_return(response)
      
      visit root_path
      fill_in :address, :with => "10.846597676667,106.64175327367"
      click_button("Search")
      
      sleep 5
      
      expect(page.find("#search_result")).to have_text("Pham Lien")
      expect(page.find(".paginate_button.current")).to have_text("1")
    end
    
    it "should allow choose coordinate from map", :js => true do
      visit root_path
      click_button("Pick from Map")
      
      fill_in :map_address, :with => "30 duong so 3, phuong 9, go vap"
      page.find('#map_address').send_keys(:enter)
      
      sleep 5
      
      click_button("Close")
      
      address = page.find("#address").value
      expect(address).to eq("10.845539,106.65084849999994")
    end
    
    it "should show image gallery after having result", :js => true do
      results = JSON.parse(File.read("#{Rails.root}/spec/fixtures/search_results.json"))
      response = {
        data: results["data"],
      }
      
      allow_any_instance_of(SearchService).to receive(:call).and_return(response)
      
      visit root_path
      fill_in :address, :with => "10.846597676667,106.64175327367"
      click_button("Search")
      
      sleep 5
      
      expect(page.find("#search_result")).to have_text("Pham Lien")
      
      click_button("Show gallery")
      
      sleep 5
      image = page.first(".slides img")[:src]
      expect(image).to have_text("scontent.cdninstagram.com")
    end
  end
end