class Channel < ActiveRecord::Base
	has_and_belongs_to_many :groups, :join_table => "group_channel_mapping"
	has_many :channel_products
end
