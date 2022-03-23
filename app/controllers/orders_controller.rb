class OrdersController < ApplicationController
  before_action :authorize_request
  before_action :check_if_customer, only: :create

  def index
    @orders = Order.all
    render json: @orders
  end

  def show
    @order = Order.find(params[:id])
    render json: @order
  end

  def create
    productIds = params[:product_ids]&.uniq
    if !productIds&.present?
      render json: { errors: "Product Ids are required" }
    end
    @order = Order.new(order_params)
    @order.user_id = @current_user.id
    @order.paid = false
    @products = Product.where(id: productIds).where("stock > ?", 0)
    if productIds.size != Product.where(id: productIds).where("stock > ?", 0).count
      return render json: { error: "Some Products are out of Stock" }
    end
    Product.update_counters(productIds, :stock => -1)
    order_total = @products.map { |product| product.price }.reduce(:+)
    @order.order_total = order_total
    @order.save

    productOrders = @products.map { |product| { order_id: @order.id, product_id: product.id, created_at: Time.now, updated_at: Time.now } }
    ProductOrder.create(productOrders)
    render json: { order: @order }, status: :ok
    PaymentJob.set(wait: 1.minute).perform_later(@order)
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :shipping_address)
  end
end
