require "rails_helper"

RSpec.describe "/api/v1/items/:item_id/merchant" do
  describe "get an item's merchant" do
    it "returns data about an item's merchant" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)
      expect(item_data[:data]).to have_key(:attributes)

      expect(item_data[:data]).to have_key(:id)
      expect(item_data[:data][:id]).to be_a(String)
      expect(item_data[:data][:id]).to eq(merchant.id.to_s)

      expect(item_data[:data]).to have_key(:attributes)
      expect(item_data[:data][:attributes]).to have_key(:name)
      expect(item_data[:data][:attributes][:name]).to be_a(String)
      expect(item_data[:data][:attributes][:name]).to eq(merchant.name)

      expect(item_data[:data]).to have_key(:type)
      expect(item_data[:data][:type]).to be_a(String)
      expect(item_data[:data][:type]).to eq("merchant")
    end
  end
end