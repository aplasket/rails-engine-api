require "rails_helper"

RSpec.describe "Items Endpoints" do
  describe "get all items" do
    it "lists all items" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      create_list(:item, 3, merchant_id: merchant1.id)
      create_list(:item, 4, merchant_id: merchant2.id)

      get "/api/v1/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_info = JSON.parse(response.body, symbolize_names: true)

      expect(item_info).to have_key(:data)
      expect(item_info[:data].count).to eq(7)

      item_info[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  end
end