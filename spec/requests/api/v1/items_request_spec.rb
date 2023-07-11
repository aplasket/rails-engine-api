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

  describe "gets one item" do
    it "lists an item by id" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      item3 = create(:item, merchant_id: merchant2.id)

      get "/api/v1/items/#{item1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_info = JSON.parse(response.body, symbolize_names: true)

      expect(item_info[:data]).to have_key(:id)
      expect(item_info[:data][:id]).to be_a(String)
      expect(item_info[:data][:id]).to eq(item1.id.to_s)
      expect(item_info[:data][:id]).to_not eq(item2.id.to_s)
      expect(item_info[:data][:id]).to_not eq(item3.id.to_s)

      expect(item_info[:data][:attributes]).to have_key(:name)
      expect(item_info[:data][:attributes][:name]).to be_a(String)
      expect(item_info[:data][:attributes][:name]).to eq(item1.name)
      expect(item_info[:data][:attributes][:name]).to_not eq(item2.name)

      expect(item_info[:data][:attributes]).to have_key(:description)
      expect(item_info[:data][:attributes][:description]).to be_a(String)
      expect(item_info[:data][:attributes][:description]).to eq(item1.description)
      expect(item_info[:data][:attributes][:description]).to_not eq(item2.description)

      expect(item_info[:data][:attributes]).to have_key(:unit_price)
      expect(item_info[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item_info[:data][:attributes][:unit_price]).to eq(item1.unit_price)

      expect(item_info[:data][:attributes]).to have_key(:merchant_id)
      expect(item_info[:data][:attributes][:merchant_id]).to be_an(Integer)
      expect(item_info[:data][:attributes][:merchant_id]).to eq(item1.merchant_id)
      expect(item_info[:data][:attributes][:merchant_id]).to_not eq(item3.merchant_id)
    end
  end
end