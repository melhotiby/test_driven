require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
    describe "with invalid login" do
      before { non_valid_signin }
      it {should have_error_message('Invalid') }
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.flash.error') }
      end      
    end
    
    describe "with valid login" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }
      it { should_not have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      describe "followed by signout" do
        before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
    end
  end
end