class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayService.new.holiday
    
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def create
    if BulkDiscount.new(bulk_discount_params)
      new_discount = BulkDiscount.create(bulk_discount_params)
      new_discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    else
      flash[:notice] = "Bulk Discount needs to have all information"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    discount.update(bulk_discount_params)
    redirect_to merchant_bulk_discount_path(params[:merchant_id], params[:id])
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  private
  def bulk_discount_params
    params.permit(:tag, :quantity_threshold, :percentage_discount, :merchant_id)
  end
end