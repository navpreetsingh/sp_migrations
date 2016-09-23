class GetLastUpdatedDate < ActiveRecord::Migration
  def up
  	execute "  		
			CREATE OR REPLACE FUNCTION crawled_data.get_last_updated_date(_tbl regclass)
			  RETURNS date AS
			$BODY$
			  DECLARE 
					last_updated_date date;
			   	BEGIN				
						EXECUTE format('SELECT crawl_date FROM %s order by crawl_date desc limit 1', _tbl)
							INTO last_updated_date;
			   		RETURN last_updated_date;
					END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			ALTER FUNCTION crawled_data.get_last_updated_date(regclass)
			  OWNER TO paxcom;
  	"
  end

  def down
  	execute "
  		DROP FUNCTION crawled_data.get_last_updated_date(regclass);
  	"
  end
end
