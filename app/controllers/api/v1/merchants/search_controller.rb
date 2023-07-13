class Api::V1::Merchants::SearchController < ApplicationController
  def index
    if Merchant.find_by_name(params[:name]) == []
      render json: { data: [] }, status: 200
    elsif params[:name]
      render json: MerchantSerializer.new(Merchant.find_by_name(params[:name]).first)
    end
  end
end