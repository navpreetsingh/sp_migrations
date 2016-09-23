class GetChannelProducts < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.get_channel_products(
				group_id integer,
				product_id integer,
				competitor boolean
			)
			RETURNS SETOF json AS
			$BODY$
			DECLARE
				select_query text:='';				
			BEGIN
				IF(competitor)
				THEN
					select_query:= select_query || 'SELECT array_to_json(array_agg(row_to_json(t))) from (						
						WITH mappings as (SELECT group_product_mapping.id AS id, valid_channels AS valid_channels, 
							json_build_object(channel_id, json_agg(DISTINCT(trim(channel_product_mapping.channel_sku)))) AS all_mapping
							FROM app.group_product_mapping 
							INNER JOIN app.channel_product_mapping ON channel_product_mapping.product_id = group_product_mapping.competitor_product_id
							WHERE group_id = ' || group_id || ' AND my_product_id = ' || product_id || ' AND is_competitor = true
							GROUP BY group_product_mapping.id, channel_id)
						SELECT id, valid_channels, json_agg(all_mapping) AS map FROM mappings GROUP BY id, valid_channels
					)t';
				ELSIF (competitor is null) THEN
					select_query:= select_query || 'SELECT array_to_json(array_agg(row_to_json(t))) from (						
						SELECT group_product_mapping.id AS id, channel_product_mapping.id as cid, my_product_id, channel_product_mapping.channel_id, competitor_product_id, trim(channel_product_mapping.channel_sku) AS channel_sku, is_competitor, channels.name as channel_name 
							FROM app.group_product_mapping 
							INNER JOIN app.channel_product_mapping ON channel_product_mapping.product_id = group_product_mapping.competitor_product_id
							INNER JOIN app.group_channel_mapping ON group_channel_mapping.group_id = group_product_mapping.group_id
							INNER JOIN app.channels ON channels.id = channel_product_mapping.channel_id
							WHERE channel_product_mapping.channel_id =  group_channel_mapping.channel_id AND group_product_mapping.group_id = ' || group_id || ' AND my_product_id = ' || product_id || ' AND channel_product_mapping.id = ANY(group_product_mapping.valid_channel_products)
							ORDER BY is_competitor, cid 
					)t';

				ELSE
					select_query:= select_query || 'SELECT array_to_json(array_agg(row_to_json(t))) from (							
						WITH mappings as (SELECT group_product_mapping.id AS id, valid_channels AS valid_channels, 
							json_build_object(channel_id, json_agg(DISTINCT(trim(channel_product_mapping.channel_sku)))) AS all_mapping
							FROM app.group_product_mapping 
							INNER JOIN app.channel_product_mapping ON channel_product_mapping.product_id = group_product_mapping.competitor_product_id
							WHERE group_product_mapping.group_id = ' || group_id || ' AND group_product_mapping.competitor_product_id = ' || product_id || '
							GROUP BY group_product_mapping.id, channel_id)
						SELECT id, valid_channels, json_agg(all_mapping) AS map FROM mappings GROUP BY id, valid_channels)t';							
				END IF;
				RETURN QUERY EXECUTE format (select_query);
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.get_channel_products(integer, integer, boolean)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.get_channel_products(integer, integer, boolean)
  	" 
  end
end
