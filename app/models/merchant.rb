class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.find_by_name(fragment)
    where("name ILIKE '%#{fragment}%'").order(:name)
  end

  def self.top_merchants_by_revenue(qty)
    joins(invoices: [:invoice_items, :transactions])
      .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
      .select(:name, :id, "SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .group(:id)
      .order(revenue: :desc)
      .limit(qty)
  end
end