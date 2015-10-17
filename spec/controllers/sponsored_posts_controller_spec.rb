require 'rails_helper'
include RandomData

RSpec.describe SponsoredPostsController, type: :controller do
  let(:my_topic) {Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)}
  let(:my_sponsored_post) {my_topic.sponsored_posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, price: rand(1..5))}
    describe "GET #new" do
      it "returns http success" do
        get :new, {topic_id: my_topic.id}
        expect(response).to have_http_status(:success)
      end

      it "renders the new view" do
        get :new, {topic_id: my_topic.id}
        expect(response).to render_template(:new)
      end

      it "initializes @sponsored_post" do
        get :new, {topic_id: my_topic.id}
        expect(assigns(:sponsored_post)).not_to be_nil
      end
    end

  describe "GET #show" do
    it "returns http success" do
      get :show, {topic_id: my_topic.id, id: my_sponsored_post.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the show view" do
      get :show, {topic_id: my_topic.id, id: my_sponsored_post.id}
      expect(response).to render_template(:show)
    end

    it "sets @sponsored_post to the designated sponsored_post" do
      get :show, {topic_id: my_topic.id, id: my_sponsored_post.id}
      expect(assigns(:sponsored_post)).to eq(my_sponsored_post)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, {topic_id: my_topic.id, id: my_sponsored_post.id}
      expect(response).to have_http_status(:success)
    end
    it "renders the edit view" do
      get :edit, {topic_id: my_topic.id, id: my_sponsored_post.id}
      expect(response).to render_template(:edit)
    end
    it "assigns @sponsored_post to the chosen post" do
      get :edit, {topic_id: my_topic.id, id: my_sponsored_post.id}
      s_post = assigns(:sponsored_post)
      title = my_sponsored_post.title
      body = my_sponsored_post.body
      price = my_sponsored_post.price
      topic = my_sponsored_post.topic_id
      expect(s_post).to eq my_sponsored_post
      expect(s_post.title).to eq title
      expect(s_post.body).to eq body
      expect(s_post.price).to eq price
      expect(s_post.topic_id).to eq topic
    end

  end

  describe "POST #create" do
    it "returns http found" do
      post :create, {topic_id: my_topic.id, sponsored_post: {title: "Title Create", body: "Title Body", price: 5}}
      expect(response).to have_http_status(:found)
    end

    it "redirects to the newly created post" do
      post :create, {topic_id: my_topic.id, sponsored_post: {title: "Title Create", body: "Title Body", price: 5}}
      expect(response).to redirect_to [my_topic, SponsoredPost.last]
    end

    it "increases the SponsoredPost model by 1" do
      post :create, {topic_id: my_topic.id, sponsored_post: {title: "Title Create", body: "Body Create", price: 5}}
      expect{post :create, {topic_id: my_topic.id, sponsored_post:{title: "Title Create", body: "Title Body", price: 5}}}. to change(SponsoredPost, :count).by(1)
    end
  end

  describe "PUT #update" do
    new_title = RandomData.random_sentence
    new_body = RandomData.random_paragraph
    new_price = rand(1...20)
    it "returns http found" do
      put :update, {topic_id: my_topic.id, id: my_sponsored_post.id, sponsored_post:{title: new_title, body: new_body, price: new_price}}
      expect(response).to have_http_status(:found)
    end

    it "redirects to the updated sponsored post" do
      put :update, {topic_id: my_topic.id, id: my_sponsored_post, sponsored_post: {title: new_title, body: new_body, price: new_price}}
      expect(response).to redirect_to [my_topic, my_sponsored_post]
    end

    it "updates the sponsored post with the given parameters" do
      put :update, {topic_id: my_topic.id, id: my_sponsored_post.id, sponsored_post: {title: new_title, body: new_body, price: new_price}}
      s_post = assigns(:sponsored_post)
      expect(s_post.id).to eq my_sponsored_post.id
      expect(s_post.title).to eq new_title
      expect(s_post.body).to eq new_body
      expect(s_post.price).to eq new_price
    end

  end

  describe "DELETE #destroy" do
    it "returns http found" do
      delete :destroy, {topic_id: my_topic.id, id: my_sponsored_post.id}
      expect(response).to have_http_status(:found)
    end

    it "deletes the specified sponsored post" do
      delete :destroy, {topic_id: my_topic.id, id: my_sponsored_post.id}
      count = SponsoredPost.where(my_sponsored_post.id).size
      expect(count).to eq(0)
    end

    it "redirects to the topic show view" do
      delete :destroy, {topic_id: my_topic.id, id: my_sponsored_post.id}
      expect(response).to redirect_to my_topic
    end

  end

end
