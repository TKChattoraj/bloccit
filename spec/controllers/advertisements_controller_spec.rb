require 'rails_helper'
#include RandomData

RSpec.describe AdvertisementsController, type: :controller do
  let (:advert) {Advertisement.create!(title: "Advertisement 1", copy: "Copy 1", price: 1)}

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns [advert] to @advertisments" do
      get :index
      expect(assigns(:advertisements)).to eq([advert])
    end

    it "renders the index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, {id: advert.id}
      expect(response).to have_http_status(:success)
    end

    it "instantiates the chosen advertisement--advert iin this case" do
      get :show, {id: advert.id}
      expect(assigns(:advertisement)).to eq(advert)
    end
    it "renders the #show view" do
      get :show, {id: advert.id}
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
      #this means the "get :new" gets to the AdvertismentController and new action.
    end

    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end

    it "instantiates an Advertisment object, @advertisement" do
      get :new
      expect(assigns(:advertisement)).not_to be_nil
    end
  end

  describe "POST #create" do
    it "increases the number of Advertisements by 1" do
      expect{post :create, advertisement:{title: "Advert Create Test Title", copy: "Advert Create Test Copy", price: 1}}.to change(Advertisement,:count).by(1)
    end

    it "instantiates the newly created advertisement" do
      post :create, advertisement: {title: "Advert Create Test Title", copy: "Advert Create Test Copy", price: 1}
      expect(assigns :advertisement).to eq(Advertisement.last)
    end

    it "redirects to the #show view showing the created advertisement" do
      post :create, advertisement: {title: "Advert Create Test Title", copy: "Advert Create Test Copy", price: 1}
      expect(response).to redirect_to Advertisement.last
    end

  end


  #describe "GET #edit" do
    #it "returns http success" do
      #get :edit
      #expect(response).to have_http_status(:success)
    #end
  #end

end
