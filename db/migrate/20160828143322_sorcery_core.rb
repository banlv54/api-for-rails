class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.string :salt

      t.integer :phone_number
      t.string :device_id
      t.string :avatar

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :device_id, unique: true
  end
end
