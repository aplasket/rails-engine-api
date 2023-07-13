class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all(params)
  
    if items[0].class == Item
      render json: ItemSerializer.new(items)
    else
      render json: { error: 'Bad Request' }, status: 404
    end
  end
end