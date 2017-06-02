require 'rails_helper'

describe "root page", type: :request do

  let(:user_tm) {FactoryGirl.create(:user_tm)}

  it "GET root for no user redirects correctly" do
    get root_path
    expect(response).to redirect_to login_path
  end

  it "GET root for TM redirects correctly" do
    sign_in_stub FactoryGirl.create(:user_tm)
    get root_path
    expect(response).to redirect_to tutor_applications_path
  end

  it "GET root for CC redirects correctly" do
    sign_in_stub FactoryGirl.create(:user)
    get root_path
    expect(response).to redirect_to courses_path
  end


  it "GET root for student redirects correctly" do
    sign_in_stub FactoryGirl.create(:user_student)
    get root_path
    expect(response).to redirect_to new_tutor_application_path
  end
end
