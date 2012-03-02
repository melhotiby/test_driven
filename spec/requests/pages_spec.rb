require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in(user)
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("tr##{item.id}", text: item.content)
        end
      end
      
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        
        before do 
          user.follow!(other_user) 
          visit root_path
        end
        
        it { should have_link('1 following', href: following_user_path(user)) }
        it { should have_link('0 follower', href: followers_user_path(user)) }
      end
    end
  end
end
