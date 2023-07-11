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

      merchants_info = JSON.parse(response.body, symbolize_names: true)
      expect(merchants_info).to have_key(:data)
      expect(merchants_info[:data].count).to eq(3)
      expect(merchants_info[:data]).to be_an(Array)

      merchants_info[:data].each do |merchant|
        expect(merchant).to be_a(Hash)

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "get one merchant" do
    it "lists out one merchant" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      get "/api/v1/merchants/#{merchant1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_data[:data]).to have_key(:id)
      expect(merchant_data[:data][:id]).to be_a(String)
      expect(merchant_data[:data][:id]).to eq(merchant1.id.to_s)
      expect(merchant_data[:data][:id]).to_not eq(merchant2.id.to_s)
      expect(merchant_data[:data][:attributes]).to have_key(:name)
      expect(merchant_data[:data][:attributes][:name]).to be_a(String)
      expect(merchant_data[:data][:attributes][:name]).to eq(merchant1.name)
    end
  end

  describe "get all items for a given merchant id" do
    it "lists out all items for a merchant" do
      merchant1 = create(:merchant)

      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      item3 = create(:item, merchant_id: merchant1.id)

      get "/api/v1/merchants/#{merchant1.id}/items"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant1_items = JSON.parse(response.body, symbolize_names: true)
      expect(merchant1_items).to have_key(:data)
      expect(merchant1_items[:data]).to be_an(Array)
      expect(merchant1_items[:data].count).to eq(3)

      item = merchant1_items[:data][0]

      expect(item).to be_a(Hash)
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:id]).to eq(item1.id.to_s)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:name]).to eq(item1.name)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:description]).to eq(item1.description)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:unit_price]).to eq(item1.unit_price)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant1.id)
    end

    xit "lists error code if merchant can't be found" do

      get "/api/v1/merchants/101/items"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end