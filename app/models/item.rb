class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_all_by_name(fragment)
    where("name ILIKE '%#{fragment}%'")
  end
end