require 'spec_helper'

describe "User pages" do
  subject { page }
  
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in(user)
        visit following_user_path(user)
      end

      it { should have_selector('a', href: user_path(other_user),
                                     text: other_user.name) }
    end

    describe "followers" do
      before do
        sign_in(other_user)
        visit followers_user_path(other_user)
      end

      it { should have_selector('a', href: user_path(user),
                                     text: user.name) }
    end
  end
  
  describe "Index page" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All Users') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_link('Next') }
      it { should have_link('2') }
      it { should_not have_link('delete') }
      
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
      
      describe "as a regular user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }
        before { sign_in non_admin }
        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(root_path) }
        end
      end
      
      it "should list each user" do
        User.all[0..2].each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
        
    # describe "signing out" do
    #   before { sign_out user }      
    #   it { should have_selector('title', text: 'Sign in') }
    # end
    
    describe "index" do
      before do
        sign_in FactoryGirl.create(:user)
        FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
        FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
        visit users_path
      end

      it { should have_selector('title', text: 'All Users') }

      it "should list each user" do
        User.all.each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end   
    
  end
  
  
  describe "edit" do
     let(:user) { FactoryGirl.create(:user) }
     before do 
       sign_in user
       visit edit_user_path(user) 
     end
     describe "page" do
       it { should have_selector('h1',    text: "Edit user") }
       it { should have_selector('title', text: "Edit user") }
       it { should have_link('change', href: 'http://gravatar.com/emails') }
     end

     describe "with invalid information" do
       let(:error) { '1 error prohibited this user from being saved' }
       before { click_button "Update" }

       it { should have_content(error) }
    end
   end

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
      
      describe "after saving the user" do
        before { click_button "Sign up" }
        it { should_not have_link('Sign in') }
        it { should have_link('Sign out') }
      end
      
      describe "with valid information" do
        before { click_button "Sign up" }
        it { should have_selector('title', :text => "Matt Elhotiby") }
        it { should have_selector('.flash', :text => "Welcome to the Sample App!") }
      end
      
      describe "with valid information" do
        let(:user)      { FactoryGirl.create(:user) }
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          sign_in user
          visit edit_user_path(user)
          fill_in "Name",         with: new_name
          fill_in "Email",        with: new_email
          fill_in "Password",     with: user.password
          fill_in "Confirmation", with: user.password
          click_button "Update"
        end

        it { should have_selector('title', text: new_name) }
        it { should have_selector('div.flash.success') }
        it { should have_link('Sign out', :href => signout_path) }
        specify { user.reload.name.should  == new_name }
        specify { user.reload.email.should == new_email }
      end
      
    end
    
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in(user) }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end
    
    
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foooooo" ) }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "BArrrrr" ) }
    
    before { visit user_path(user) }
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
    it { should have_content(m1.content) }
    it { should have_content(m2.content) }
    it { should have_content(user.microposts.count) }

  end
end
