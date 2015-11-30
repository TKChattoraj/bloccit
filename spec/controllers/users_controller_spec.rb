require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let (:new_user_attributes) do
    {
      name: "BlockHead",
      email: "blochead@bloc.io",
      password: "blochead",
      Password_confirmation: "blochead"
    }
  end
  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the new view" do
      get :new
      expect(response).to render_template :new
    end

    it "instantiates a new user" do
      get :new
      expect(:user).to_not be_nil
    end
  end

  describe "POST create" do

    it "returns http success" do
      post :create, {user: new_user_attributes}
      expect(response).to have_http_status(:redirect)
    end

    it "creates a new user" do
      expect{post :create, user: new_user_attributes}.to change(User, :count).by(1)
    end

    it "assigns the name attribute" do
      post :create, {user: new_user_attributes}
      expect(assigns(:user).name).to eq(new_user_attributes[:name])
    end

    it "assigns the email attribute" do
      post :create, {user: new_user_attributes}
      expect(assigns(:user).email).to eq(new_user_attributes[:email])
    end

    it "assigns the password attribute" do
      post :create, {user: new_user_attributes}
      expect(assigns(:user).password).to eq(new_user_attributes[:password])
    end

    it "assigns the password_confirmation properly" do
      post :create, {user: new_user_attributes}
      expect(assigns(:user).password_confirmation).to eq(new_user_attributes[:password_confirmation])
    end

    it "logs the user in after sign up" do
      post :create, user: new_user_attributes
      expect(session[:user_id]).to eq assigns(:user).id
    end
  end


  describe "not signed in" do
    let (:factory_user) {create(:user)}
    before do
      post :create, user: new_user_attributes
    end

    it "returns http success" do
      get :show, {id: factory_user.id}
      expect(response).to have_http_status(:success)
    end
    it "renders the #show view" do
      get :show, {id: factory_user.id}
      expect(response).to render_template :show
    end
    it "assigns factory_user to @user" do
      get :show, {id: factory_user.id}
      expect(assigns(:user)).to eq(factory_user)
    end
  end

  describe "it finds a user's favorite posts" do
    let(:factory_user) {create(:user)}
    let(:post1) {create(:post)}
    let(:post2) {create(:post)}
    it "assigns a user's favorites to @favorites" do
      favorite1 = Favorite.create!(post: post1, user: factory_user)
      favorite2 = Favorite.create!(post: post2, user: factory_user)
      get :show, {id: factory_user.id}
      expect(assigns(:favorites)).to eq([favorite1, favorite2])
    end

    it "assigns a user's favorite posts to @favorite_posts" do
      favorite1 = Favorite.create!(post: post1, user: factory_user)
      favorite2 = Favorite.create!(post: post2, user: factory_user)
      post_array = [post1, post2]
      get :show, {id: factory_user.id}
      expect(assigns(:favorite_posts)).to eq(post_array)
    end
  end






end
