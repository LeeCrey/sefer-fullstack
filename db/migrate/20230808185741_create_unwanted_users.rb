class CreateUnwantedUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :unwanted_users do |t|
      t.boolean :blocked, null: false, default: false
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :unwanted_user_id

      # t.timestamps
    end

    add_index :unwanted_users, :blocked
    add_index :unwanted_users, %i[user_id unwanted_user_id], unique: true
  end
end
