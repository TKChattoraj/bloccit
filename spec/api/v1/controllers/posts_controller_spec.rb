require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_topic) {create(:topic)}
  let(:my_user) {create(:user)}
  let(:my_other_user) {create(:user)}
  let(:my_post) {create(:post, topic: my_topic, user: my_user)}

  context "guest user" do
    #guest user will be unauthenticated
    describe "PUT update" do
      it "returns http unauthenticated" do
        put :update, id: my_post.id, post: {title: "Modified Title", body: "Modified body of Modified Title", topic_id: my_topic.id, user_id: my_other_user.id}
        expect(response).to have_http_status(401)
      end
    end
    describe "DELETE destroy" do
      it "returns http unauthenticated" do
        delete :destroy, id: my_post.id
        expect(response).to have_http_status(401)
      end
    end
  end

  context "member who is not post owner" do
    #such a member will be unauthorized
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_other_user.auth_token)
    end

    describe "PUT Update" do
      it "returns http unauthorized" do
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Modified Title", body: "Modified body of Modified Title"}
        expect(response).to have_http_status(403)
      end
    end
    describe "DELETE Destroy" do
      it "returns http unauthorized" do
        delete :destroy, id: my_post.id
        expect(response).to have_http_status(403)
      end
    end


  end

  context "member who is post owner" do

    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    describe "PUT Update" do
      before do
        put :update, id: my_post.id, post: {title: "Modified Title", body: "Modified body of Modified Title"}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "updates a post with the correct attributes" do
        updated_post = Post.find(my_post.id)
        expect(response.body).to eq updated_post.to_json
      end
    end
    describe "DELETE Destroy" do
      before do
        delete :destroy, id: my_post.id
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq "application/json"
      end

      it "destroys the specified post" do
        expect{Post.find(my_post.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end


    end
  end

  context "admin" do
    before do
      my_other_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_other_user.auth_token)
    end

    describe "PUT Update" do
      before do
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Modified Title", body: "Modified body of Modified Title"}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
         expect(response.content_type).to eq "application/json"
      end

      it "updates the post with correct attirbutes" do
         updated_post = Post.find(my_post.id)
         expect(response.body).to eq updated_post.to_json
      end
    end

    describe "DELETE Destroy" do
      before do
        delete :destroy, id: my_post.id
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq "application/json"
      end

      it "destroys the specified post" do
        expect{Post.find(my_post.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
