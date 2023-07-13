class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all(params)

    if items
      render json: ItemSerializer.new(items)
    else
      render json: { errors: 'Bad Request' }, status: 400
    end
  end
end