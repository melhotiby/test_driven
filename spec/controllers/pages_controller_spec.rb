require 'spec_helper'

describe PagesController do
  subject { page }
  render_views

  describe "Home page" do
    before { visit root_path } 
    it { should have_selector('h1', :text => 'Home Page h1') }
    it { should have_selector('title', :text => full_title('Home')) }
  end

  describe "Contact page" do
    before { visit contact_path } 
    it { should have_selector('h1', :text => 'Contact Page h1') }
    it { should have_selector('title', :text => full_title('Contact')) }
  end

  describe "About page" do
    before { visit about_path } 
    it { should have_selector('h1', :text => 'About Page h1') }
    it { should have_selector('title', :text => full_title('About')) }
  end
  
  describe "help page" do
    before { visit help_path } 
    it { should have_selector('h1', :text => 'Help Page h1') }
    it { should have_selector('title', :text => full_title('Help')) }
  end
end