require 'spec_helper'

describe LikedItemsController do
  let(:jeff) { Fabricate(:user) }

  describe 'GET index'
    context "with authenticated users" do
      before { set_current_user(jeff) }
      
      it "sets @liked_items to be all the liked_items of the current user" do
        idea1 = Fabricate(:idea)
        idea2 = Fabricate(:idea)
        liked_item1 = LikedItem.create(user_id: jeff.id, idea_id: idea1.id)
        liked_item2 = LikedItem.create(user_id: jeff.id, idea_id: idea2.id)
        get :index
        expect(assigns(:liked_items)). to eq([liked_item2, liked_item1])
      end

      it "renders the index template that displays all liked_items" do
        get :index
        expect(response).to render_template :index
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

  describe 'POST create' do

    context "with authenticated users" do
      before { set_current_user(jeff) }

      it "creates a liked item and associates it with the idea" do
        idea1 = Fabricate(:idea)
        post :create, idea_id: idea1.id
        expect(LikedItem.first.idea_id).to eq(idea1.id)
      end

      it "creates a liked item and associates it with the current_user" do
        idea1 = Fabricate(:idea)
        post :create, idea_id: idea1.id
        expect(LikedItem.first.user_id).to eq(jeff.id)
      end

      it "redirects to the liked_items page" do
        idea1 = Fabricate(:idea)
        post :create, idea_id: idea1.id
        expect(response).to redirect_to home_path
      end
    end
    
    context "with unauthenticated users" do

      it "requires sign in" do
        session[:user_id] = nil
        idea1 = Fabricate(:idea)
        post :create, idea_id: idea1.id
        expect(response).to redirect_to root_path
      end
    end

  end
end