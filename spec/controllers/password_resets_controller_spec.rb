require "rails_helper"

RSpec.describe PasswordResetsController, type: :controller do
  let!(:account){FactoryBot.create :account}
  let(:update_params){{account: {reset_password_token: "",
                                 password: account.password,
                                 password_confirmation: account.password}}}

  before{@request.env["devise.mapping"] = Devise.mappings[:account]}

  describe "GET /new" do
    before {get :new}

    it "render template :new" do
      expect(response).to render_template :new
    end
  end

  describe "POST /create" do
    context "when fill in wrong email" do
      before do
        post :create, params: {account: {email: "f@gmai.com"}}
      end

      it "re-render template new" do
        expect(response).to render_template :new
      end
    end

    context "when email is correct" do
      before do
        post :create, params: {account: {email: account.email}}
      end

      it "redirect to sign-in page" do
        expect(response).to redirect_to new_account_session_path
      end
    end
  end

  describe "GET /edit" do
    before do
      get :edit, params: {reset_password_token: account.reset_password_token}
    end

    it "should render template edit" do
      expect(response).to render_template :edit
    end
  end

  describe "PATCH /update" do
    context "when wrong token" do
      before do
        patch :update, params: update_params
      end

      it "should response code equal 200" do
        expect(response.response_code).to eq 200
      end
    end

    context "when corrent token" do
      before do
        update_params[:reset_password_token] = account.reset_password_token
        patch :update, params: update_params
      end
      it "should response code equal 200" do
        expect(response.response_code).to eq 200
      end
    end
  end
end
