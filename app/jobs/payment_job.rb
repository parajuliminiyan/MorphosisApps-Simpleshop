class PaymentJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # paymentGateway API here
    order = args[0]
    logger.debug "Payment for order #{order.id} total_amount: #{order.order_total}"
    order.paid = true
    order.paid_at = Time.now
    order.save

  end
end
