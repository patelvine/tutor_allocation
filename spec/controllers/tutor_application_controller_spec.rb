require 'rails_helper'

describe TutorApplicationsController do



  before(:each) do
    Admin::Configuration.deadline = Date.today
  end


  context "authorized as TM" do
    let (:app) { create(:tutor_application) }

    before (:each) { sign_in_as(create(:user_tm)) }

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to be_success
      end
    end

    describe "GET Show" do
      it "returns http success" do
        get :show, id: app.id
        expect(response).to be_success
      end
    end

    describe "GET edit" do
      it "gets the page if correct student" do
        get :edit, id: app
        expect(response).to be_success
      end
    end

    describe "PATCH update" do
      it "works with correct attributes" do
        patch :update, {:tutor_application => {:first_name => "Hi"}, :id => app.id}
        app.reload
        expect(app.first_name).to eq "Hi"
      end

      it "fails when trying to update incorrectly" do
        patch :update, {:tutor_application => {:preferred_hours => "Hi"}, :id => app.id}
        expect(response).to render_template "edit"
      end

      it "fails when after deadline" do
        expect(Admin::Configuration).to receive(:deadline).and_return(Date.parse('1970-01-01'))
        get :update, {:tutor_application => {:first_name => "Hi"}, :id => app.id}
        app.reload
        expect(app.first_name).to_not eq "Hi"
        expect(response).to render_template "deadline_passed"
      end
    end

    describe "PATCH update_pay" do
      before(:all) { FactoryGirl.create(:admin_hourly_rate, level: "200 level", years_experience: 0, rate: 15) }

      it "returns 423 after deadline" do
        expect(Admin::Configuration).to receive(:deadline).and_return(Date.parse('1970-01-01'))
        patch :update_pay, {:id => app.id, :tutor_application => {:pay_level => "0", :years_experience => "0"} }
        expect(response.status).to eql 423
      end

      it "changes the pay level and years experience" do
        expect(app.pay_level).to_not eql 0
        expect(app.years_experience).to_not eql 0
        patch :update_pay, {:id => app.id, :tutor_application => {:pay_level => "0", :years_experience => "0"} }
        app.reload
        expect(app.pay_level).to eql 0
        expect(app.years_experience).to eql 0
      end

      it "returns 400 for a bad update" do
        patch :update_pay, {:id => app.id, :tutor_application => {:pay_level => "THIS SHOULDNT WORK", :years_experience => "0"} }
        expect(response.status).to eql 400
      end
    end

    describe "PATCH update_comment" do
      context "with valid details" do
        comment = "A comment"
        before(:each) do
          patch :update_comment, {:tutor_application => {:comment => comment}, :id => app.id}
          app.reload
        end

        it "updates comment" do
          expect(app.comment).to eq comment
        end

        it "redirects to show" do
          expect(response).to redirect_to(tutor_application_path)
        end
      end
    end

    describe "GET application_print" do
      it "returns http success" do
        get :application_print, id: app
        expect(response).to be_success
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to be_success
      end
    end

    describe "GET new after deadline" do
      it "shows error" do
        expect(Admin::Configuration).to receive(:deadline).and_return(Date.parse('1970-01-01'))
        get :new
        expect(response).to render_template "deadline_passed"
      end
    end

    describe "GET create after deadline" do
      it "shows error" do
        expect(Admin::Configuration).to receive(:deadline).and_return(Date.parse('1970-01-01'))
        get :create
        expect(response).to render_template "deadline_passed"
      end
    end

    describe "POST create" do
      let (:valid_app) { build(:tutor_application).attributes.symbolize_keys }
      let (:invalid_app) { build(:tutor_application, first_name: nil).attributes.symbolize_keys }

      context "valid application details" do
        it "redirects to the tutor application index page" do
          post :create, {:tutor_application => valid_app}
          expect(response).to redirect_to(tutor_applications_path)
        end
      end

      context "invalid application details" do
        it "re-renders the application page" do
          post :create, {:tutor_application => invalid_app}
          expect(response).to render_template(:new)
        end
      end
    end
  end

  context "authorized as CC" do
    let (:app) { create(:tutor_application) }
    let(:user_cc) { FactoryGirl.create(:user, role: "CC") }
    let(:course) { FactoryGirl.create(:course, course_coordinator_id: user_cc.id) }
    before (:each) { sign_in_as(user_cc) }

    describe "GET show" do
      it "redirects to login page" do
        get :show, id: app.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "GET show" do
      let!(:allocation) { FactoryGirl.create(:allocation_link, tutor_application: app, course: course) }
      it "doesn't redirect to login page" do
        get :show, id: app.id
        expect(response).to_not redirect_to(login_path)
      end
    end

    describe "PATCH update_comment" do
      it "doesn't redirect to login page" do
        patch :update_comment, {:tutor_application => {:comment => "Hi"}, :id => app.id}
        expect(response).to_not redirect_to(login_path)
      end
    end
  end

  context "authorized as student" do
    let (:student_user) {create(:user_student)}
    before (:each) { sign_in_as(student_user) }
    let (:app) { create(:tutor_application, student_ID: student_user.student_ID) }


    describe "PATCH update" do
      it "works with correct attributes" do
        patch :update, {:tutor_application => {:first_name => "Hi"}, :id => app.id}
        app.reload
        expect(app.first_name).to eq "Hi"
      end
    end

    describe "GET application_print" do
      it "redirects to login page" do
        get :application_print, id: app
        expect(response).to redirect_to(login_path)
      end
    end

    describe "GET edit" do
      it "gets the page if correct student" do
        get :edit, id: app
        expect(response).to be_success
      end

      it "cannot get someone else's application" do
        app.update_column(:student_ID, "132542")
        get :edit, id: app
        expect(response).to_not be_success
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to be_success
      end
    end

    describe "POST create" do
      let (:valid_app) { build(:tutor_application).attributes.symbolize_keys }
      let (:invalid_app) { build(:tutor_application, first_name: nil).attributes.symbolize_keys }

      context "valid application details" do
        it "redirects to the tutor's application" do
          post :create, {:tutor_application => valid_app}
          expect(response).to redirect_to(edit_tutor_application_path(TutorApplication.last))

        end
      end

      context "invalid application details" do
        it "re-renders the application page" do
          post :create, {:tutor_application => invalid_app}
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
