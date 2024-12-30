class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    @review.user = User.find(params[:user_id]) # Associate review with seller
    @

    if @review.save
      redirect_to products_path
    else
      redirect_to products_path alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
