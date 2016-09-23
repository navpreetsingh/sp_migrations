class ReplaceColumnValidChannelsInGroupProductMapping < ActiveRecord::Migration
  def change
  	# rename_column :group_product_mapping, :valid_channels, :valid_channel_products
  	remove_column :group_product_mapping, :valid_channels, :jsonb
  	add_column :group_product_mapping, :valid_channel_products, :integer, array: true, default: []
  	add_column :group_product_mapping, :custom_sku, :string
  end
end
