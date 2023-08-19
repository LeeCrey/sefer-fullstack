class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :country
      t.integer :martial_status
      t.datetime :last_seen_at
      t.string :biography
      t.integer :gender, null: false
      t.boolean :verified, null: false, default: false

      t.timestamps
    end
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :gender
  end
end
