require "rails_helper"

RSpec.describe "/merchants/find" do
  describe "search merchants by name" do
    it "fetch one merchant by fragment" do
      merchant1 = create(:merchant, name: "RingWorld")
      merchant2 = create(:merchant, name: "Turing")

      query_params = {
        name: "ring"
      }

      get "/api/v1/merchants/find", params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_data).to have_key(:data)
      expect(merchant_data.count).to eq(1)
      expect(merchant_data).to be_a(Hash)

      merchant = merchant_data[:data]
      expect(merchant).to be_a(Hash)

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to eq(merchant1.id.to_s)
      expect(merchant[:id]).to_not eq(merchant2.id.to_s)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eq(merchant1.name)
      expect(merchant[:attributes][:name]).to_not eq(merchant2.name)
    end

    it "sad path, no fragment matched" do
      query_params = {
        name: "nomatch"
      }

      get "/api/v1/merchants/find", params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_data).to have_key(:data)

      expect(merchant_data[:data][:id]).to eq(nil)
    end
  end

  describe "GET /api/v1/revenue/merchants?quantity=x" do
    xit "returns the revenue of X merchants" do
      get "/api/v1/revenue/merchants", params: { quantity: 3}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to have_key(:data)
    end
  end
end