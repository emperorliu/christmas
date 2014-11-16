require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

  end

  describe "POST create" do
    
    context "with valid inputs" do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "saves the user in the session immediately" do
        expect(session[:user_id]).not_to be_nil
      end

      it "redirects to pool page" do
        expect(page).to redirect_to ideas_path
      end
    end
    
    context "with invalid inputs" do
      before { post :create, user: { username: 'jeff' } }
      
      it "doesn't create a user" do
        expect(User.count).to eq(0)    
      end

      it "renders the register page" do
        expect(page).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)  
      end

    end
  end

end