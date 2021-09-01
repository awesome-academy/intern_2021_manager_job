require "rails_helper"

RSpec.describe AccountActivationsController, type: :controller do
  let!(:account){FactoryBot.create :account}

  before{@request.env["devise.mapping"] = Devise.mappings[:account]}

  describe "POST /create" do
    before do
      post :create, params: {account: {}}
    end

    it "should response code equals 200" do
      expect(response.response_code).to eq 200
    end
  end

  describe "GET /show" do
    before do
      get :show, params: {confirmation_token: account.confirmation_token}
    end

    it "should response code equals 200" do
      expect(response.response_code).to eq 200
    end
  end
end
