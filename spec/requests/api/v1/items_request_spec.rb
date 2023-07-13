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

  describe "creates one item" do
    it "creates a new item" do
      item_params = ({
        name: "Widget",
        description: "High quality widget",
        unit_price: 100.99,
        merchant_id: create(:merchant).id
      })

      headers = { "CONTENT_TYPE" => "application/json "}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  describe "update an existing item" do
    it "can update an item" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      edit_item_params = {  name: "New Widget Name",
                            description: "High quality widget, now with more widgety-ness",
                            unit_price: 299.99,
                            merchant_id: merchant.id }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: edit_item_params})

      updated_item = Item.find_by(id: item.id)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(updated_item.name).to eq("New Widget Name")
      expect(updated_item.description).to eq("High quality widget, now with more widgety-ness")
      expect(updated_item.unit_price).to eq(299.99)
      expect(updated_item.merchant_id).to eq(merchant.id)
      expect(updated_item.name).to_not eq(item.name)
      expect(updated_item.description).to_not eq(item.description)
      expect(updated_item.unit_price).to_not eq(item.unit_price)
    end

    it "updates items with only partial data too" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      edit_item_params = { name: "A Newer Widget Name" }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: edit_item_params})

      updated_item = Item.find_by(id: item.id)

      expect(response).to be_successful
      expect(updated_item.name).to eq("A Newer Widget Name")
      expect(updated_item.name).to_not eq(item.name)
    end
  end

  describe "destroy" do
    it "can destroy an item" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "sad path & edge cases" do
    it "sad path, bad integer id returns 404" do
      item_id = 8923987297

      get "/api/v1/items/#{item_id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "sad path, string id returns 404" do
      item_id = "99"
      get "/api/v1/items/#{item_id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "edge case, bad merchant id returns 400 or 404" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      edit_item_params = {  name: "New Widget Name",
                            description: "High quality widget, now with more widgety-ness",
                            unit_price: 299.99,
                            merchant_id: 999999 }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: edit_item_params})

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect{item.update!(edit_item_params)}.to raise_error(ActiveRecord::RecordInvalid)
      expect{Merchant.find(999999)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can destroy an item's invoice if it's only item on it" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      customer = create(:customer)
      invoice = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      invoice_item = create(:invoice_item, item_id: item.id, invoice_id: invoice.id)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "cannot destroy an item's invoice if has more items on it" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      customer = create(:customer)
      invoice = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      invoice_item = create(:invoice_item, item_id: item.id, invoice_id: invoice.id)
      invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice.id)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{Invoice.find(invoice.id)}.to_not raise_error(ActiveRecord::RecordNotFound)
    end
  end
end