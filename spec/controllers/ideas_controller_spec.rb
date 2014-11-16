require 'spec_helper'

describe IdeasController do
  
  describe "GET index" do
    context "with authenticated users" do
      
      it "should show the index template" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        get :index
        expect(response).to render_template :index
      end

      it "should set the @ideas variable to equal all ideas" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        idea1 = Fabricate(:idea, user: jeff, price: "$10")
        idea2 = Fabricate(:idea, user: jeff, price: "$20")
        suzy = Fabricate(:user)
        idea3 = Fabricate(:idea, user: suzy, price: "$30")
        get :index
        expect(assigns(:ideas)).to eq([idea3, idea2, idea1])
      end
    end

    context "with unauthenticated users" do

      it "should redirect to root path" do
        jeff = Fabricate(:user)
        get :index
        expect(response).to redirect_to root_path
      end
    end

end

  describe "GET new" do
    context "with authenticated users" do

      it "should render the new idea page" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        get :new
        expect(response).to render_template 'ideas/new'
      end

      it "sets the @idea variable" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        get :new
        expect(assigns[:idea]).to be_instance_of(Idea)
      end
    end

    context "with unauthenticated users" do
      
      it "should redirect to root path" do
        jeff = Fabricate(:user)
        get :new
        expect(response).to redirect_to root_path
      end
    end
end

  describe "POST create" do
    context "with authenticated users" do
      context "with valid inputs" do
        
        it "creates an idea" do
          jeff = Fabricate(:user)
          session[:user_id] = jeff.id
          post :create, idea: Fabricate.attributes_for(:idea)
          expect(Idea.count).to eq(1)
        end

        it "creates an idea associated with the user" do
          jeff = Fabricate(:user)
          session[:user_id] = jeff.id
          post :create, idea: Fabricate.attributes_for(:idea)
          expect(Idea.first.user).to eq(jeff)
        end

        it "redirects to ideas page" do
          jeff = Fabricate(:user)
          session[:user_id] = jeff.id
          post :create, idea: Fabricate.attributes_for(:idea)
          expect(response).to redirect_to ideas_path
        end

      end

    context "with invalid inputs" do
      
      it "does not create an idea" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        post :create, idea: { recipient: "brother", price: "$0-10" }
        expect(Idea.count).to eq(0)
      end

      it "renders the add idea page" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        post :create, idea: { recipient: "brother", price: "$0-10" }
        expect(response).to render_template 'ideas/new'
      end

      it "sets the @idea" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        post :create, idea: { recipient: "brother", price: "$0-10" }
        expect(assigns[:idea]).to be_instance_of(Idea)
      end
    end

    end

    context "with unauthenticated users" do
      it "redirects to the root path" do
        jeff = Fabricate(:user)
        session[:user_id] = nil
        post :create, idea: { recipient: "brother", price: "$0-10" }
        expect(response).to redirect_to root_path
      end

    end

  end

  describe "DELETE destroy" do
    
    context "with authenticated users" do
      it "destroys the item of the current user" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        idea1 = Fabricate(:idea, user: jeff)
        delete :destroy, id: idea1.id
        expect(Idea.count).to eq(0)
      end

      it "redirects to the ideas page" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        idea1 = Fabricate(:idea, user: jeff)
        delete :destroy, id: idea1.id
        expect(response).to redirect_to ideas_path
      end

      it "doesn't delete the item if it's not of the current user" do
        jeff = Fabricate(:user)
        suzy = Fabricate(:user)
        session[:user_id] = jeff.id
        idea1 = Fabricate(:idea, user: suzy)
        delete :destroy, id: idea1.id
        expect(Idea.count).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the root path" do
        jeff = Fabricate(:user)
        session[:user_id] = nil
        idea1 = Fabricate(:idea, user: jeff)
        delete :destroy, id: idea1.id
        expect(response).to redirect_to root_path
      end
    end


  end




end