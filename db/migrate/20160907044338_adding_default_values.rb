class AddingDefaultValues < ActiveRecord::Migration
  def up
  	execute"
      ALTER TABLE app.products
        ALTER COLUMN sku_id
          SET DEFAULT EXTRACT(EPOCH FROM now()) * 100000,
        ALTER COLUMN creation_time
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN updation_time
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN brand_id
          SET DEFAULT -1,
        ALTER COLUMN category_id
          SET DEFAULT -1,
        ALTER COLUMN price
          SET DEFAULT 0.0,
        ALTER COLUMN selling_price
          SET DEFAULT 0.0,
        ALTER COLUMN created_by
          SET DEFAULT -1,
        ALTER COLUMN updated_by
          SET DEFAULT -1,
        ALTER COLUMN is_complete
          SET DEFAULT false;

      ALTER TABLE app.sellers
        ALTER COLUMN created_by
          SET DEFAULT -1,
        ALTER COLUMN creation_time
          SET DEFAULT CURRENT_TIMESTAMP;

      ALTER TABLE app.users
        ALTER COLUMN status_id
          SET DEFAULT 2,
        ALTER COLUMN creation_time
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN updation_time
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN updated_by
          SET DEFAULT -1;

      ALTER TABLE app.product_price_limit        
        ALTER COLUMN creation_time
          SET DEFAULT CURRENT_TIMESTAMP,        
        ALTER COLUMN created_by
          SET DEFAULT -1;    

      DROP TABLE app.last_craw_prod;

      ALTER TABLE app.groups
        ALTER COLUMN start_date
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN end_date
          SET DEFAULT (CURRENT_TIMESTAMP + '30 days'::interval);

      ALTER TABLE app.channels        
        ALTER COLUMN active
          SET DEFAULT true,        
        ALTER COLUMN has_multiple_sku
          SET DEFAULT false; 

      ALTER TABLE app.channel_seller_mapping        
        ALTER COLUMN updation_time
          SET DEFAULT CURRENT_TIMESTAMP,        
        ALTER COLUMN updated_by
          SET DEFAULT -1;       
        
      ALTER TABLE app.channel_product_mapping        
        ALTER COLUMN status_id
          SET DEFAULT 4,        
        ALTER COLUMN created_by
          SET DEFAULT -1,
        ALTER COLUMN creation_time
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN updation_time
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN updated_by
          SET DEFAULT -1;

      ALTER TABLE crawled_data.crawled_products
        ALTER COLUMN mrp
          SET DEFAULT 0.0,        
        ALTER COLUMN selling_price
          SET DEFAULT 0.0,
        ALTER COLUMN creation_time
          SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN crawl_date
          SET DEFAULT CURRENT_TIMESTAMP;

      ALTER TABLE crawled_data.crawled_product_sellers
        ALTER COLUMN price
          SET DEFAULT 0.0,        
        ALTER COLUMN shipping_price
          SET DEFAULT 0.0,
        ALTER COLUMN crawl_date
          SET DEFAULT CURRENT_TIMESTAMP;
    "
  end

  def down
  	execute "
  		CREATE TABLE app.last_craw_prod(name text);
  	"
  end
end
