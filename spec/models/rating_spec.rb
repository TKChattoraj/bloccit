require 'rails_helper'

RSpec.describe Rating, type: :model do

  let(:rating) {Rating.create!(severity: :PG)}
  it {should have_many :posts}
  it {should have_many :topics}

  describe "attributes" do
    it "should respond to enum severity" do
      expect(rating).to respond_to(:severity)
    end
  end

  describe "update_rating" do
    it "takes a string value of the rating enum and returns the rating" do
      parameter_string = "2"
      correct_rating_result = Rating.find_by(severity: :R)
      expect(Rating.update_rating(parameter_string)).to eq(correct_rating_result)
    end
  end



end
