require "rails_helper"

RSpec.describe Item do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "#class methods" do
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

    it "#finds_all" do
      expect(Item.find_all(name: "paint").count).to eq(6)
      expect(Item.find_all(name: "paint", min_price: 4.99)).to eq(false)
      expect(Item.find_all(name: "paint", min_price: 4.99, max_price: 99.99)).to eq(false)
      expect(Item.find_all(min_price: 4.99).count).to eq(5)
      expect(Item.find_all(max_price: 99.99).count).to eq(5)
      expect(Item.find_all(min_price: 4.99, max_price: 99.99).count).to eq(4)
      expect(Item.find_all(name: "")).to eq(false)
      expect(Item.find_all(min_price: -2)).to eq(false)
      expect(Item.find_all(max_price: -1)).to eq(false)
    end

    it "#find_by_name" do
      expect(Item.find_all_by_name(name: "paint").count).to eq(6)
      expect(Item.find_all_by_name(name: "paint")[0]).to eq(@item1)
    end

    it "#find by price" do
      expect(Item.find_by_price(min_price: 4.99)).to eq([@item2, @item3, @item4, @item5, @item6])
      expect(Item.find_by_price(min_price: 4.99)).to_not eq([@item1, @item2, @item3, @item4, @item5, @item6])
      expect(Item.find_by_price(min_price: 4.99).count).to eq(5)

      expect(Item.find_by_price(max_price: 99.99).count).to eq(5)
      expect(Item.find_by_price(max_price: 99.99)).to eq([@item1, @item2, @item3, @item5, @item6])

      expect(Item.find_by_price(min_price: 4.99, max_price: 99.99).count).to eq(4)
      expect(Item.find_by_price(min_price: 4.99, max_price: 99.99)).to eq([@item2, @item3, @item5, @item6])
    end
  end
end