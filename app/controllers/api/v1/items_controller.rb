class Api::V1::ItemsController < ApplicationController
  before_action :find_item, only: [:show, :update, :destroy]

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def update
    @item.update!(item_params)
    render json: ItemSerializer.new(@item)
  end

  def destroy
    @item.delete_invoice
    @item.destroy
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def find_item
    @item = Item.find(params[:id])
  end
end