class GetCrawlerProductsForEs < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION crawled_data.get_crawled_products_for_es(
				start_date date ,
				log_id integer DEFAULT(-1),				
		    lmt integer DEFAULT 5000,
		    offst integer DEFAULT 0, 		    
		    channel_sku text DEFAULT 'all'::text,
		    group_id integer DEFAULT(-1)
		  )
			RETURNS SETOF json AS
			$BODY$
			DECLARE
				join_query text:='';
				search_query text:='';
				select_query text;
				mydate date;

			BEGIN	
				select_query:= 'select array_to_json(array_agg((t))) from (			
					WITH crawled_products AS (select json_build_object(
						''id'', crawled_products.id,
						''product_mrp'', mrp,
						''selling_price'', CAST ((CASE WHEN crawled_products.selling_price <> ''0'' THEN
							crawled_products.selling_price ELSE crawled_products.mrp END) as double precision),                     
						''brand'', brands.name,
						''product_id'', crawled_products.product_id,							
						''name'', products.name,
						''stock_info'', trim(status),
						''image'', products.image_url,
						''url'', product_ext_json ->> ''productUrl'',
						''city'', city,
						''area'', area,
						''crawl_date'', crawl_date,
						''category'', categories.name,
						''breadCrumbs'', product_ext_json ->> ''breadCrumb'',
						''sku_id'', trim(crawled_products.channel_sku),
						''channel_id'', crawled_products.channel_id,
						''channel_name'', trim(lower(channels.name)),
						''created_at'', crawled_products.creation_time,
						''search_tags'', concat(trim(lower(channels.name)), '' '', products.name, '' '' , 
						city, '' '', 
						brands.name, '' '', 
						categories.name, '' '',
						trim(crawled_products.channel_sku))
					) as cp
					FROM crawled_data.crawled_products 
					INNER JOIN app.products ON products.id = crawled_products.product_id 
					INNER JOIN app.channels ON channels.id = channel_id					
					INNER JOIN app.brands ON brands.id = brand_id
					INNER JOIN app.categories ON categories.id = category_id
					%s
					WHERE is_active = true 
					%s					
					ORDER BY crawl_date DESC
					LIMIT ' || lmt || ' 
					OFFSET ' || offst || ')
					select json_agg(cp) as crawled_products from crawled_products
				)t';

				IF(log_id is not null) and (log_id <> '-1') THEN
					search_query:= search_query || ' AND crawler_log_id = ' || log_id;
				ELSE
					IF (start_date is not null) THEN
						search_query:= search_query || ' AND crawled_products.crawl_date = ''' || DATE(start_date) || ''' ';
						
						IF (channel_sku is not null) and (channel_sku <> 'all') THEN
							search_query:= search_query || ' AND crawled_products.channel_sku in ' || channel_sku || ' ';
						END IF;
						
						IF (group_id is not null) and (group_id <> '-1') THEN
							join_query:= join_query || ' INNER JOIN app.group_product_mapping ON my_product_id = products.id';
							search_query:= search_query || ' AND group_product_mapping.group_id = ''' || group_id || ''' ';
						END IF;
					ELSE
						mydate = DATE(crawled_data.get_last_updated_date('crawled_data.crawled_products')) - 2;
						search_query:= search_query || ' AND crawled_products.crawl_date >= ''' || DATE(mydate) || ''' ';
					END IF;
				END IF;

				RAISE NOTICE '%', format(select_query, join_query, search_query);  
				
				RETURN QUERY EXECUTE format(select_query, join_query, search_query);  
				
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION crawled_data.get_crawled_products_for_es(date, integer, integer, integer, text, integer)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION crawled_data.get_crawled_products_for_es(date, integer, integer, integer, text, integer);
  	" 	
  end
end
