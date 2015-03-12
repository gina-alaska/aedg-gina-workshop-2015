class CreatePces < ActiveRecord::Migration
  def change
    create_table :pces do |t|
      t.integer :gnis_feature_id
      t.string :community_name
      t.float :latitude
      t.float :longitude
      t.string :plant_name
      t.integer :year
      t.integer :month
      t.string :season
      t.float :fuel_used_gal
      t.integer :residential_kwh_sold
      t.integer :commercial_kwh_sold
      t.integer :community_kwh_sold
      t.integer :government_kwh_sold
      t.date :date

      t.timestamps null: false
    end
  end
end
