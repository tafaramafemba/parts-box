class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    @review.user = User.find(params[:user_id]) # Associate review with seller

    if @review.save
      redirect_back fallback_location: product_path(params[:product_id]), notice: "Review added successfully."
    else
      redirect_back fallback_location: product_path(params[:product_id]), alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
