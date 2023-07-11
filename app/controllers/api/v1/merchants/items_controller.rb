class Api::V1::Merchants::ItemsController < ApplicationController
  before_action :find_merchant, only: [:index]

  def index
    # merchant = Merchant.find(params[:merchant_id])
    # merchant_items = merchant.items
    merchant_items = @merchant.items
    render json: ItemSerializer.new(merchant_items)
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id].to_i)
    # if @merchant.nil?
    #   message = "No Merchant with merchant_id=#{params[:merchant_id].to_i}) exists"
    #   raise ActiveRecord::RecordNotFound, message
    # end
  end
end