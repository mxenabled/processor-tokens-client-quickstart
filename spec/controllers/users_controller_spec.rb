require "spec_helper"

describe ::UsersController do
  include_context "stub MX users"

  describe "GET index" do
    it "renders index" do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    it "renders new" do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe "GET create" do
    it "redirects to show" do
      post :create, :params => new_user_params

      expect(response).to redirect_to(:action => :show, :id => user.guid)
    end
  end

  describe "GET show" do
    it "renders show" do
      get :show, :params => params

      expect(response).to render_template(:show)
    end
  end

  describe "GET destroy" do
    it "redirects to show" do
      delete :destroy, :params => params

      expect(response).to redirect_to(:action => :index)
    end
  end
end
