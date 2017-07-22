class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :nick_name
      t.string :profile_picture
      t.string :instagram_uid
      t.string :instagram_token

      t.timestamps null: false
    end
  end
end
