require "rails_helper"

RSpec.describe "/items/find_all" do
  describe "fetch all items matching a pattern" do
    before(:each) do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)

      @item1 = create(:item, merchant_id: @merchant1.id, name: "Acyrlic paint", unit_price: 3.00 )
      @item2 = create(:item, merchant_id: @merchant1.id, name: "Watercolor paint", unit_price: 7.00 )
      @item3 = create(:item, merchant_id: @merchant2.id, name: "Paintbrush", unit_price: 13.00 )
      @item4 = create(:item, merchant_id: @merchant2.id, name: "Paintball Gun", unit_price: 123.00 )
      @item5 = create(:item, merchant_id: @merchant3.id, name: "lavious painting", unit_price: 4.99 )
      @item6 = create(:item, merchant_id: @merchant3.id, name: "Sandpainting", unit_price: 99.99 )
    end

    it "find all items by name fragment" do
      query_params = {
        name: "paint"
      }

      get "/api/v1/items/find_all", params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_data = JSON.parse(response.body, symbolize_names: true)
      expect(item_data).to have_key(:data)
      expect(item_data[:data].count).to eq(6)
      expect(item_data[:data]).to be_an(Array)

      item = item_data[:data][0]
      expect(item).to have_key(:id)
      expect(item).to have_key(:type)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:name]).to eq(@item1.name)
    end

    xit "sad path, no fragment matched" do
      query_params = {
        name: "nomatch"
      }

      get "/api/v1/items/find_all", params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it "finds all items over a min price" do
      query_params = {
        min_price: 4.99
      }

      get "/api/v1/items/find_all", params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_data = JSON.parse(response.body, symbolize_names: true)
      expect(item_data).to have_key(:data)
      expect(item_data[:data].count).to eq(5)
      expect(item_data[:data]).to be_an(Array)

      item = item_data[:data][0]
      expect(item).to have_key(:id)
      expect(item).to have_key(:type)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:unit_price]).to eq(@item2.unit_price)
      expect(item[:attributes][:name]).to eq(@item2.name)
    end

    it "finds al items under a max price" do
      query_params = {
        max_price: 99.99
      }

      get "/api/v1/items/find_all", params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_data = JSON.parse(response.body, symbolize_names: true)
      expect(item_data).to have_key(:data)
      expect(item_data[:data].count).to eq(5)
    end

    it "it returns items between max and min price queries" do
      query_params = {
        min_price: 4.99,
        max_price: 99.99
      }

      get "/api/v1/items/find_all", params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      item_data = JSON.parse(response.body, symbolize_names: true)
      expect(item_data).to have_key(:data)
      expect(item_data[:data].count).to eq(4)
    end
  end
end