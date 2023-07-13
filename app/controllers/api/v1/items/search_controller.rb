class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.find_all(params)
    render json: ItemSerializer.new(items)
  end
end