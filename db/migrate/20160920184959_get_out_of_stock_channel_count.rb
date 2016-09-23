class GetOutOfStockChannelCount < ActiveRecord::Migration
  def up
  	execute "
  		-- Function: crawled_data.get_out_of_stock_channel_count(integer, date)

			CREATE OR REPLACE FUNCTION crawled_data.get_out_of_stock_channel_count(
				group_id integer,
				crawl_date date
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

						select_query:= 'select array_to_json(array_agg(row_to_json(t))) from (
							SELECT cp.channel_id AS channelid, channels.name AS name, count(DISTINCT(cp.id)) as count FROM app.products						
								INNER JOIN app.group_product_mapping gpm ON gpm.my_product_id = products.id
								INNER JOIN app.channel_product_mapping cpm ON cpm.product_id = gpm.my_product_id
								INNER JOIN crawled_data.crawled_products cp ON cp.product_id = cpm.product_id AND cp.channel_sku = cpm.channel_sku AND cp.channel_id = cpm.channel_id 
								INNER JOIN app.channels ON channels.id = cp.channel_id
								WHERE gpm.is_competitor = false AND cpm.id = ANY(gpm.valid_channel_products) AND cp.status = ''Out Of Stock''
								%s
								GROUP BY cp.channel_id, channels.name
						)t';

						RAISE NOTICE '%', format (select_query, search_query, search_query); 

						RETURN QUERY EXECUTE format (select_query, search_query, search_query); 

					END IF;														
				END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION crawled_data.get_out_of_stock_channel_count(integer, date)
		  OWNER TO paxcom;
  	"
  end

  def down
  	execute "
  		DROP FUNCTION crawled_data.get_out_of_stock_channel_count(integer, date);
  	"
  end
end
