class AddingFeaturesInProducts < ActiveRecord::Migration
  def up
  	add_index "app.products", [:brand_id, :name], unique: true
  end
end
