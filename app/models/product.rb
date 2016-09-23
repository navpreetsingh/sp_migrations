class Product < ActiveRecord::Base
  belongs_to :brand
  belongs_to :category
  has_many :channel_products
  has_many :group_products
end
