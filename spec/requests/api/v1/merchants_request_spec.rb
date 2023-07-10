require "rails_helper"

RSpec.describe "Merchant Endpoints" do
  describe "get all merchants" do
    it "list of all merchants" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)

      get "/api/v1/merchants"

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end
  end

  describe "get one merchant" do

  end

  describe "get all items for a given merchant id" do

  end
end