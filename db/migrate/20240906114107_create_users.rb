class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :phone, null: false
      t.boolean :deleted, default: false
      t.timestamps
    end

    add_index(:users, :email, where: 'NOT deleted', unique: true)
  end
end
