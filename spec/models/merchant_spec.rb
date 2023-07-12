require "rails_helper"

RSpec.describe Merchant do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe "#class methods" do
    it ".find_by_name" do
      merchant1 = create(:merchant, name: "Ring World")
      merchant2 = create(:merchant, name: "Turing")

      expect(Merchant.find_by_name("ring")).to eq([merchant1, merchant2])
    end
  end
end