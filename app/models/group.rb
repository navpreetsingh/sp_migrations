class Group < ActiveRecord::Base
	has_and_belongs_to_many :channels, :join_table => "group_channel_mapping"
	has_and_belongs_to_many :brands, :join_table => "group_brand_mapping"
	has_many :users, dependent: :destroy
	has_many :group_products
end
