class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_all(params)
    if params[:name] && params[:min_price].nil? && params[:max_price].nil?
      Item.find_all_by_name(params)
    elsif params[:name].nil? && (params[:min_price].to_f.positive? || params[:max_price].to_f.positive?)
      Item.find_by_price(params)
    else
      false
    end
  end

  def self.find_all_by_name(params)
    return false if params[:name].nil?
    return false if params[:name].empty?

    Item.where("name ILIKE '%#{params[:name]}%'")
  end

  def self.find_by_price(params)
    @min_price = params[:min_price].present? ? params[:min_price] : 0
    @max_price = params[:max_price].present? ? params[:max_price] : 999_999

    Item.where("unit_price >= #{@min_price} AND unit_price <= #{@max_price}")
  end
end