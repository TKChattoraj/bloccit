require 'rails_helper'
include RandomData
include SessionsHelper

RSpec.describe PostsController, type: :controller do

  let(:my_user) {User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}

  let(:my_other_user) {User.create!(name: RandomData.random_name, email: RandomData.random_email, password: "helloworld", role: :member)}

  let(:my_topic) {Topic.create!(name:RandomData.random_sentence, description: RandomData.random_paragraph)}

  #let(:user) {User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}

  let(:my_post) {my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user, rating_id: [1, 2, 3].sample)}

  context "guest user" do

    describe "GET show" do
      it "returns http success" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template :show
      end

      it "assigns my_post to @post" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
    end


    describe "GET new" do
      it "returns http redirect" do
        get :new, {topic_id: my_topic.id}
      expect(response).to redirect_to(new_session_path)
      end
    end

    describe "POST create" do
      it "returns http redirect" do
        post :create, {topic_id: my_topic.id, post:{title: RandomData.random_sentence, body: RandomData.random_paragraph}}
        expect(response).to redirect_to(new_session_path)
      end
    end


    describe "GET edit" do
      it "returns http redirect" do
        get :edit, {topic_id: my_topic.id, id: my_post.id}
        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "PUT update" do
      it "returns http redirect" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, {topic_id: my_topic, id: my_post.id, post: {title: new_title, body: new_body}}
        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "DELETE destroy" do
      it "retursn http redirect" do
        delete :destroy, {topic_id: my_topic.id, id: my_post.id}
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

####
  context "member user doing CRUD on a post they don't own" do
    before do
      create_session(my_other_user)
    end
    describe "GET show" do
      it "returns http success" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template :show
      end

      it "assigns my_post to @post" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new, topic_id: my_topic.id
        expect(response).to have_http_status(:success)
      end
      it "renders the #new veiw" do
        get :new, topic_id: my_topic.id
        expect(response).to render_template :new
      end

      it "instantiates @post" do
        get :new, topic_id: my_topic.id
        expect(assigns(:post)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of Post by 1" do
         expect{post :create, {topic_id: my_topic.id, post:{title: RandomData.random_sentence, body: RandomData.random_paragraph}}}.to change(Post, :count).by(1)
      end

     it "assigns the new post to @post" do
       post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
       expect(assigns(:post)).to eq Post.last
      end

     it "redirects to the new post" do
       post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
       expect(response).to redirect_to [my_topic, Post.last]
      end
    end

   describe "GET edit" do
     it "returns http redirect" do
       get :edit, {topic_id: my_topic.id, id: my_post.id}
       expect(response).to redirect_to [my_topic, my_post]
      end
   end

   describe "PUT update" do
     it "returns http redirect" do
       new_title = RandomData.random_sentence
       new_body = RandomData.random_paragraph
       new_rating = ["0", "1", "2"].sample
       put :update, {topic_id: my_topic, id: my_post.id, post: {title: new_title, body: new_body, rating: new_rating}}
       expect(response).to redirect_to [my_topic, my_post]
     end
   end

   describe "DELETE destroy" do
     it "returns http redirect" do
       delete :destroy, {topic_id: my_topic.id, id: my_post.id}
       expect(response).to redirect_to [my_topic, my_post]
     end
    end

  end


  context "member user doing CRUD on a post they do own" do
    before do
      create_session(my_user)
    end

    describe "GET show" do
      it "returns http success" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template :show
      end

      it "assigns my_post to @post" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new, topic_id: my_topic.id
        expect(response).to have_http_status(:success)
      end
      it "instantiates @post" do
        get :new, topic_id: my_topic.id
        expect(assigns(:post)).not_to be_nil
      end

      it "renders the #new view" do
        get :new, topic_id: my_topic.id
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      it "increases the number of Pot by 1" do
        expect{post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Post, :count).by(1)
      end
      it "assigns the new post to @post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph, rating: ["0", "1", "2"].sample}
        expect(assigns(:post)).to eq(Post.last)
      end

      it "assigns the rating to a new post" do
        severity = ["0", "1", "2"].sample
        expected_rating = Rating.find_by(severity: severity.to_i)
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph, rating: severity}
        resulting_rating = assigns(:post).rating
        expect(resulting_rating).to eq(expected_rating)
      end

      it "redirects to the new post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to [my_topic, Post.last]
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        expect(response).to render_template :edit
      end

      it "assigns post to be updated to @post" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        post_instance = assigns(:post)
        expect(post_instance.id).to eq(my_post.id)
        expect(post_instance.title).to eq(my_post.title)
        expect(post_instance.body).to eq(my_post.body)
      end
    end

    describe "PUT update" do
      it "updates post with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        new_rating = ["0", "1", "2"].sample
        put :update, {topic_id: my_topic, id: my_post.id, post: {title: new_title, body: new_body, rating: new_rating}}

         updated_post = assigns(:post)
         expect(updated_post.id).to eq my_post.id
         expect(updated_post.title).to eq new_title
         expect(updated_post.body).to eq new_body
         expect(updated_post.rating).to eq (Rating.update_rating(new_rating))
      end

      it "redirects to the updated post" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title, boyd: new_body}

        expect(response).to redirect_to [my_topic, my_post]
      end
    end

    describe "DELETE destroy" do
      it "deletes the post" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        count = Post.where({id: my_post.id}).size
        expect(count).to eq 0
      end


      it "redirects to posts index" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        expect(response).to redirect_to my_topic
      end
    end
  end


  context "admin user doing CRUD on a post they don't own" do
    before do
      my_other_user.admin!
      create_session(my_other_user)
    end
    describe "GET show" do
      it "returns http success" do
        get :show, topic_id: my_topic.id, id: my_post.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template :show
      end

      it "assigns my_post to @post" do
        get :show, {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new, {topic_id: my_topic.id}
        expect(response).to have_http_status(:success)
      end
      it "instantiates @post" do
        get :new, {topic_id: my_topic.id}
        expect(assigns(:post)).not_to be_nil
      end
      it "renders the #new view" do
        get :new, {topic_id: my_topic.id}
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      it "increases the number of Post by 1" do
        expect{post :create, {topic_id: my_topic.id, post:{title: RandomData.random_sentence, body: RandomData.random_paragraph}}}.to change(Post, :count).by(1)
      end
      it "assigns the new post to @post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(assigns(:post)).to eq(Post.last)
      end
      it "redirects to the new_post" do
        post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
        expect(response).to redirect_to [my_topic, Post.last]
      end
    end

    describe "GET edit" do
      it "returns http redirect" do
        get :edit, {topic_id: my_topic.id, id: my_post.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #edit view" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        expect(response).to render_template :edit
      end
      it "assigns post to be updated to @post" do
        get :edit, topic_id: my_topic.id, id: my_post.id
        post_instance = assigns(:post)
        expect(post_instance.id).to eq(my_post.id)
        expect(post_instance.title).to eq(my_post.title)
        expect(post_instance.body).to eq(my_post.body)
      end
    end

    describe "PUT update" do
      it "updates post with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        new_rating = ["0", "1", "2"].sample
        put :update, {topic_id: my_topic, id: my_post.id, post: {title: new_title, body: new_body, rating: new_rating}}
        updated_post = assigns(:post)
        expect(updated_post.id).to eq(my_post.id)
        expect(updated_post.title).to eq(new_title)
        expect(updated_post.body).to eq(new_body)
        expect(updated_post.rating).to eq(Rating.update_rating(new_rating))
      end

      it "redirects to the updated post" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title, body: new_body}
        expect(response).to redirect_to [my_topic, my_post]
      end
    end

    describe "DELETE destroy" do
      it "deletes the post" do
        delete :destroy, {topic_id: my_topic.id, id: my_post.id}
        count = Post.where({id: my_post.id}).size
        expect(count).to eq(0)
      end

      it "redirects to the #post index" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        expect(response).to redirect_to my_topic
      end
    end
  end
end
