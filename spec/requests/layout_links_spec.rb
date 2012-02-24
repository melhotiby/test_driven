require 'spec_helper'

describe "LayoutLinks" do  
  subject { page }
  it "should have a Home page at '/'" do
    visit '/'
    should have_selector('title', :text => "#{full_title('Home')}")
  end

  it "should have a Contact page at '/contact'" do
    visit '/contact'
    should have_selector('title', :text => "#{full_title('Contact')}")
  end

  it "should have an About page at '/about'" do
    visit '/about'
    should have_selector('title', :text => "#{full_title('About')}")
  end
  
  it "should have an About page at '/help'" do
    visit '/help'
    should have_selector('title', :text => "#{full_title('Help')}")
  end
  
  it "should navigate me to the proper links" do
    visit '/'
    click_link 'Home'
    should have_selector('title', :text => "#{full_title('Home')}")
    click_link 'Contact'
    should have_selector('title', :text => "#{full_title('Contact')}")
    click_link 'About'
    should have_selector('title', :text => "#{full_title('About')}")
    click_link 'Help'
    should have_selector('title', :text => "#{full_title('Help')}")
  end
end