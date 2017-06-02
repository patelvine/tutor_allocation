require 'rails_helper'

describe Admin::ConfigurationController, :type => :controller do
  before(:each) do
    sign_in_as(FactoryGirl.create(:user_tm))
    request.env["HTTP_REFERER"] = ""
  end

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #calculate_num_tutors" do
    it "recalculates number of tutors required for all courses" do
      expect(Course).to receive(:recalculate_all_tutors!)
      get :calculate_num_tutors
    end

    it "redirects to the previous page" do
      get :calculate_num_tutors
      expect(response).to redirect_to("")
    end
  end

  describe "POST deadline" do
    context "without date" do
      it "redirects with an error" do
        post :deadline, {}
        expect(response.status).to eql 302
        expect(flash[:error]).to match(/deadline/)
      end
    end

    context "with date" do
      it "updates the deadline value" do
        post :deadline, {date: "12/12/2012"}
        expect(Admin::Configuration.deadline).to eql Date.parse("12/12/2012")
      end
    end
  end

  describe "POST year and term" do
    context "with correct year and term" do
      it "updates the year and term" do
        post :year_and_term, {year: "1995", term: "3"}
        expect(flash[:notice]).to match(/year.*term/)
        expect(Admin::Configuration.year).to eql 1995
        expect(Admin::Configuration.term).to eql 3
      end
    end

    context "with correct year and incorrect term" do
      it "updates the year and not the term" do
        post :year_and_term, {year: "1996", term: "5"}
        expect(flash[:notice]).to match(/year.*(?!term)/)
        expect(flash[:error]).to match(/term/)
        expect(Admin::Configuration.year).to eql 1996
        expect(Admin::Configuration.term).to_not eql 5
      end
    end

    context "with correct term and incorrect year" do
      it "updates the term and not the year" do
        post :year_and_term, {year: "something", term: "3"}
        expect(flash[:notice]).to match(/(?!year).*term/)
        expect(flash[:error]).to match(/year/)
        expect(Admin::Configuration.term).to eql 3
      end
    end

    context "with incorrect term and incorrect year" do
      it "updates neither" do
        post :year_and_term, {year: "something", term: "5"}
        expect(flash[:notice]).to be_nil
        expect(flash[:error]).to match(/year.*term/)
        expect(Admin::Configuration.year).to_not eql "something"
        expect(Admin::Configuration.term).to_not eql 5
      end
    end
  end

  describe "#tutor_hours" do
    it "redirects with success for valid hours" do
      post :tutor_hours, { :hours => 5 }
      expect(Admin::Configuration.tutor_hours).to eql 5
      expect(response).to redirect_to("")
      expect(flash[:notice]).to match(/updated/i)
    end

    it "redirects with error for invalid hours" do
      expect(Admin::Configuration).to receive(:set_tutor_hours).and_return(false)
      post :tutor_hours, { :hours => 5 }
      expect(response).to redirect_to("")
      expect(flash[:error]).to match(/hours/)
    end
  end

  describe "#course_hours" do
    context "with not all parameters" do
      it "redirects back with an error" do
        post :course_hours, {"100level" => "5"}
        expect(response).to redirect_to("")
        expect(flash[:error]).to match(/error/)
      end
    end

    context "with all parameters" do
      it "redirects back with success for valid inputs" do
        post :course_hours, {"100level" => "1", "200level" => "1",
                             "300level" => "1", "400level" => "1"}
        expect(response).to redirect_to("")
        expect(flash[:notice]).to match(/updated/i)
      end

      it "redirects back with error for invalid inputs" do
        post :course_hours, {"100level" => "asd", "200level" => "1",
                             "300level" => "1", "400level" => "1"}
        expect(response).to redirect_to("")
        expect(flash[:error]).to match(/error/i)
      end
    end
  end


end

