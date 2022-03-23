class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :shipping_address
      t.decimal :order_total
      t.timestamp :paid_at
      t.references :user, foreign_key: true , null:false

      t.timestamps
    end
  end
end
