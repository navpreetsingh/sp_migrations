class ChannelProduct < ActiveRecord::Base
	self.table_name = "channel_product_mapping"
	belongs_to :channel
	belongs_to :product
end
