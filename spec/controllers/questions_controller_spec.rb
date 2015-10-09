require 'rails_helper'
include RandomData

RSpec.describe QuestionsController, type: :controller do
  let (:test_question) {Question.create!(title: "Test Question Title", body: "Test Question Body", resolved: false)}
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders the index view" do
      get :index
      expect(response).to render_template :index
    end

    it "makes @questions an array of all questions" do
      get :index
      expect(assigns :questions).to eq([test_question])
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, {id: test_question.id}
      expect(response).to have_http_status(:success)
    end
    it "renders the show view" do
      get :show, {id: test_question.id}
      expect(response).to render_template :show
    end
    it "assigns @question to the question to be shown" do
      get :show, {id: test_question.id}
      expect(assigns(:question)).to eq(test_question)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
    it "instantiates a Question object to @question" do
      get :new
      expect(assigns(:question)).not_to be_nil
    end
  end

  describe "POST #create" do
    it "increases the number of Questions by 1" do
      expect{post :create, question:{title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: false}}.to change(Question, :count).by(1)
    end
    it "creates a Question object from the parameters passed to it" do
      post :create, question:  {title: "Create Test Title1", body: "Create Test Body1", resolved: false}
      expect(assigns (:question)).to eq Question.last
      expect(Question.last.title).to eq "Create Test Title1"
      expect(Question.last.body).to eq "Create Test Body1"
      expect(Question.last.resolved).to eq false
    end
    it "redirects to the show action" do
      post :create, question: {title: "Create Test Title2", body: "Create Test Body2", resolved: false}
      expect(response).to redirect_to Question.last
    end
  end


  describe "GET #edit" do
    #post :create, question:  {title: "Create Test Title1", body: "Create Test Body1", resolved: false}
    it "returns http success" do
      get :edit, {id: test_question.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the edit view" do
      get :edit, {id: test_question.id}
      expect(response).to render_template :edit
    end

    it "sets @question to the question object passed to it." do
      get :edit, {id: test_question.id}

      question_instance = assigns(:question)
      expect(question_instance.title).to eq(test_question.title)
      expect(question_instance.id).to eq(test_question.id)
      expect(question_instance.body).to eq(test_question.body)
      expect(question_instance.resolved).to eq(test_question.resolved)
      expect(assigns (:question)).to eq(test_question)
    end
  end

  describe "PUT #update" do
    it "updates question with expected attributes" do
      new_title = "Revised Question Title"
      new_body = "Revised Question Body"
      new_resolved = true

      put :update, id: test_question.id, question: {title: new_title, body: new_body, resolved: new_resolved}
      updated_question = assigns(:question)
      expect(updated_question.id).to eq(test_question.id)
      expect(updated_question.title).to eq(new_title)
      expect(updated_question.body).to eq(new_body)
      expect(updated_question.resolved).to eq(new_resolved)
    end

    it "redirects to the updated question" do
      new_title = "Revised Question Title"
      new_body = "Revised Question Body"
      new_resolved = true

      put :update, id: test_question.id, question: {title: new_title, body: new_body, resolved: new_resolved}
      expect(response).to redirect_to test_question
    end
  end

  describe "DELETE destroy" do
    it "deletes the specified question" do
      delete :destroy, {id: test_question.id}
      count = Question.where({id: test_question.id}).size
      expect(count).to eq 0
    end

    it "redirects to the Question index action" do
      delete :destroy, {id: test_question.id}
      expect(response).to redirect_to questions_path
    end
  end


end
