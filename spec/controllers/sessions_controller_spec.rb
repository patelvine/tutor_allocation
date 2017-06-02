require 'rails_helper'


RSpec.describe SessionsController, :type => :controller do

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "POST create" do
    context "with correct details" do
      it "redirects to root with correct details using email" do
        user = create(:user)
        post :create, {:session => {:identifier => user.email, :password => user.password } }
        expect(flash.notice).to eql "Logged in!"
        expect(response).to redirect_to(root_path)
      end

      it "redirects to root with correct details using username" do
        user = create(:user)
        post :create, {:session => {:identifier => user.username, :password => user.password } }
        expect(flash.notice).to eql "Logged in!"
        expect(response).to redirect_to(root_path)
      end
    end

    context "with incorrect details" do

      it "renders new with incorrect details" do
        post :create, {:session => {:identifer => "invalid", :password => "invalid"} }
        expect(response).to render_template("new")
      end

      it "renders new with incorrect password correct email" do
        user = create(:user)
        post :create, {:session => {:identifer => user.email, :password => "invalid"} }
        expect(response).to render_template("new")
      end

      it "renders new with incorrect password correct username" do
        user = create(:user)
        post :create, {:session => {:identifer => user.username, :password => "invalid"} }
        expect(response).to render_template("new")
      end
    end
  end

end
