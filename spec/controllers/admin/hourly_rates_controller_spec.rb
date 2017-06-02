require 'rails_helper'

RSpec.describe Admin::HourlyRatesController, :type => :controller do

  context "Authorised as TM" do
    before(:each) do
      sign_in_as(FactoryGirl.create(:user_tm))
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to be_success
      end
    end

    describe "POST update" do
      let(:hr1) { FactoryGirl.create(:admin_hourly_rate) }
      let(:hr2) { FactoryGirl.create(:admin_hourly_rate) }
      let(:rate1) { Faker::Number.number(4) }
      let(:rate2) { Faker::Number.number(4) }
      let(:hr_params) do
        {
          "admin_hourly_rates" => {
            hr1.id => {"rate" => rate1},
            hr2.id => {"rate" => rate2}
          }
        }
      end
      it "redirects to the hourly rate index page" do
        post :update, hr_params
        expect(response).to redirect_to(admin_hourly_rates_path)
      end

      it "updates the things" do
        post :update, hr_params
        expect(hr1.reload.rate).to eql rate1.to_f
        expect(hr2.reload.rate).to eql rate2.to_f
      end
    end
  end

  context "Unauthorised" do
    describe "GET index" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    describe "POST update" do
      let(:hr1) { FactoryGirl.create(:admin_hourly_rate) }
      let(:hr2) { FactoryGirl.create(:admin_hourly_rate) }
      let(:rate1) { Faker::Number.number(4) }
      let(:rate2) { Faker::Number.number(4) }
      let(:hr_params) do
        {
          "admin_hourly_rates" => {
            hr1.id => {"rate" => rate1},
            hr2.id => {"rate" => rate2}
          }
        }
      end
      it "redirects to the hourly rate index page" do
        post :update, hr_params
        expect(response).to redirect_to(login_path)
      end

      it "updates the things" do
        post :update, hr_params
        expect(hr1.reload.rate).to_not eql rate1.to_f
        expect(hr2.reload.rate).to_not eql rate2.to_f
      end
    end
  end
end
