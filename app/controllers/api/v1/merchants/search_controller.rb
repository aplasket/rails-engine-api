class Api::V1::Merchants::SearchController < ApplicationController
  def index
    # if !params[:name] || params[:name].empty?
    #   render json: { error: 'Bad Request' }, status: 404
    # elsif Merchant.find_by_name(params[:name]) == []
    if Merchant.find_by_name(params[:name]) == []
      render json: { data: [] }, status: 200
    elsif params[:name]
      render json: MerchantSerializer.new(Merchant.find_by_name(params[:name]).first)
    end
  end
end