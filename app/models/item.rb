class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_all(params)
    if params[:name] && (params[:min_price] || params[:max_price])
      "error - name cannot be searched with price queries"
    elsif params[:min_price] || params[:max_price]
      Item.find_by_price(params)
    elsif !params[:name].empty?
      Item.find_all_by_name(params[:name])
    else
      "error - query is invalid, parameter cannot be empty"
    end
  end

  def self.find_all_by_name(fragment)
    where("name ILIKE '%#{fragment}%'")
  end

  def self.find_by_price(params)
    @min_price = params[:min_price].present? ? params[:min_price] : 0
    @max_price = params[:max_price].present? ? params[:max_price] : 999_999

    Item.where("unit_price >= #{@min_price} AND unit_price <= #{@max_price}")
  end
end