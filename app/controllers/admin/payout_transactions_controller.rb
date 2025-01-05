class Admin::PayoutTransactionsController < Admin::BaseController
    def index
      @payout_transactions = PayoutTransaction.all.order(created_at: :desc)
    end
  end