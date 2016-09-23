class AddingFeaturesInGroupProductMapping < ActiveRecord::Migration
  def up
  	change_table "app.group_product_mapping" do |t|
  		t.change :is_competitor, :boolean, null: false, default: false
  		t.change :competitor_product_id, :bigint, null: false
  	end
  	add_index "app.group_product_mapping", [:group_id, :my_product_id, :competitor_product_id], unique: true, name: "group_products_uniqueness" 
  end

  def down
  	change_table "app.group_product_mapping" do |t|
  		t.change :is_competitor, :boolean
  		t.change :competitor_product_id, :bigint
  	end  
  	# remove_index "app.group_product_mapping", name: "group_products_uniqueness"	
  end
end
