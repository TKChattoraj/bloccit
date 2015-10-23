require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {User.create!(name: "Bloccit User", email: "user5@bloccit.com", password: "password5")}
  describe "validations" do

    #Shoulda tests for name
      it {should validate_presence_of(:name)}
      it {should validate_length_of(:name).is_at_least(1)}

    #Shoulda tests for email
      it {should validate_presence_of(:email)}
      #make a new User for validate_uniqueness_of
      subject {User.new(name: "New User")}
      it {should validate_uniqueness_of(:email)}
      it {should validate_length_of(:email).is_at_least(3)}
      it {should allow_value("user@bloccit.com").for(:email)}
      it {should_not allow_value("userbloccit.com").for(:email)}

    #Shoulda tests for password
      it {should validate_presence_of(:password)}
      it {should have_secure_password}
      it {should validate_length_of(:password).is_at_least(6)}
  end
  describe "attributes" do
    it "should respond to name" do
      expect(user).to respond_to(:name)
    end
    it "should respond to email" do
      expect(user).to respond_to(:email)
    end
    it "should respond to password" do
      expect(user).to respond_to(:password)
    end
  end

  describe "invalid user" do
    let(:user_with_invalid_name) {User.new(name: "", email: "user@bloccit.com")}
    let(:user_with_invalid_email) {User.new(name: "Bloccit User", email: "")}
    let(:user_with_invalid_email_format) {User.new(name: "Bloccit User", email: "invalid_format")}


    it "should be an invalid user due to blank name" do
      expect(user_with_invalid_name).to_not be_valid
    end

    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_email).to_not be_valid
    end

    it "should be an invalid due to incorrectly formatted email address" do
      expect(user_with_invalid_email_format).to_not be_valid
    end
  end

   describe "user name callback" do
    let(:uncap_first_name) {User.new(name: "tarun Chattoraj", email: "user1@bloccit.com", password: "password")}
    let(:uncap_last_name) {User.new(name: "Tarun chattoraj", email: "user2@bblocit.com", password: "password")}
    let(:uncap_first_last_name) {User.new(name: "tarun chattoraj", email: "user3@block.com", password: "password")}
    let(:name_with_extra_spacing) {User.new(name: "Tarun         Chattoraj", email: "user4@block.com", password: "password")}
    let(:caps_email) {User.new(name: "Tarun Chattoraj", email: "UsEr6@Bloc.com", password: "password6")}
    correct_name = "Tarun Chattoraj"

    it "should make email address in only lowercase" do
      caps_email.save
      expect(caps_email.email).to eq "user6@bloc.com"
    end

    it "should capitalize the first name" do
      uncap_first_name.save
      expect(uncap_first_name.name).to eq correct_name
    end

    it "should capitalize the last name" do
      uncap_last_name.save
      expect(uncap_last_name.name).to eq correct_name
    end

    it "should capitalize both the first and lat name" do
      uncap_first_last_name.save
      expect(uncap_first_last_name.name).to eq correct_name
    end

    it "should eliminate extra space in name" do
      name_with_extra_spacing.save
      expect(name_with_extra_spacing.name).to eq(correct_name)
    end

  end


end
