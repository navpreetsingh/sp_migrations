class InsertGroupProducts < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.insert_group_products(				
				group_id integer,
				product_id integer,
				competitor_id integer,				
				custom_sku text,
				is_competitor boolean DEFAULT false
			)
			RETURNS SETOF json AS
			$BODY$
			DECLARE				
				check_relationship json;
				status boolean;
				message text;
				response text:='';
				overall_response text:='';			
				channel_product_ids integer[];
			BEGIN
				IF(product_id <> competitor_id) THEN
					is_competitor:= true;
				ELSE
					is_competitor:= false;
				END IF;
				
				check_relationship = app.check_group_product_relationship(group_id, product_id, competitor_id, is_competitor);

				EXECUTE format('SELECT ''%s''::JSON->>''Status'' as output', check_relationship) INTO status;					

				IF(status) THEN					
					EXECUTE format('SELECT array_agg(id) FROM app.channel_product_mapping WHERE channel_id in (SELECT DISTINCT(channel_id) FROM app.group_channel_mapping WHERE group_id = ' || group_id || ' AND product_id = ' || $3 || ')') INTO channel_product_ids;

					IF(channel_product_ids is null) THEN
						channel_product_ids = '{}';
					END IF;				

					BEGIN
						EXECUTE format('
						INSERT INTO app.group_product_mapping (group_id, my_product_id, competitor_product_id, is_competitor, valid_channel_products, custom_sku) VALUES (%s, %s, %s, ''%s'', ''%s'', ''%s'') RETURNING id
					', $1, $2, $3, $5, channel_product_ids, $4) INTO response;
						overall_response:= overall_response || '''status'', 200, ''Message'', ''Data Saved Successfully!!!'', ''ID'', ' || response; 											
					EXCEPTION 
						WHEN SQLSTATE '23505' THEN						
							overall_response:= overall_response || '''status'', 400, ''Message'', ''This Product is already your competitor!!!'''; 					
					END;

				ELSE 
					EXECUTE format('SELECT ''%s''::JSON->>''Message'' as output', check_relationship) INTO message;
					overall_response:= overall_response || '''status'', 400, ''Message'', ''' || message || '''';
				END IF;

				RETURN QUERY EXECUTE format ('
					SELECT json_build_object (%s) as output', overall_response
				);		

			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.insert_group_products(integer, integer, integer, text, boolean)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.insert_group_products(integer, integer, integer, text, boolean)
  	" 
  end
end
