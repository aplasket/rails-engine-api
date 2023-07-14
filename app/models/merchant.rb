class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  validates_presence_of :name

  def self.find_by_name(fragment)
    where("name ILIKE '%#{fragment}%'").order(:name)
  end
end