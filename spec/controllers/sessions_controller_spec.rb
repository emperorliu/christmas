require 'spec_helper'

describe SessionsController do
  
  describe 'GET new' do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
    it "redirect to the ideas path for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to ideas_path
    end
  end

  describe 'POST create' do
    let(:jeff) { Fabricate(:user) }
    
    context "with valid inputs" do
      before { post :create, { username: jeff.username, password: jeff.password } }

      it "saves the user_id to the session" do
        expect(session[:user_id]).to eq(jeff.id)
      end

      it "redirects to the ideas_path" do
        expect(response).to redirect_to ideas_path
      end

      it "sets a flash success" do
        expect(flash[:success]).not_to be_blank 
      end

    end

    context "with invalid inputs" do
      before { post :create, { username: jeff.username, password: jeff.password + "123" } }

      it "does not save user_id to the session" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the root path" do
        expect(response).to redirect_to root_path
      end

      it "sets a danger error" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    let(:jeff) { Fabricate(:user) }
    before { set_current_user(jeff) }

    it "removes the user_id from the session" do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      get :destroy
      expect(response).to redirect_to root_path
    end

    it "sets a flash danger notice" do
      get :destroy
      expect(flash[:danger]).not_to be_blank
    end

  end

end