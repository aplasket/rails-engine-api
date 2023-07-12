class Api::V1::MerchantsController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    # binding.pry
    render json: MerchantSerializer.new(Merchant.find(params[:id]))

    # @merchant = Merchant.find(params[:id])
    # if @merchant.class == Merchant
    #   render json: MerchantSerializer.new(Merchant.find(params[:id]))
    # else
    #   render json: ErrorSerializer.new(@merchant).serialized_json
    # end
  end
end