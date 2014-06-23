require 'spec_helper'

include ApplicationHelper
include SessionsHelper

describe "User pages" do

  subject { page }

  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/'
      expect(page).to have_content('Sample App')
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/help'
      expect(page).to have_content('Help')
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
  describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        #rack_test_session_wrapper = Capybara.current_session.driver
        #rack_test_session_wrapper.submit :delete, '/signout', nil
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user, use_capybara: true
        visit '/'
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

       describe "micropost destruction" do

        describe "as correct user" do
          before { 
            visit '/'}

          it "should delete a micropost" do
          expect { click_link "delete", :match => :first}.to change(Micropost, :count).by(-1)
          end
        end
      end
  end

end
