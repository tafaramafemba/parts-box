class TransactionsController < ApplicationController

  def new
    @product = Product.find(params[:product_id])
    @transaction = @product.transactions.new
  end
  
  def create
    @product = Product.find(params[:transaction][:product_id])
    @transaction = @product.transactions.new(transaction_params)
    @transaction.buyer = current_user
    cash_top_up = params[:cash_top_up].to_d || 0
    platform_fee = calculate_platform_fee(cash_top_up)
    @transaction.platform_fee = platform_fee

    if @transaction.save
      redirect_to @product, notice: 'Transaction was successfully created.'
    else
      render :new
    end
  end

  private

  def calculate_platform_fee(cash_top_up)
    (cash_top_up * 0.05).round(2) # 5% fee
  end
end
