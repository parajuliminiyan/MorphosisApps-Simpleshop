class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :img_url
      t.money :price
      t.string :sku, unique:true
      t.integer :stock
      t.references :regions, foreign_key: true, null: false

      t.timestamps
    end
  end
end
