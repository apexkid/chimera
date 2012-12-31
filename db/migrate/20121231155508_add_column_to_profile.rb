class AddColumnToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :gender, :string
    add_column :profiles, :occupation, :string
    add_column :profiles, :state, :string
    add_column :profiles, :country, :string
    add_column :profiles, :zip_code, :integer
  end
end
