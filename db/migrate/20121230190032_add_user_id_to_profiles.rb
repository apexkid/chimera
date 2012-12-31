class AddUserIdToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :add_column, :string
    add_column :profiles, :user_id, :integer
  end
end
