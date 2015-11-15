require 'rails_helper'
include RandomData
include SessionsHelper

RSpec.describe TopicsController, type: :controller do
let (:my_topic) {Topic.create(name: RandomData.random_sentence, description: RandomData.random_paragraph, rating_id: [1, 2, 3].sample)}

context "guest" do

  describe "GET index" do
    it "returns http success" do
     get :index
     expect(response).to have_http_status(:success)
   end

    it "renders the index view" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @topics to the array of all topics" do
      get :index
      expect(assigns(:topics)).to eq([my_topic])
    end
  end  #end of the  "Get Index"


  describe "GET show" do
    it "returns http success" do
      get :show, {id: my_topic.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, {id: my_topic.id}
      expect(response).to render_template :show
    end

    it "assigns @topic to the specified topic" do
      get :show, {id: my_topic.id}
      expect(assigns(:topic)).to eq(my_topic)
    end
  end #end of the "GET show"

  describe "GET new" do
    it "returns http redirect" do
      get :new
      expect(response).to redirect_to (new_session_path)
    end
  end # end GET new

  describe "POST create" do
    it "returns http redirect" do
      post :create, {topic: {name:RandomData.random_sentence, description: RandomData.random_paragraph}}
      expect(response).to redirect_to (new_session_path)
    end
  end
#end of the POST creat tests

  describe "GET edit" do
    it "returns http redirect" do
      get :edit, {id: my_topic.id}
      expect(response).to redirect_to(new_session_path)
    end
  end # end "GET edit tests"

  describe "PUT update" do
    new_name = RandomData.random_name
    new_description = RandomData.random_paragraph

    it "returns http redirect" do
      put :update, id: my_topic.id, topic: {name: new_name, description: new_description}
      expect(response).to redirect_to new_session_path
    end
  end #end for the "PUT update" tests

  describe  "DELETE destroy" do

    it "returns http redirect" do
      delete :destroy, {id: my_topic.id}
      expect(response).to redirect_to(new_session_path)
    end
  end #end of the Delete destroy tests
end

context "member user" do
  before do
    user = User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld", role: :member)
    create_session(user)
  end

  describe "GET index" do
    it "returns http success" do
     get :index
     expect(response).to have_http_status(:success)
   end

    it "renders the index view" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @topics to the array of all topics" do
      get :index
      expect(assigns(:topics)).to eq([my_topic])
    end
  end  #end of the  "Get Index"


  describe "GET show" do
    it "returns http success" do
      get :show, {id: my_topic.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the show view" do
      get :show, {id: my_topic.id}
      expect(response).to render_template :show
    end

    it "assigns @topic to the specified topic" do
      get :show, {id: my_topic.id}
      expect(assigns(:topic)).to eq(my_topic)
    end
  end #end of the "GET show"

  describe "GET new" do
    it "returns http redirect" do
      get :new
      expect(response).to redirect_to(topics_path)
    end
  end # end GET new

  describe "POST create" do
    it "returns http redirect" do
      post :create, {topic: {name:RandomData.random_sentence, description: RandomData.random_paragraph}}
      expect(response).to redirect_to(topics_path)
    end
  end
#end of the POST creat tests

  describe "GET edit" do
    it "returns http redirect" do
      get :edit, {id: my_topic.id}
      expect(response).to redirect_to(topics_path)
    end
  end # end "GET edit tests"

  describe "PUT update" do
    new_name = RandomData.random_name
    new_description = RandomData.random_paragraph

    it "returns http redirect" do
      put :update, id: my_topic.id, topic: {name: new_name, description: new_description}
      expect(response).to redirect_to(topics_path)
    end
  end #end for the "PUT update" tests

  describe  "DELETE destroy" do

    it "returns http redirect" do
      delete :destroy, {id: my_topic.id}
      expect(response).to redirect_to(topics_path)
    end
  end #end of the Delete destroy tests
end # end of member context

context "admin" do
  before do
    user = User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld", role: :admin)
    create_session(user)
  end

  describe "GET index" do
    it "returns http success" do
     get :index
     expect(response).to have_http_status(:success)
   end

    it "renders the index view" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @topics to the array of all topics" do
      get :index
      expect(assigns(:topics)).to eq([my_topic])
    end
  end  #end of the  "Get Index"


  describe "GET show" do
    it "returns http success" do
      get :show, {id: my_topic.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, {id: my_topic.id}
      expect(response).to render_template :show
    end

    it "assigns @topic to the specified topic" do
      get :show, {id: my_topic.id}
      expect(assigns(:topic)).to eq(my_topic)
    end
  end #end of the "GET show"

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end

    it "assigns the @topic to a new Topic" do
      get :new
      expect(assigns(:topic)).not_to be_nil
    end
  end # end GET new

  describe "POST create" do
    it "increases the number of topics by 1" do
      expect{post :create, {topic: {name: RandomData.random_sentence, description: RandomData.random_paragraph}}}.to change(Topic, :count).by(1)
    end
    it "assigns Topic.last to @topic" do
      post :create, {topic: {name: RandomData.random_sentence, description:  RandomData.random_paragraph}}
      expect(assigns(:topic)).to eq(Topic.last)
    end

    it "redirects to the new topic" do
      post :create, {topic: {name:RandomData.random_sentence, description: RandomData.random_paragraph}}
      expect(response).to redirect_to Topic.last
    end

    it "assigns the rating to a new topic" do
      severity = ["0", "1", "2"].sample
      expected_rating = Rating.find_by(severity: severity.to_i)
      post :create, {topic: {name:RandomData.random_sentence, description: RandomData.random_paragraph, rating: severity}}
      resulting_rating = assigns(:topic).rating
      expect(resulting_rating).to eq(expected_rating)
    end





  end
#end of the POST creat tests

  describe "GET edit" do
    it "returns http success" do
      get :edit, {id: my_topic.id}
      expect(response).to have_http_status(:success)
    end
    it "renders the edit view" do
      get :edit, {id: my_topic.id}
      expect(response).to render_template :edit
    end

    it "sets @topic to the specified topic" do
      get :edit, {id: my_topic.id}
      expect(assigns(:topic)).to eq(my_topic)
      topic_instance = assigns(:topic)
      expect(topic_instance.id).to eq(my_topic.id)
      expect(topic_instance.name).to eq(my_topic.name)
      expect(topic_instance.description).to eq(my_topic.description)
    end
  end # end "GET edit tests"

  describe "PUT update" do
    new_name = RandomData.random_name
    new_description = RandomData.random_paragraph
    new_rating = ["0", "1", "2"].sample
    it "updates topic with expected attributes" do
      put :update, id: my_topic.id, topic: {name: new_name, description: new_description, rating: new_rating}

      updated_topic = assigns(:topic)
      expect(updated_topic.id).to eq(my_topic.id)
      expect(updated_topic.name).to eq(new_name)
      expect(updated_topic.description).to eq(new_description)
      expect(updated_topic.rating).to eq(Rating.update_rating(new_rating))
    end

    it "redirects to the updated topic" do
      put :update, id: my_topic.id, topic: {name: new_name, description: new_description}
      expect(response).to redirect_to my_topic
    end
  end #end for the "PUT update" tests

  describe  "DELETE destroy" do
    it "deletes the topic" do
      delete :destroy, {id: my_topic.id}
      count = Topic.where({id: my_topic.id}).size
      expect(count).to eq(0)
    end
    it "redirects to the index view" do
      delete :destroy, {id: my_topic.id}
      expect(response).to redirect_to topics_path
    end
  end #end of the Delete destroy tests
end  #end of admin context


end #end for the RSpec TopicsController
