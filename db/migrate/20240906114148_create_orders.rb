class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :user_id, null: false
      t.uuid :product_id, null: false
      t.timestamp :order_date, null: false
      t.boolean :deleted, default: false
      t.timestamps
    end

    add_foreign_key :orders, :users, column: :user_id
    add_foreign_key :orders, :products, column: :product_id
  end
end
