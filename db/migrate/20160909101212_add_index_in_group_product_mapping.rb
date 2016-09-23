class AddIndexInGroupProductMapping < ActiveRecord::Migration
  def up
  	add_index "app.group_product_mapping", [:group_id, :my_product_id, :competitor_product_id], unique: true, name: "group_products_relationship"
  	add_index "app.channel_product_mapping", [:channel_id, :channel_sku], unique: true
  	# add_index "app.products", [:name, :brand], unique: true
  	# add_index "app.channel_product_mapping", [:channel_id, :product_id, :channel_sku], unique: true  
  end

  def down 
  	# remove_index "app.group_product_mapping", name: "group_products_relationship"
  	# remove_index "app.channel_product_mapping", [:channel_id, :channel_sku], unique: true
  end
end
