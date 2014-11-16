require 'spec_helper'

describe LikedItemsController do
  
  describe 'GET index'
    context "with authenticated users" do
      
      it "sets @liked_items to be all the liked_items of the current user" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        idea1 = Fabricate(:idea)
        idea2 = Fabricate(:idea)
        liked_item1 = LikedItem.create(user_id: jeff.id, idea_id: idea1.id)
        liked_item2 = LikedItem.create(user_id: jeff.id, idea_id: idea2.id)
        get :index
        expect(assigns(:liked_items)). to eq([liked_item2, liked_item1])
      end

      it "renders the index template that displays all liked_items" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        get :index
        expect(response).to render_template :index
      end
    end

    context "with unauthenticated users" do
      
      it "redirects to the root path" do
        jeff = Fabricate(:user)
        session[:user_id] = nil
        get :index
        expect(response).to redirect_to root_path
      end
    end

  describe 'POST create' do
    
    it "creates a liked item and associates it with the idea" do
      jeff = Fabricate(:user)
      session[:user_id] = jeff.id
      idea1 = Fabricate(:idea)
      post :create, idea_id: idea1.id
      expect(LikedItem.first.idea_id).to eq(idea1.id)
    end

    it "creates a liked item and associates it with the current_user" do
      jeff = Fabricate(:user)
      session[:user_id] = jeff.id
      idea1 = Fabricate(:idea)
      post :create, idea_id: idea1.id
      expect(LikedItem.first.user_id).to eq(jeff.id)
    end

    it "redirects to the liked_items page" do
      jeff = Fabricate(:user)
      session[:user_id] = jeff.id
      idea1 = Fabricate(:idea)
      post :create, idea_id: idea1.id
      expect(response).to redirect_to home_path
    end

    it "requires sign in" do
      jeff = Fabricate(:user)
      session[:user_id] = nil
      idea1 = Fabricate(:idea)
      post :create, idea_id: idea1.id
      expect(response).to redirect_to root_path
    end

  end
end