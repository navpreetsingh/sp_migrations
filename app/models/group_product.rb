class GroupProduct < ActiveRecord::Base
	self.table_name = "group_product_mapping"
  belongs_to :group
  belongs_to :product
  belongs_to :competitor
end
