class CancelOrdersJob < ApplicationJob
  queue_as :default

  def perform
    Order.where('created_at <= ?', 48.hours.ago).each do |order|
      OrdersController.new.cancel(order.id)
    end
  end
end