class CreateJwtDenyLists < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_deny_lists do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false

      t.timestamps
    end

    add_index :jwt_deny_lists, :jti, unique: true
    add_index :jwt_deny_lists, %i[jti exp]
  end
end
