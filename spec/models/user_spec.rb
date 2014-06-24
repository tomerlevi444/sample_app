require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user) 
  end


  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
      

  describe "following" do

    let(:other_user) { FactoryGirl.create(:user) }

    before do
      @user.follow!(other_user)
    end


    it { should be_following(other_user)}

    it 'dani' do
      expect(@user.followed_users).to include(other_user)
	end
  end			
  
end