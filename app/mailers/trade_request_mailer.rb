# app/mailers/trade_request_mailer.rb
class TradeRequestMailer < ApplicationMailer
  def new_request(recipient, sender, trade)
    @recipient = recipient
    @sender = sender
    @trade = trade 

    mail(to: @recipient.email, subject: "You Have a New Trade Request on Cart To Car")
  end
end