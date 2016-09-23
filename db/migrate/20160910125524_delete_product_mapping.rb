class DeleteProductMapping < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.delete_product_mapping(
				id integer,
				channel_product_mapping_id integer
		  )
			RETURNS SETOF json AS
			$BODY$
			DECLARE
				valid_channel_products_length integer;
				is_competitor boolean;
			BEGIN	
				RAISE NOTICE '%', FORMAT('					
					UPDATE app.group_product_mapping SET valid_channel_products = array_remove(valid_channel_products, %s)
						where id = %s RETURNING array_length(valid_channel_products, 1), is_competitor', channel_product_mapping_id, id
				);

				EXECUTE FORMAT('					
					UPDATE app.group_product_mapping SET valid_channel_products = array_remove(valid_channel_products, %s)
						where id = %s RETURNING array_length(valid_channel_products, 1), is_competitor', channel_product_mapping_id, id
				) INTO valid_channel_products_length, is_competitor; 
				
				RAISE NOTICE '%', valid_channel_products_length;
				RAISE NOTICE '%', is_competitor;
				
				IF(is_competitor) AND (valid_channel_products_length is null) THEN
					RAISE NOTICE '%' , 'IN If condition';
					EXECUTE FORMAT('
						DELETE FROM app.group_product_mapping WHERE id = %s', id
					);
				END IF;

				RETURN QUERY EXECUTE FORMAT('
					SELECT json_build_object(''status'', 200, ''Message'', ''Data Updated Successfully!!!'') as response
				'); 
				
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION app.delete_product_mapping(integer, integer)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.delete_product_mapping(integer, integer)
  	" 	
  end
end
