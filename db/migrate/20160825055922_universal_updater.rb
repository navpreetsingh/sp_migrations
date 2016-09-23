class UniversalUpdater < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.universal_updater(
				table_name text,
				condition text,
				update_attributes text,
				update_values text				
			)
			RETURNS SETOF json AS
			$BODY$
			DECLARE				
			BEGIN				
				EXECUTE FORMAT('					
					UPDATE app.%s SET(%s) = (%s) %s RETURNING id',
					table_name, update_attributes, update_values, condition
				);

				RETURN QUERY EXECUTE FORMAT('
					SELECT json_build_object(''status'', 200, ''Message'', ''Data Updated Successfully!!!'') as response
				');

			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.universal_updater(text, text, text, text)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.universal_updater(text, text, text, text)
  	" 
  end
end
