class AddingFeaturesInChannelProductMapping < ActiveRecord::Migration
  def up
  	change_table "app.channel_product_mapping" do |t|
  		t.change :channel_sku, :string, limit: 50, null: false
  	end
  	add_index "app.channel_product_mapping", [:channel_id, :product_id, :channel_sku], unique: true, name: "channel_products_uniqueness" 
    add_index "app.channel_product_mapping", [:channel_id, :channel_sku], unique: true
  end
  def down
  	change_table "app.channel_product_mapping" do |t|
  		t.change :channel_sku, :string, limit: 50
  	end
  	# remove_index "app.channel_product_mapping", name: "channel_products_uniqueness" 
  end
end
