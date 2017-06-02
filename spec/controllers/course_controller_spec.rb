require 'rails_helper'

RSpec.describe CoursesController, :type => :controller do

  let(:user_CC) {FactoryGirl.create(:user, role: "CC")}

  context "Authorized as TM" do
    before(:each) { sign_in_as(FactoryGirl.create(:user_tm)) }
    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to be_success
      end
    end

    context 'with valid course' do
      let (:valid_course) { FactoryGirl.create(:course) }
      let!(:awaiting) { FactoryGirl.create(:allocation_link, course: valid_course) }
      let (:accepted) { FactoryGirl.create(:allocation_link, course: valid_course, state: "accepted") }

      describe "GET show" do
        it "returns http success" do
          get :show, {id: valid_course.id}
          expect(response).to be_success
        end
      end

      describe "PATCH calculate_required_tutors" do
        it "returns http success" do
          get :calculate_required_tutors, {id: valid_course.id}
          expect(response).to be_success
        end
      end


      describe "PATCH propose_course" do
        let (:reserved) { FactoryGirl.create(:allocation_link, course: valid_course, state: "reserve") }

        it "returns HTTP success" do
          patch :propose_course, {id: valid_course.id}
          expect(response).to redirect_to(course_path(valid_course.id))
        end

        it "changes awaiting state to shortlisted" do
          patch :propose_course, {id: valid_course.id}
          expect(awaiting.reload.state).to eql "shortlisted"
        end

        it "changes awaiting state to shortlisted" do
          reserved
          patch :propose_course, {id: valid_course.id}
          expect(reserved.reload.state).to eql "reserve"
        end

      end

      describe "PATCH finalise_accepted" do
        it "returns HTTP success" do
          accepted
          patch :finalise_accepted, {id: valid_course.id}
          expect(response).to redirect_to(course_path(valid_course))
        end

        it "changes accepted state to allocated" do
          accepted
          patch :finalise_accepted, {id: valid_course.id}
          expect(accepted.reload.state).to eql "allocated"
        end

        context "Where the course doesn't have any accepted tutors" do
          it "redirects to show and shows an error" do
            patch :finalise_accepted, {id: valid_course }
            expect(response).to redirect_to course_path(valid_course)
            expect(flash[:error]).to match(/accepted/)
          end
        end

      end

      describe "PATCH propose_course" do
        let (:rejected) { FactoryGirl.create(:allocation_link, course: valid_course, state: "rejected") }
        it "changes awaiting state to shortlisted" do
          rejected
          patch :finalise_accepted, {id: valid_course.id}
          expect(rejected.reload.state).to eql "rejected"
        end
      end
    end

    context 'with invalid course' do
      let (:valid_course) { FactoryGirl.create(:course) }

      describe "PUT update" do
        it "doesn't update course with invalid details" do
          put :update, {course: { name: "Something" }, id: valid_course }
          expect(valid_course.reload.name).to_not eql "Something"
        end
      end
    end
  end

  context "Authorized as CC" do

    before (:each) { sign_in_as(user_CC) }
    let (:valid_course) { FactoryGirl.create(:course, state: :awaiting_cc, course_coordinator_id: user_CC.id) }

    describe "GET index" do
      it "doesn't redirect to login page" do
        get :index
        expect(response).to_not redirect_to(login_path)
      end
    end

    describe "GET show" do
      it "doesn't redirect to login page" do
        course = FactoryGirl.create(:course, course_coordinator_id: user_CC.id)
        get :show, id: course.id
        expect(response).to_not redirect_to(login_path)
      end
    end

    describe "GET show" do
      it "redirects to login page if user is not course's cc" do
        course = FactoryGirl.create(:course, course_coordinator_id: user_CC.id + 1)
        get :show, id: course.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "PUT update" do
      it "redirects to login page" do
        put :update, id: valid_course.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "PUT update" do
      it "doesn't update" do
        valid_course.update(enrollment_number: 5)
        put :update, {course: { enrollment_number: 1337 }, id: valid_course }
        expect(valid_course.reload.enrollment_number).to_not eql 1337
      end
    end

    describe "PATCH propose_course" do
      context "cc assigned to course" do
        it "updates course as awaiting_tm" do
          expect(valid_course.state).to_not eql "awaiting_tm"
          patch :propose_course, {id: valid_course.id}
          expect(valid_course.reload.state).to eql "awaiting_tm"
        end
      end

      context "cc NOT assigned to course" do
        it "redirects back to courses page" do
          valid_course.course_coordinator_id = 9001
          valid_course.save
          patch :propose_course, {id: valid_course.id}
          expect(response).to redirect_to(courses_path)
          expect(valid_course.reload.state).to eql "awaiting_cc"
        end
      end
    end

  end

  context "Unauthorized" do
    let(:course) { FactoryGirl.create(:course) }

    describe "GET index" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end

    describe "GET show" do
      it "redirect to login page" do
        get :show, id: course.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "PATCH calculate_required_tutors" do
      it "redirects to login page" do
        get :calculate_required_tutors, {id: course.id}
        expect(response).to redirect_to(login_path)
      end
    end

    describe "PATCH propose_course" do
      it "redirects to login page" do
        get :propose_course, {id: course.id}
        expect(response).to redirect_to(login_path)
      end
    end

    describe "PATCH finalise_accepted" do
      it "redirects to login page" do
        get :finalise_accepted, {id: course.id}
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
