class ChangeAndAddColumns < ActiveRecord::Migration
  def change
  	remove_column "crawled_data.crawled_products", :creation_time, :time
  	add_column "crawled_data.crawled_products", :creation_time, :timestamp
  	add_column "crawled_data.crawled_products", :is_active, :boolean
  end
end
