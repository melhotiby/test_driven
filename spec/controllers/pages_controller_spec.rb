require 'spec_helper'

describe PagesController do
  render_views

  describe "Home page" do

    it "should have the h1 'Home Page h1'" do
      visit root_path
      page.should have_selector('h1', :text => 'Home Page h1')
    end

    it "should have the title 'Home Page'" do
      visit root_path
      page.should have_selector('title', :text => "Matts cool website | Home Page")
    end
  end

  describe "Contact page" do

    it "should have the h1 'Contact Page h1'" do
      visit contact_path
      page.should have_selector('h1', :text => 'Contact Page h1')
    end

    it "should have the title 'Contact Page'" do
      visit contact_path
      page.should have_selector('title', :text => 'Matts cool website | Contact Page')
    end
  end

  describe "About page" do

    it "should have the h1 'About Page h1'" do
      visit about_path
      page.should have_selector('h1', :text => 'About Page h1')
    end

    it "should have the title 'About Page'" do
      visit about_path
      page.should have_selector('title', :text => 'Matts cool website | About Page')
    end
  end
end