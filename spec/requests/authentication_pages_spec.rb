require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "authorization" do


    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should have_selector('title', text: 'Home') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "in the Relationships controller" do
      describe "submitting to the create action" do
        before { post relationships_path }
        specify { response.should redirect_to(signin_path) }
      end

      describe "submitting to the destroy action" do
        before { delete relationship_path(1) }
        specify { response.should redirect_to(signin_path) }          
      end
    end


    describe "for non-signed-in users" do
      let(:user) { Factory(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end

      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before do
            micropost = FactoryGirl.create(:micropost)
            delete micropost_path(micropost)
          end
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the Users controller" do

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
  end


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

    describe "Not logged in" do
      before { non_valid_signin }
      it { should_not have_selector('li',    text: 'Settings') }
      it { should_not have_selector('li',    text: 'Profile') }
    end

    describe "with valid login" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Users',    href: users_path) }
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
end