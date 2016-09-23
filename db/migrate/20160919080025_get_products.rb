class GetProducts < ActiveRecord::Migration
  def up
  	execute "
  		-- Function: app.get_products(integer, text, text, text, text, integer, integer)

			CREATE OR REPLACE FUNCTION app.get_products(
				group_id integer,
				product_id text,
				channel_id text,
				brand_id text,
				category_id text,
			  lmt integer DEFAULT 10,
			  offst integer DEFAULT 0
			 )
		  RETURNS SETOF json AS
			$BODY$
				DECLARE			
					search_query text:='';					
					select_query text;		

				BEGIN																
					IF (group_id IS NULL) THEN
						RETURN QUERY EXECUTE format ('
							SELECT json_build_object (''status'', 400, ''Message'', ''No Group ID specified.'')'
						);
					ELSE 
						search_query:= search_query || ' AND group_id = ' || group_id;

						IF (product_id IS NOT NULL) THEN
							search_query:= search_query || ' AND products.id in ' || product_id;
						END IF;

						IF (channel_id IS NOT NULL) THEN
							search_query:= search_query || ' AND cpm.channel_id in ' || channel_id;
						END IF;

						IF (brand_id IS NOT NULL) THEN
							search_query:= search_query || ' AND brand_id in ' || brand_id;
						END IF;

						IF (category_id IS NOT NULL) THEN
							search_query:= search_query || ' AND category_id in ' || category_id;
						END IF;

						select_query:= 'select array_to_json(array_agg(row_to_json(t))) from (
							WITH total AS (SELECT count(DISTINCT(gpm.id)) as total_count, 1 as pid FROM app.products						
								INNER JOIN app.brands ON brands.id = brand_id
								INNER JOIN app.categories ON categories.id = category_id
								INNER JOIN app.group_product_mapping gpm ON gpm.my_product_id = products.id
								INNER JOIN app.channel_product_mapping cpm ON cpm.product_id = gpm.my_product_id
								WHERE gpm.is_competitor = false AND cpm.id = ANY(gpm.valid_channel_products)
								%s),
							pdts AS (					
								SELECT 
								json_build_object(
									''id'', gpm.id,
									''product_id'', products.id,
									''productName'', products.name,
									''productCategory'', categories.name ,
									''productBrand'', brands.name,					
									''group_id'', gpm.group_id,
									''SKUId'', trim(sku_id),
									''imageUrl'', image_url,
									''mrp'', price,							
									''created_at'', products.creation_time
								) AS ps
								FROM app.products						
								INNER JOIN app.brands ON brands.id = brand_id
								INNER JOIN app.categories ON categories.id = category_id
								INNER JOIN app.group_product_mapping gpm ON gpm.my_product_id = products.id
								INNER JOIN app.channel_product_mapping cpm ON cpm.product_id = gpm.my_product_id
								WHERE gpm.is_competitor = false AND cpm.id = ANY(gpm.valid_channel_products)
								%s
								GROUP BY gpm.id, products.id, products.name, categories.name, brands.name, gpm.group_id, sku_id, image_url, price, products.creation_time
								ORDER BY products.updation_time DESC
								LIMIT ' || lmt || ' 
								OFFSET ' || offst || '),
							final_pdts AS (SELECT 1 AS pid, json_agg(ps) AS pdt_array FROM pdts)
							SELECT total_count, pdt_array FROM final_pdts INNER JOIN total ON total.pid = final_pdts.pid
						)t';

						RETURN QUERY EXECUTE format (select_query, search_query, search_query); 

					END IF;														
				END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION app.get_products(integer, text, text, text, text, integer, integer)
		  OWNER TO paxcom;
  	"
  end

  def down
  	execute "
  		DROP FUNCTION app.get_products(integer, text, text, text, text, integer, integer);
  	"
  end
end
