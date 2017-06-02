require 'rails_helper'

RSpec.describe User, :type => :model do

  context "with valid attributes" do
		it "should create a user with valid info" do
			user = build(:user)
			expect(user).to be_valid
		end
 	end

  context "with invalid username and email" do
	  it "should not be valid without username" do
	  	user = build(:user, username: nil)
			expect(user).to_not be_valid
	  end

	  it "should not be valid without email" do
	  	user = build(:user, email: nil)
			expect(user).to_not be_valid
	  end

	  it "should not create a duplicate username user" do
	  	user = build(:user, email: "another@email.com")
	  	user.save

	  	user_two = build(:user, email: "another@email.com")
	  	expect(user_two).to_not be_valid
		end

		it "should not create a duplicate email user" do
	  	user = build(:user, username: "anothername")
	  	user.save

	  	user_two = build(:user, username: "anothername")
	  	expect(user_two).to_not be_valid
		end

	  it "should not have length < 3" do
	  	user = build(:user, username: "ps")
	  	expect(user).to_not be_valid
	  end
 	end

 	context "with incorrect password" do
	  it "should not save without password" do
	  	user = build(:user, password: nil)
	  	expect(user).to_not be_valid
	  end

	  it "should not have length < 8" do
	  	user = build(:user, password: "shorter")
	  	expect(user).to_not be_valid
	  end
	end

	it "a cc should not have a student_ID" do
		user = build(:user, student_ID: "123456")
		expect(user).to_not be_valid
	end

	context "student user" do
		it "creates a student user correctly" do
			user = build(:user_student)
			expect(user).to be_valid
		end

		it "should have a student id" do
			user = build(:user_student, student_ID: nil)
			expect(user).to_not be_valid
		end

		it "should have a unique student_ID" do
			create(:user_student, student_ID: "1234")
			user = build(:user_student, student_ID: "1234")
			expect(user).to_not be_valid
		end
	end

end
