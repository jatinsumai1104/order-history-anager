class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: true
      t.integer :category, null: true
      t.boolean :deleted, default: false
      t.timestamps
    end

    add_index(:products, :code, where: 'NOT deleted', unique: true)
  end
end
