require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Signup') }
    it { should have_selector('title', text: full_title('Signup')) }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Sign up" }.not_to change(User, :count)
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Matt Elhotiby"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      
      it "should create a user" do
        expect { click_button "Sign up" }.to change(User, :count)
      end
      
      describe "with valid information" do
        before { click_button "Sign up" }
        it { should have_selector('title', :text => "Matt Elhotiby") }
        it { should have_selector('.flash', :text => "Welcome to the Sample App!") }
        
      end
    end
    
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end