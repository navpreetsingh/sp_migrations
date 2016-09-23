class EsSkuIdAssociation < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.es_sku_id_associtation(
		    lmt integer DEFAULT (5000),
		    offst integer DEFAULT (0), 
		    sku_id text DEFAULT 'all'::text,
		    grp_id integer DEFAULT (-1)
		  )
			RETURNS SETOF json AS
			$BODY$
			DECLARE
				condition_query text:='';
				sql_query text:='';

			BEGIN
				IF (sku_id is not null) and (sku_id <> 'all') THEN 
					condition_query:= condition_query || ' AND channel_sku in ' || sku_id;
				END IF;

				IF (grp_id is not null) and (grp_id <> '-1') THEN
					condition_query:= condition_query || ' AND group_id = ' || grp_id ; 
				END IF;

				sql_query:= sql_query || 'SELECT array_to_json(array_agg(row_to_json(t))) FROM (
					WITH associations AS (SELECT channels.name as channel_name, trim(channel_sku) as channel_sku, channel_id, 
						group_product_mapping.group_id AS group_id, 
						json_build_object(
						''id'',products.id,
						''name'',products.name,
						''self_name'', self.name,
						''brand'', brands.name,
						''category'',categories.name, 
						''is_competitor'', is_competitor,
						''group_id'', group_product_mapping.group_id
						) AS sku_association 
						FROM app.channel_product_mapping	
						INNER JOIN 
						app.channels ON channels.id = channel_id			
						INNER JOIN
						app.products on products.id = product_id
						INNER JOIN
						app.group_product_mapping on competitor_product_id = product_id
						INNER JOIN app.products self ON self.id = group_product_mapping.my_product_id
						INNER JOIN
						app.brands ON brands.id = products.brand_id
						INNER JOIN
						app.categories ON categories.id = products.category_id
						WHERE channel_product_mapping.id = ANY(valid_channel_products) %s)
						SELECT channel_name, channel_sku, channel_id, json_agg(group_id) as group_ids , json_agg(sku_association) as sku_association
						FROM associations 
						GROUP BY channel_id, channel_name, channel_sku 
						LIMIT ' || lmt || '
						OFFSET ' || offst ||'
					)t';						

	     RETURN QUERY EXECUTE format (sql_query, condition_query);  
				
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION app.es_sku_id_associtation(integer, integer, text, integer)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.es_sku_id_associtation(integer, integer, text, integer);
  	" 	
  end
end
