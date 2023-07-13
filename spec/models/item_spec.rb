require "rails_helper"

RSpec.describe Item do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:merchant_id) }
  end

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

    @customer1 = create(:customer)
    @invoice1 = create(:invoice, customer_id: @customer1.id, merchant_id: @merchant1.id)
    @invoice_item1 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice1.id)

    @invoice2 = create(:invoice, customer_id: @customer1.id, merchant_id: @merchant1.id)
    @invoice_item2 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice2.id)
    @invoice_item3 = create(:invoice_item, item_id: @item3.id, invoice_id: @invoice2.id)

    @invoice3 = create(:invoice, customer_id: @customer1.id, merchant_id: @merchant1.id)
    @invoice_item4 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice3.id)
  end

  describe "#class methods" do
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

  describe "#instance methods" do
    it "#delete_invoice" do
      expect(@item1.invoices.count).to eq(1)
      expect(@item1.invoices).to eq([@invoice1])
      expect(@invoice1.items.count).to eq(1)

      @item1.delete_invoice
      expect(@item1.invoices.count).to eq(0)
      expect{Invoice.find(@invoice1.id)}.to raise_error(ActiveRecord::RecordNotFound)

      @item3.delete_invoice
      expect(@item3.invoices).to eq([@invoice2])
      expect(@invoice2.items.count).to eq(2)
      expect{Invoice.find(@invoice2.id)}.to_not raise_error(ActiveRecord::RecordNotFound)

      expect(@item2.invoices).to eq([@invoice2, @invoice3])
      @item2.delete_invoice
      expect{Invoice.find(@invoice2.id)}.to_not raise_error(ActiveRecord::RecordNotFound)
      expect{Invoice.find(@invoice3.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end