# frozen_string_literal: true

class ShopsController < ApplicationController
  before_action :require_signed_in, only: %i[new create edit update]

  def index; end

  def new
    @shop = Shop.new
    @shop.build_shop_address
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      flash[:notice] = 'ショップが登録されました'
      redirect_to root_path
    else
      flash.now[:alert] = '登録エラーです'
      render :new
    end
  end

  def edit
    @shop = Shop.find(params[:id])
    redirect_to root_path unless @shop.user == current_user
  end

  def update
    @shop = Shop.find(params[:id])
    if @shop.update(shop_params)
      flash[:notice] = 'ショップ情報が更新されました'
      redirect_to edit_shop_path(@shop)
    else
      flash.now[:alert] = '更新エラーです'
      render :edit
    end
  end

  def show; end

  private

  def require_signed_in
    unless user_signed_in?
      flash[:alert] = 'サインインが必要です'
      redirect_to root_path
    end
  end

  def shop_params
    params.require(:shop).permit(
      :name,
      :description,
      :website_url, 
      :email, 
      :phone_number,
      shop_address_attributes: [
        :id,
        :name,
        :zipcode,
        :prefecture_id,
        :city,
        :block,
        :building,
        :note
      ]
    ).merge(user_id: current_user.id)
  end
end
