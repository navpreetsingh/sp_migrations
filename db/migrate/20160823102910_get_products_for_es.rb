class GetProductsForEs < ActiveRecord::Migration
  def up
  	execute "
  		-- Function: app.get_products_for_es(integer, integer, integer, text, integer)

			CREATE OR REPLACE FUNCTION app.get_products_for_es(
			    lmt integer DEFAULT 5000,
			    offst integer DEFAULT 0,
			    pid text DEFAULT 'all'::text,
			    sku_id text DEFAULT 'all'::text,
			    group_id integer DEFAULT '-1'::integer)
			  RETURNS SETOF json AS
			$BODY$
						DECLARE				
							search_query text:='';
							mapping_search_query text:='';
							select_query text;		

						BEGIN																
							IF (group_id is not null) and (group_id <> '-1') THEN
								mapping_search_query:= mapping_search_query || ' AND group_product_mapping.group_id = ' || group_id ;
							END IF;

							IF (sku_id is not null) and (sku_id <> 'all') THEN
								mapping_search_query:= mapping_search_query || ' AND channel_product_mapping.channel_sku in ' || sku_id ;
							END IF;
							
							
							IF (pid is not null) and (pid <> 'all') THEN
								search_query:= search_query || ' WHERE products.id IN ' || pid ;
							END IF;

							

							select_query:= 'select array_to_json(array_agg(row_to_json(t))) from (
									WITH mappings AS (SELECT group_product_mapping.id as gid, group_product_mapping.group_id AS group_id, product_id, json_build_object(channels.name, 
										json_agg(DISTINCT(trim(channel_sku)))) AS map,
										channels.name as channel_name,
										json_agg(DISTINCT(trim(channel_sku))) AS channel_skus
										FROM app.channel_product_mapping 
										INNER JOIN app.group_product_mapping 
										ON group_product_mapping.my_product_id = channel_product_mapping.product_id 
										INNER JOIN app.group_channel_mapping ON group_channel_mapping.group_id = group_product_mapping.group_id
										INNER JOIN app.channels ON channels.id = channel_product_mapping.channel_id
										WHERE group_product_mapping.is_competitor = false 
										%s
										GROUP BY channels.name, product_id, group_product_mapping.group_id, group_product_mapping.id), 
									assoc as (SELECT gid, group_id, product_id, json_agg(mappings.map) as crawler_assoc, 
										json_agg(channel_name) as channel_names, json_agg(channel_skus) as channel_skus from mappings 
										group by gid, group_id, product_id),
									product_details as(
									SELECT 
									json_build_object(
										''id'', assoc.gid,
										''product_id'', products.id,
										''productName'', products.name,
										''productCategory'', CAST(
											(CASE WHEN 
												(categories.name) is not null
											THEN
												categories.name
											ELSE
											 ''N.A.'' 
											END) as text) ,
										''productBrand'', CAST(
											(CASE WHEN 
												(brands.name) is not null
												THEN
													brands.name
												ELSE
													''N.A.''
												END) as text),
										''brand_id'', brand_id,
										''category_id'', category_id,					
										''group_id'', assoc.group_id,
										''SKUId'', trim(sku_id),
										''imageUrl'', image_url,
										''mrp'', price,
										''crawler_association'', assoc.crawler_assoc,
										''crawler_pids'', assoc.channel_skus,
										''channel_names'', assoc.channel_names,
										''created_at'', products.creation_time
									) AS ps
									FROM app.products 
									INNER JOIN assoc ON assoc.product_id = products.id
									INNER JOIN app.brands ON brands.id = brand_id
									INNER JOIN app.categories ON categories.id = category_id
									%s
									ORDER BY products.updation_time DESC
									 LIMIT ' || lmt || ' 
									 OFFSET ' || offst || '
									)	

								SELECT json_agg(ps) as products FROM product_details 
							)t';
						 RETURN QUERY EXECUTE format (select_query, mapping_search_query, search_query);  
							
						END;
						$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION app.get_products_for_es(integer, integer, text, text, integer)
			  OWNER TO paxcom;
  	"
  end

  def down
  	execute "
  		DROP FUNCTION app.get_products_for_es(integer, integer, text, text, integer);
  	"
  end
end
