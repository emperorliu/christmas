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
    
    context "with valid inputs" do
      it "saves the user_id to the session" do
        jeff = Fabricate(:user)
        post :create, { username: jeff.username, password: jeff.password }
        expect(session[:user_id]).to eq(jeff.id)
      end

      it "redirects to the ideas_path" do
        jeff = Fabricate(:user)
        post :create, { username: jeff.username, password: jeff.password }
        expect(response).to redirect_to ideas_path
      end

      it "sets a flash success" do
        jeff = Fabricate(:user)
        post :create, { username: jeff.username, password: jeff.password }
        expect(flash[:success]).not_to be_blank 
      end

    end

    context "with invalid inputs" do

      it "does not save user_id to the session" do
        jeff = Fabricate(:user)
        post :create, { username: jeff.username, password: jeff.password + "123" }
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the root path" do
        jeff = Fabricate(:user)
        post :create, { username: jeff.username, password: jeff.password + "123" }
        expect(response).to redirect_to root_path
      end

      it "sets a danger error" do
        jeff = Fabricate(:user)
        post :create, { username: jeff.username, password: jeff.password + "123" }
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do

    context "loggin out" do
      it "removes the user_id from the session" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        get :destroy
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the root path" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        get :destroy
        expect(response).to redirect_to root_path
      end

      it "sets a flash danger notice" do
        jeff = Fabricate(:user)
        session[:user_id] = jeff.id
        get :destroy
        expect(flash[:danger]).not_to be_blank
      end

    end
  end

end