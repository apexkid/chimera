class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :status
      t.string :type

      t.datetime :created_at
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
