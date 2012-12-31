class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.timestamp :dob
      t.string :city
      t.string :mobile

      t.timestamps 
    end
  end
end
