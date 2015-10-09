require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:test_question) {Question.create!(title: "Test Question Title", body: "Test Question Body", resolved: false)}
  describe "attributes" do
    it "should respond to title" do
      expect(test_question).to respond_to(:title)
    end
    it "should respond to body" do
      expect(test_question).to respond_to(:body)
    end
    it "should respond to resolved" do
      expect(test_question).to respond_to(:resolved)
    end
  end

end
