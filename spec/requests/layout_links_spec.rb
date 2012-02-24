require 'spec_helper'

describe "LayoutLinks" do  
  
  it "should have a Home page at '/'" do
    visit '/'
    page.should have_selector('title', :text => "Matts cool website | Home Page")
  end

  it "should have a Contact page at '/contact'" do
    visit '/contact'
    page.should have_selector('title', :text => "Matts cool website | Contact Page")
  end

  it "should have an About page at '/about'" do
    visit '/about'
    page.should have_selector('title', :text => "Matts cool website | About Page")
  end
  
  it "should have an About page at '/help'" do
    visit '/help'
    page.should have_selector('title', :text => "Matts cool website | Help Page")
  end
end