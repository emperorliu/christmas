require 'spec_helper'

describe IdeasController do
  let(:jeff) { Fabricate(:user) }
  
  describe "GET index" do
    context "with authenticated users" do
      before { set_current_user(jeff) }
      
      it "should show the index template" do
        get :index
        expect(response).to render_template :index
      end

      it "should set the @ideas variable to equal all ideas" do
        idea1 = Fabricate(:idea, user: jeff, price: "$10")
        idea2 = Fabricate(:idea, user: jeff, price: "$20")
        suzy = Fabricate(:user)
        idea3 = Fabricate(:idea, user: suzy, price: "$30")
        get :index
        expect(assigns(:ideas)).to eq([idea3, idea2, idea1])
      end
    end

  it_behaves_like "requires sign in" do
    let(:action) { get :index }
  end

end

  describe "GET new" do
    context "with authenticated users" do
      before { set_current_user(jeff) }

      it "should render the new idea page" do
        get :new
        expect(response).to render_template 'ideas/new'
      end

      it "sets the @idea variable" do
        get :new
        expect(assigns[:idea]).to be_instance_of(Idea)
      end
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
end

  describe "POST create" do
    context "with authenticated users" do
      before { set_current_user(jeff) }

      context "with valid inputs" do
        before { post :create, idea: Fabricate.attributes_for(:idea) }
        
        it "creates an idea" do
          expect(Idea.count).to eq(1)
        end

        it "creates an idea associated with the user" do
          expect(Idea.first.user).to eq(jeff)
        end

        it "redirects to ideas page" do
          expect(response).to redirect_to ideas_path
        end

      end

    context "with invalid inputs" do
      before { post :create, idea: { recipient: "brother", price: "$0-10" } }
      
      it "does not create an idea" do
        expect(Idea.count).to eq(0)
      end

      it "renders the add idea page" do
        expect(response).to render_template 'ideas/new'
      end

      it "sets the @idea" do
        expect(assigns[:idea]).to be_instance_of(Idea)
      end
    end

    end

    it_behaves_like "requires sign in" do
     let(:action) { post :create, idea: { recipient: "brother", price: "$0-10" } }
    end

  end

  describe "DELETE destroy" do
    
    context "with authenticated users" do
      it "destroys the item of the current user" do
        set_current_user(jeff)
        idea1 = Fabricate(:idea, user: jeff)
        delete :destroy, id: idea1.id
        expect(Idea.count).to eq(0)
      end

      it "redirects to the ideas page" do
        set_current_user(jeff)
        idea1 = Fabricate(:idea, user: jeff)
        delete :destroy, id: idea1.id
        expect(response).to redirect_to ideas_path
      end

      it "doesn't delete the item if it's not of the current user" do
        suzy = Fabricate(:user)
        set_current_user(jeff)
        idea1 = Fabricate(:idea, user: suzy)
        delete :destroy, id: idea1.id
        expect(Idea.count).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the root path" do
        session[:user_id] = nil
        idea1 = Fabricate(:idea, user: jeff)
        delete :destroy, id: idea1.id
        expect(response).to redirect_to root_path
      end
    end


  end


end