class InsertChannelProducts < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.insert_channel_products(
				channel_id integer,
				product_id integer,
				channel_sku text,
				status_id integer DEFAULT(4),
				created_by integer DEFAULT(-1),
				updated_by integer DEFAULT(-1)					
			)
			RETURNS SETOF json AS
			$BODY$
			DECLARE	
				duplication_allowed boolean:=true;							
				response text;
				overall_response text:='';			
				exception_product_id integer;
			BEGIN
				IF(status_id is null) THEN
					status_id = 4;
				END IF;		

				IF(created_by is null) THEN
					created_by = -1;
				END IF;	

				IF(updated_by is null) THEN
					updated_by = -1;
				END IF;	

				EXECUTE format('
					SELECT has_multiple_sku FROM app.channel_product_mapping 
					INNER JOIN app.channels ON channels.id = channel_id
					WHERE product_id = %s AND channel_id = %s', $2, $1
				) INTO duplication_allowed;
				
				IF(duplication_allowed OR duplication_allowed is null) THEN
					BEGIN									
						EXECUTE format('
							INSERT INTO app.channel_product_mapping (channel_id, product_id, channel_sku, status_id, created_by, updated_by) VALUES ( %s, %s, ''%s'', %s, %s, %s) RETURNING ID', $1, $2, $3, $4, $5, $6
						) INTO response;					
						overall_response:= overall_response || '''status'', 200, ''Message'', ''Data Saved Successfully!!!'', ''ID'','  || response;
						EXECUTE format('
							WITH updated_col as (SELECT array_agg(group_product_mapping.id) as ids FROM app.group_product_mapping INNER JOIN app.group_channel_mapping ON group_channel_mapping.group_id  = group_product_mapping.group_id WHERE channel_id = %s AND competitor_product_id = %s)
							UPDATE app.group_product_mapping SET valid_channel_products = array_append(valid_channel_products, %s) FROM updated_col WHERE id = ANY(updated_col.ids)', channel_id, $2, response
						);					
					EXCEPTION 
						WHEN SQLSTATE '23505' THEN
							EXECUTE format('SELECT product_id FROM app.channel_product_mapping WHERE channel_sku = ''%s''',channel_sku::text) INTO exception_product_id;
							IF (product_id == exception_product_id) THEN
								overall_response:= overall_response || '''status'', 400, ''Message'', ''Channel SKU already mapped to this product!!!'', ''ID'','  || exception_product_id;					
							ELSE
								overall_response:= overall_response || '''status'', 400, ''Message'', ''Channel SKU already mapped to different product!!!'', ''ID'','  || exception_product_id;					
							END IF;							
					END;
				ELSE
					overall_response:= overall_response || '''status'', 400, ''Message'', ''Product already have SKU linked to this channel, so cannot link more SKUs.''';
				END IF;				

				RETURN QUERY EXECUTE format ('
					SELECT json_build_object (%s) as output', overall_response
				);

			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.insert_channel_products(integer, integer, text, integer, integer, integer)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.insert_channel_products(integer, integer, text,integer, integer, integer)
  	" 
  end
end
