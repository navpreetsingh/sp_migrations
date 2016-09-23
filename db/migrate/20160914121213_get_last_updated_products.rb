class GetLastUpdatedProducts < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.get_last_updated_products(
				crawler_id integer				
		  )
			RETURNS SETOF json AS
			$BODY$
			DECLARE				
			BEGIN	

				RETURN QUERY
	     		SELECT array_to_json(array_agg((t))) from (
		      	SELECT json_agg(DISTINCT(products.id)) as ids, json_agg(DISTINCT(trim(channel_product_mapping.channel_sku))) as channel_skus FROM app.products
							INNER JOIN crawled_data.crawled_products ON crawled_products.product_id = products.id
							INNER JOIN app.channel_product_mapping ON products.id = channel_product_mapping.product_id
						WHERE crawler_log_id = $1 AND
						products.updation_time >= crawled_products.creation_time
			  )t;
				
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION app.get_last_updated_products(integer)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.get_last_updated_products(integer)
  	" 	
  end
end
