require 'rails_helper'
describe TutorApplication do

  let (:course) { create(:course) }
  let (:application) { create(:tutor_application) }

  context "validation will" do
    it "have none to begin with" do
      expect(TutorApplication.count).to eq 0
    end

    it "succeed with valid attributes" do
      expect{ application }.to change {TutorApplication.count}.by(1)
    end

    it "fail without first name" do
      expect { create(:tutor_application, first_name: nil) }.to raise_error /First name.*blank/
    end

    it "fail without last name" do
      expect { create(:tutor_application, last_name: nil) }.to raise_error /Last name.*blank/
    end

    it "fail without Student ID" do
      expect { create(:tutor_application, student_ID: nil) }.to raise_error /Student id.*blank/
    end

    it "fail without ecs email" do
      expect { create(:tutor_application, ecs_email: nil) }.to raise_error /Ecs email.*blank/
    end

    it "fail without private email" do
      expect { create(:tutor_application, private_email: nil) }.to raise_error /Private email.*blank/
    end

    it "fail without mobile number" do
      expect { create(:tutor_application, mobile_number: nil) }.to raise_error /Mobile number.*blank/
    end

    it "fail without first choice" do
      expect { create(:tutor_application, first_choice: nil) }.to raise_error /First choice.*blank/
    end

    it "fail without second choice" do
      expect { create(:tutor_application, second_choice: nil) }.to raise_error /Second choice.*blank/
    end

    it "fail without preferred hours" do
      expect { create(:tutor_application, preferred_hours: nil) }.to raise_error /Preferred hours.*blank/
    end

    it "fail with invalid enrolment level" do
      expect { create(:tutor_application, enrolment_level: "ENGL302") }.to raise_error /Not a valid enrolment level/
    end

    it "fail with invalid qualification" do
      expect { create(:tutor_application, qualifications: "ENGL302") }.to raise_error /Not a valid qualification/
    end

    it "fail with invalid first choice" do
      expect { create(:tutor_application, first_choice: nil) }.to raise_error /First/
    end

    it "fail with invalid second choice" do
      expect { create(:tutor_application, second_choice: nil) }.to raise_error /Second/
    end

    it "fail with first and second choices the same" do
      expect { create(:tutor_application, first_choice: course, second_choice: course) }.to raise_error /Second choice cannot be the same as the first choice/
    end

    context "exporting an application" do
      it "pulls all the required data" do
        data = application
        xls_result = data.to_xls
        expect(xls_result["first_name"]).to eql application.first_name
        expect(xls_result["last_name"]).to eql application.last_name
        expect(xls_result["student_ID"]).to eql application.student_ID
        expect(xls_result["first_choice"]).to eql application.first_choice_name
        expect(xls_result["second_choice"]).to eql application.second_choice_name
      end

    end

  end

  describe "year and term after create" do
    let(:tutorapplication) {FactoryGirl.build(:tutor_application) }
    it "updates the year and term" do
      expect(tutorapplication.year).to be_nil
      expect(tutorapplication.term).to be_nil
      tutorapplication.save!
      tutorapplication.reload
      expect(tutorapplication.year).to_not be_nil
      expect(tutorapplication.term).to_not be_nil
    end
  end

  describe "suitability_string" do
    let(:ta) { create(:tutor_application, previous_tutor_experience: "dsads", teaching_qualification: true) }

    it "returns the correct string" do
      expect(ta.suitability_string).to include("previous tutor experience", "gender", "teaching qualification", "average grade")
    end

    it "contains previous non tutor vuw contract" do
      ta.update_column(:previous_tutor_experience, nil)
      ta.update_column(:previous_non_tutor_vuw_contract, "sd")
      expect(ta.suitability_string).to include("previous non tutor vuw contract")
      expect(ta.suitability_string).to_not include("previous tutor experience")
    end

    it "doesn't contain previous_tutor_experience or previous_non_tutor_vuw_contract" do
      ta.update_column(:previous_tutor_experience, nil)
      ta.update_column(:previous_non_tutor_vuw_contract, nil)
      expect(ta.suitability_string).to_not  include("previous non tutor vuw contract", "previous tutor experience")
    end

    it "doesn't contain gender" do
      ta.update_column(:gender, "Male")
      expect(ta.suitability_string).to_not include("gender")
    end

    it "teaching_qualification" do
      ta.update_column(:teaching_qualification, false)
      expect(ta.suitability_string).to_not include("teaching qualification")
    end

  end

  describe "#pay_rate" do
    context "with scholarship" do
      let(:ta) { create(:tutor_application, vuw_doctoral_scholarship: true)}
      it "will give pay rate of 0" do
        expect(ta.pay_rate).to eql 0
      end
    end
  end

  describe "current applications" do
    before(:each) do
      Admin::Configuration.set_term 1
      Admin::Configuration.set_year 2015
    end

    it "adds year and term to the application" do
      expect(application.term).to eq 1
      expect(application.year).to eq 2015
    end

    it "returns only current applications when using the scope" do
      application
      non_current = create(:tutor_application)
      non_current.update_column(:year, 2004)
      non_current2 = create(:tutor_application)
      non_current2.update_column(:term, 2)

      expect(TutorApplication.current_applications).to include application
      expect(TutorApplication.current_applications).to_not include non_current
      expect(TutorApplication.current_applications).to_not include non_current2
    end
  end  
end
