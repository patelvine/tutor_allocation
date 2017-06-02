require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "POST create" do
    context "with correct details" do
      it "redirects to root" do
        user = attributes_for(:user)
        expect do
          post :create, {:user => user}
        end.to change {User.count}.by(1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "with incorrect details" do
      it "renders new when password confirmation doesn't match" do
      user = build(:user)
        expect do
          post :create, {:user => {:username => user.username, :email => user.email,
            :password => user.password, :password_confirmation => "invalid"}}
        end.to_not change {User.count}
        expect(response).to render_template("new")
      end

      it "renders new with invaild email" do
      user = build(:user)
        expect do
          post :create, {:user => {:username => user.username, :email => "not-an-email",
            :password => user.password, :password_confirmation => user.password}}
        end.to_not change {User.count}
        expect(response).to render_template("new")
      end

      it "renders new with invaild username" do
      user = build(:user)
        expect do
          post :create, {:user => {:username => "cR@z?N@M3", :email => user.email,
            :password => user.password, :password_confirmation => user.password}}
        end.to_not change {User.count}
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET show" do
    context "TM logged in" do
      before(:each) do
        sign_in_as(create(:user_tm))
      end

      it "shows a CC" do
        cc = create(:user)
        get :show, id: cc
        expect(response).to be_success
      end

      it "does not show a student" do
        student = create(:user_student)
        get :show, id: student
        expect(response).to redirect_to root_path
      end

      it "does not show a tm" do
        tm = create(:user_tm)
        get :show, id: tm
        expect(response).to redirect_to root_path
      end
    end

    context "unauthorised" do
      let(:person) { create(:user) }

      it "redirects to login_path as student" do
        sign_in_as(create(:user_student))
        get :show, id: person
        expect(response).to redirect_to login_path
      end

      it "redirects to login_path as cc" do
        sign_in_as(create(:user))
        get :show, id: person
        expect(response).to redirect_to login_path
      end

      it "redirect_to login_path" do
        get :show, id: person
        expect(response).to redirect_to login_path
      end
    end
  end

end
