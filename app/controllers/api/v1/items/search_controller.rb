class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name]
      render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
    # elsif params[:min_price] || params[:max_price]
    #   binding.pry
    #   render json: ItemSerializer.new(Item.find_by_price(params))
    end
  end
end