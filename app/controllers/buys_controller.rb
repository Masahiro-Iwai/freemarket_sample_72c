class BuysController < ApplicationController

  before_action :set_item
  before_action :set_card

  require 'payjp'

  def new
  end

  def create
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    charge = Payjp::Charge.create(
    amount: @item.price,
    customer: @card.customer_id,
    currency: 'jpy'
    )
    if @item.save
      @item.update(state: 2)
      @item.update(buyer: current_user.id)
      redirect_to action: 'done'
    else
      flash[:alert] = '購入に失敗しました。'
      redirect_to action: "new"
    end
  end

  def done
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_card
    @card = Card.where(user_id: current_user.id).first if Card.where(user_id: current_user.id).present?
  end

end
