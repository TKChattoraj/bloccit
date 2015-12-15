require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:my_user) {create(:user)}

  context "unauthenticated user" do
    it "GET index returns http unathenticated" do
      get :index
      expect(response).to have_http_status(401)
    end

    it "GET show returns http unauthenticated" do
      get :show, id: my_user.id
      expect(response).to have_http_status(401)
    end

    it "PUT update returns http unauthenticated" do
      new_user = build(:user)
      put :update, id: my_user.id, user: {name: new_user.name, email: new_user.email, password: new_user.password}
      expect(response).to have_http_status(401)
    end

    it "POST create returns http unauthenticated" do
      new_user = build(:user)
      post :create, id: my_user.id, user: {name: new_user.name, email: new_user.email, password: new_user.password}
      expect(response).to have_http_status(401)
    end
  end

  context "aunthenticated and unathorized users" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    it "GET index returns http forbidden" do
      get :index
      expect(response).to have_http_status(403)
    end

    it "PUT update returns http forbidden" do
      new_user = build(:user)
      put :update, id: my_user.id, user: {name: new_user.name, email: new_user.email, password: new_user.password}
      expect(response).to have_http_status(403)
    end

    it "POST create returns http forbidden" do
      new_user = build(:user)
      post :create, id: my_user.id, user: {name: new_user.name, email: new_user.email, password: new_user.password}
      expect(response).to have_http_status(403)
    end
  end

  context "authenticated and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end

    describe "GET index" do
      before {get :index}
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "returns my_post serialized" do
        expect([my_user].to_json).to eq response.body
      end
    end

    describe "GET show" do
      before { get :show, id: my_user.id}

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(my_user.to_json).to eq response.body
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        before do
          @new_user = build(:user)
          put :update, id: my_user.id, user: {name: @new_user.name, email: @new_user.email, password: @new_user.password, role: "admin"}
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "returns json content type" do
          expect(response.content_type).to eq 'application/json'
        end

        it "updates a user with the correct attributes" do
          hashed_json = JSON.parse(response.body)
          expect(hashed_json["name"]).to eq @new_user.name
          expect(hashed_json["email"]).to eq @new_user.email
          expect(hashed_json["role"]).to eq "admin"
        end
      end

      context "with invalid attributes" do
        before do
          put :update, id: my_user.id, user: { name: "", email: "bademail@", password: "short"}
        end

        it "returns http error" do
          expect(response).to have_http_status(400)
        end

        # Question:  Why do we get an "http error?"   We are authenticated and authorized so it seems we should get to the #update method.  Is it because the json response cannont be executed?

        it "returns the correct json error message" do
          expect(response.body).to eq({"error" => "User update failed", "status" => 400}.to_json)
        end
      end
    end

    describe "POST create" do
      context "with valid attributes" do
        before do
          @new_user = build(:user)
          post :create, id: my_user, user: {name: @new_user.name, email: @new_user.email, password: @new_user.password, role: "admin"}
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "returns json content type" do
          expect(response.content_type).to eq 'application/json'
        end

        it "creates a user with the correct attributes" do
          @last_created_user = User.last
          hashed_json = JSON.parse(response.body)
          expect(hashed_json["name"]). to eq @last_created_user.name
          expect(hashed_json["email"]). to eq @last_created_user.email
          expect(hashed_json["role"]). to eq @last_created_user.role
        end
        #Note:  Checkpoint doesn't seem to be testing that a user is actually created--meaning saved, only that the #create action sets up the @new_user with the righ attributes.
        #Also, seems to me the hashed_json[____] is what should be within the expect.  Might be symantics, but seems that we should "expect" the end result to be something not that something should be equal to the end result.
      end

      context "with invalid attributes" do
        before do
          post :create, user: {name: "", email: "bademail@", password: "short" }
        end

        it "retrns http error" do
          expect(response).to have_http_status(400)
        end

        it "returns the correct json error message" do
          expect(response.body).to eq({"error" => "User is invalid", "status" => 400}.to_json)
        end
      end
    end
  end
end
