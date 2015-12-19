require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) {create(:topic)}
  #let(:my_post) {create(:post, title: "New Post Title", body: "New Post Title Body", user: my_user.id, topic: my_topic.id)}

  context "unathenticated user" do
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_topic.id
      expect(response).to have_http_status(:success)
    end

    it "PUT update returns http unauthenticated" do
      put :update, id: my_topic.id, topic: {name: "Topic Name", description: "Topic Description"}
      expect(response).to have_http_status(401)
    end

    it "POST create returns http unathenticated" do
      post :create, id: my_topic.id, topic: {name: "Topic Name", description: "Topic Description"}
      expect(response).to have_http_status(401)
    end

    it "DELETE destroy returns http unathenticated" do
      delete :destroy, id: my_topic.id
      expect(response).to have_http_status(401)
    end

    it "POST create post returns http unauthenticated" do
      post :create_post, topic_id: my_topic.id, post: {title: "New Post Title", body: "New Post Body that is long enough"}
      expect(response).to have_http_status(401)
    end

  end

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "GET show returns http success" do
      get :show, id: my_topic.id
      expect(response).to have_http_status(:success)
    end
    it "PUT update returns http forbidden" do
      put :update, id: my_topic.id, topic: {name: "Topic Name", description: "Topic Description"}
      expect(response).to have_http_status(403)
    end

    it "POST create returns http forbidden" do
      post :create, id: my_topic.id, topic: {name: "Topic Name", description: "Topic Description"}
      expect(response).to have_http_status(403)
    end

    it "DELETE destroy returns http forbidden" do
      delete :destroy, id: my_topic
      expect(response).to have_http_status(403)
    end
  end

  context "authenticated and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      @new_topic = build(:topic)
    end

    describe "PUT update" do
      before { put :update, id: my_topic.id, topic: {name: @new_topic.name, description: @new_topic.description}}

      it "returns http success" do
         expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
         expect(response.content_type).to eq 'application/json'
      end

      it "updates a topic with the correct attributes" do
         updated_topic = Topic.find(my_topic.id)
         expect(response.body).to eq updated_topic.to_json
      end
    end

    describe "POST create" do

      before {post :create, topic: {name: @new_topic.name, description: @new_topic.description}}


      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        post :create, topic: {name: @new_topic.name, description: @new_topic.description}
        expect(response.content_type).to eq 'application/json'
      end

      it "creates a new topic having the given attributes" do
        post :create, topic: {name: @new_topic.name, description: @new_topic.description}
        hashed_json = JSON.parse(response.body)
        expect(hashed_json["name"]).to eq @new_topic.name
        expect(hashed_json["description"]).to eq @new_topic.description
      end
    end

    describe "DELETE destroy" do
      before do
        @ident = my_topic.id
        delete :destroy, id: my_topic.id
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "destroys the specified topic" do
        deleted_topic_count = Topic.where(@ident).count
        expect(deleted_topic_count).to eq 0
        expect{Topic.find(my_topic.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
  context "authenticated and authorized member creating a post" do
    before do
      my_user.member!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      post :create_post, topic_id: my_topic.id, post: {title: "New Post Title", body: "New Post Body that is long enough", user_id: my_user.id, topic_id: my_topic.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns json content type" do
      expect(response.content_type).to eq "application/json"
    end

    it "creates a new post with the given attributes" do
      @newly_created_post = Post.last
      puts @new_created_post
      hashed_json = JSON.parse(response.body)
      expect(hashed_json["title"]).to eq @newly_created_post.title
      expect(hashed_json["body"]).to eq @newly_created_post.body
    end
  end

  context "authenticated and authorized admin creating a post" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      post :create_post, topic_id: my_topic.id, post: {title: "New Post Title", body: "New Post Body that is long enough", user_id: my_user.id, topic_id: my_topic.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns json content type" do
      expect(response.content_type).to eq "application/json"
    end

    it "creates a new post with the given attributes" do
      @newly_created_post = Post.last
      puts @new_created_post
      hashed_json = JSON.parse(response.body)
      expect(hashed_json["title"]).to eq @newly_created_post.title
      expect(hashed_json["body"]).to eq @newly_created_post.body
    end
  end



end
