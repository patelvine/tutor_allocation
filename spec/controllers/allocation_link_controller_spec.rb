require 'rails_helper'

describe AllocationLinkController do
  context "As TM" do
    before (:each) { sign_in_as(FactoryGirl.create(:user_tm)) }

    describe "POST create" do
      let!(:course_1) { create(:course) }
      let!(:course_2) { create(:course) }
      let!(:application_1) { create(:tutor_application) }


      before (:each) do
        request.env["HTTP_REFERER"] = "/"
      end

      # context "with no existing allocations" do
      #   context "with array of ids, and application id" do

      #     it "creates an allocation for each id" do
      #       expect do
      #         post :create, {"ids" => [course_1.id, course_2.id], application_id: application_1.id}
      #       end.to change { AllocationLink.count }.by(2)
      #     end
      #   end
      # end

      # context "with some existing allocations" do
      #   let (:allocation_1) { create(:allocation_link, course: course_1, tutor_application: application_1) }
      #   let (:allocation_2) { create(:allocation_link, course: course_2, tutor_application: application_1) }

      #   it "with array of existing ids doesn't add or delete any" do
      #     allocation_1
      #     allocation_2
      #     expect do
      #         post :create, {"ids" => [course_1.id, course_2.id], application_id: application_1.id}
      #     end.to_not change {AllocationLink.count}
      #   end

      #   it "with 1 existing allocation, with array of 1 existing, 1 non existing, adds one allocation" do
      #     allocation_1
      #     expect do
      #         post :create, {"ids" => [course_1.id, course_2.id], application_id: application_1.id}
      #     end.to change {AllocationLink.count}.by(1)
      #   end

      #   it "with 1 existing allocation, with array of 1 non-existing adds one allocation, deletes one" do
      #     allocation_1
      #     id = allocation_1.id
      #     expect do
      #         post :create, {"ids" => [course_2.id], application_id: application_1.id}
      #     end.to_not change {AllocationLink.count }
      #     expect(AllocationLink.where(id: id).first).to be_nil
      #   end

      #   it "with existing allocations, with empty array, deletes all for application" do
      #     allocation_1
      #     allocation_2
      #     expect do
      #         post :create, {"ids" => [], application_id: application_1.id}
      #     end.to change {AllocationLink.count}.by(-2)
      #   end

      # end
    end

    # describe "PUT update_state" do
      # let (:allocation) { create(:allocation_link) }
      # it "updates the state" do
      #   put :update_state, { id: allocation.id, allocation_link: { state: "reserve" } }
      #   allocation.reload
      #   expect(allocation.state).to eq "reserve"
      # end

      # it "fails with incorrect states" do

      #   expect { put :update_state, { id: allocation.id, allocation_link: { state: "thing" } } }.to raise_error(/thing/)
      # end
    # end
  end

  context "As CC" do
    before (:each) do
      request.env["HTTP_REFERER"] = "/"
    end

    let(:user_cc) {create(:user)}
    let(:course) {create(:course, course_coordinator_id: user_cc.id, state: :awaiting_cc)}
    let (:allocation) { create(:allocation_link, course: course, state: "shortlisted")}
    before (:each) { sign_in_as(user_cc) }
    context "updating own course" do
      context "With shortlisted allocations" do
        describe "CC accepting" do
          it "changes the state to accepted" do
            post :accept, { id: allocation.id }
            expect(allocation.reload.state).to eq "accepted"
          end
        end

        describe "CC rejecting" do
          it "changes the state to rejected" do
            post :reject, { id: allocation.id }
            expect(allocation.reload.state).to eq "rejected"
          end
        end
      end
    end

    context "With non-shortlisted allocations" do
      describe "CC accepting" do
        it "does not update the state" do
          allocation.update(state: "awaiting")
          post :accept, { id: allocation.id }
          expect(allocation.reload.state).to eq "awaiting"
        end
      end

      describe "CC rejecting" do
        it "does not update the state" do
          allocation.update(state: "awaiting")
          post :reject, { id: allocation.id }
          expect(allocation.reload.state).to eq "awaiting"
        end
      end
    end

    context "updating courses not coordinating" do
      let(:other_course) {create(:course, course_coordinator_id: user_cc.id + 1, state: :awaiting_cc)}

      describe "CC accepting" do
        it "redirects to login page" do
          allocation.update(course: other_course)
          post :accept, { id: allocation.id }
          expect(response).to redirect_to(login_path)
        end
      end

      describe "CC rejecting" do
        it "redirects to login page" do
          allocation.update(course: other_course)
          post :reject, { id: allocation.id }
          expect(response).to redirect_to(login_path)
        end
      end
    end

    context "trying to update non-awaiting_cc course" do
      before(:each) { request.env["HTTP_REFERER"] = "/" }
      let(:other_course) {create(:course, course_coordinator_id: user_cc.id + 1, state: :awaiting_tm)}

      describe "CC accepting" do
        it "redirects to login page" do
          allocation.update(course: other_course)
          post :accept, { id: allocation.id }
          expect(response).to redirect_to("/")
        end
      end

      describe "CC rejecting" do
        it "redirects to login page" do
          allocation.update(course: other_course)
          post :reject, { id: allocation.id }
          expect(response).to redirect_to("/")
        end
      end
    end
  end
end
