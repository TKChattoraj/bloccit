require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  let(:advert) {Advertisement.create!(title: "Advert Title", copy: "Advert Copy", price: 5)}
  describe "attributes" do
    it "should respond to title" do
      expect(advert).to respond_to(:title)
    end
    it "should respond to copy" do
      expect(advert).to respond_to(:copy)
    end
    it "should respond to price" do
      expect(advert).to respond_to(:price)
    end
  end
end
