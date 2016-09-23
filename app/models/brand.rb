class Brand < ActiveRecord::Base
	has_and_belongs_to_many :groups, :join_table => "group_brand_mapping"
	has_many :products
end
