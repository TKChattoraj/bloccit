require 'rails_helper'
include RandomData

RSpec.describe SponsoredPost, type: :model do
  let(:my_topic) {Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)}
  let(:my_sponsored_post) {my_topic.sponsored_posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, price: 5)}

  describe "attributes" do
    it "responds to title" do
      expect(my_sponsored_post).to respond_to(:title)
    end
    it "responds to title" do
      expect(my_sponsored_post).to respond_to(:body)
    end
    it "responds to price" do
      expect(my_sponsored_post).to respond_to(:price)
    end
    it "responds to topic_id" do
      expect(my_sponsored_post).to respond_to(:topic_id)
    end
  end
end
