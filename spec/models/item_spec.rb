require "rails_helper"

RSpec.describe Item do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "#class methods" do
    it "#find_by_name" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)

      item1 = create(:item, merchant_id: merchant1.id, name: "acyrlic paint", unit_price: 3.00 )
      item2 = create(:item, merchant_id: merchant1.id, name: "watercolor paint", unit_price: 5.00 )
      item3 = create(:item, merchant_id: merchant2.id, name: "paintbrush", unit_price: 13.00 )
      item4 = create(:item, merchant_id: merchant2.id, name: "paintball gun", unit_price: 23.00 )
      item5 = create(:item, merchant_id: merchant3.id, name: "lavious painting", unit_price: 7.00 )
      item6 = create(:item, merchant_id: merchant3.id, name: "sandpainting", unit_price: 103.00 )

      expect(Item.find_all_by_name("paint").count).to eq(6)
      expect(Item.find_all_by_name("paint")[0]).to eq(item1)
    end
  end
end