class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :items

  def self.find_by_name(fragment)
    where("name ILIKE '%#{fragment}%'").order(:name)
  end
end