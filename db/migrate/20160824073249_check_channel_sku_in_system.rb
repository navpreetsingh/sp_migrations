class CheckChannelSkuInSystem < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.check_channel_sku_in_system(
				channel_id integer,				
				channel_sku text
			)
			RETURNS SETOF json AS
			$BODY$
			DECLARE	
				pid integer;			
				check_id integer;
				select_query text:='';
				response text;
			BEGIN	
				EXECUTE format('SELECT id, product_id FROM app.channel_product_mapping WHERE channel_sku::text ILIKE ''%s'' AND channel_id = ' || channel_id,channel_sku::text) INTO pid, check_id;
				IF(check_id is not null) THEN
					select_query:= select_query || '
						SELECT json_build_object(''Status'', true, ''Message'', ''Channel SKU already exist for this channel!!!'', ''ID'', ' || pid || ', ''Product ID'', ' || check_id || ') 
					';
				ELSE
					select_query:= select_query || '
						SELECT json_build_object(''Status'', false, ''Message'', ''Channel SKU does not exist in system!!!'')
					';
				END IF;				

				RETURN QUERY EXECUTE format (select_query);
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.check_channel_sku_in_system(integer, text)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.check_channel_sku_in_system(integer, text)
  	" 
  end
end
