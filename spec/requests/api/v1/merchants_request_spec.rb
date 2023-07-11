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
      expect(merchant_data[:data][:attributes]).to have_key(:name)
      expect(merchant_data[:data][:attributes][:name]).to be_a(String)
    end
  end

  describe "get all items for a given merchant id" do

  end
end