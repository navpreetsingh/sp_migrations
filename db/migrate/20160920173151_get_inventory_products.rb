class GetInventoryProducts < ActiveRecord::Migration
  def up
  	execute "
  		-- Function: crawled_data.get_inventory_products(integer, date, text, text, text, text, text, text, boolean, integer, integer)

			CREATE OR REPLACE FUNCTION crawled_data.get_inventory_products(
				group_id integer,
				crawl_date date,
				product_id text,
				channel_id text,
				brand_id text,
				category_id text,
				city text,
				status text,
				delisted boolean DEFAULT false,
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

						IF(crawl_date IS NULL) THEN
							search_query:=  search_query || ' AND is_active = true  AND cp.crawl_date = ''' || DATE(crawled_data.get_last_updated_date('crawled_data.crawled_products')) || '''';
						ELSE
							search_query:=  search_query || ' AND is_active = true AND cp.crawl_date = ''' || DATE(crawl_date) || '''';
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

						IF (city IS NOT NULL) THEN
							search_query:= search_query || ' AND city in ' || city;
						END IF;

						IF (status IS NOT NULL) THEN
							IF(delisted) THEN
								search_query:= search_query || ' AND status = ''DELISTED''';
							ELSE
								search_query:= search_query || ' AND status in ' || status;
							END IF;							
						ELSE
							IF(delisted) THEN
								search_query:= search_query || ' AND status = ''DELISTED''';
							ELSE
								search_query:= search_query || ' AND status != ''DELISTED''';
							END IF;
						END IF;

						IF (product_id IS NOT NULL) THEN
							search_query:= search_query || ' AND products.id in ' || product_id;
						END IF;						

						select_query:= 'select array_to_json(array_agg(row_to_json(t))) from (
							WITH total AS (SELECT count(DISTINCT(cp.id)) as total_count, 1 as pid FROM app.products						
								INNER JOIN app.brands ON brands.id = brand_id
								INNER JOIN app.categories ON categories.id = category_id
								INNER JOIN app.group_product_mapping gpm ON gpm.my_product_id = products.id
								INNER JOIN app.channel_product_mapping cpm ON cpm.product_id = gpm.my_product_id
								INNER JOIN crawled_data.crawled_products cp ON cp.product_id = cpm.product_id AND cp.channel_sku = cpm.channel_sku AND cp.channel_id = cpm.channel_id 
								WHERE gpm.is_competitor = false AND cpm.id = ANY(gpm.valid_channel_products)
								%s),
							pdts AS (					
								SELECT 
								json_build_object(
									''id'', cp.id,
									''product_mrp'', products.price,
									''selling_price'', CAST ((CASE WHEN cp.selling_price <> ''0'' THEN
										cp.selling_price ELSE cp.mrp END) as double precision),                     
									''brand'', brands.name,
									''product_id'', cp.product_id,							
									''name'', products.name,
									''stock_info'', trim(cp.status),
									''image'', products.image_url,
									''url'', product_ext_json ->> ''productUrl'',
									''city'', cp.city,
									''area'', cp.area,
									''crawl_date'', cp.crawl_date,
									''category'', categories.name,
									''breadCrumbs'', product_ext_json ->> ''breadCrumb'',
									''sku_id'', trim(cp.channel_sku),
									''channel_id'', cp.channel_id,
									''channel_name'', trim(lower(channels.name)),
									''created_at'', cp.creation_time
								) AS ps
								FROM app.products						
								INNER JOIN app.brands ON brands.id = brand_id
								INNER JOIN app.categories ON categories.id = category_id
								INNER JOIN app.group_product_mapping gpm ON gpm.my_product_id = products.id
								INNER JOIN app.channel_product_mapping cpm ON cpm.product_id = gpm.my_product_id
								INNER JOIN crawled_data.crawled_products cp ON cp.product_id = cpm.product_id AND cp.channel_sku = cpm.channel_sku AND cp.channel_id = cpm.channel_id
								INNER JOIN app.channels ON channels.id = cp.channel_id
								WHERE gpm.is_competitor = false AND cpm.id = ANY(gpm.valid_channel_products)
								%s
								GROUP BY cp.id, products.price, cp.mrp, cp.selling_price, brands.name, cp.product_id, products.name, cp.status, products.image_url, product_ext_json ->> ''productUrl'', cp.city, cp.area, cp.crawl_date, categories.name, product_ext_json ->> ''breadCrumb'', cp.channel_sku, cp.channel_id, channels.name, cp.creation_time
								ORDER BY cp.status DESC, cp.creation_time DESC
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
			ALTER FUNCTION crawled_data.get_inventory_products(integer, date, text, text, text, text, text, text, boolean, integer, integer)
		  OWNER TO paxcom;
  	"
  end

  def down
  	execute "
  		DROP FUNCTION crawled_data.get_inventory_products(integer, date, text, text, text, text, text, text, boolean, integer, integer);
  	"
  end
end
