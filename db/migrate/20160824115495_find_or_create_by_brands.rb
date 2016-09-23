class FindOrCreateByBrands < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.find_or_create_by_brands(
				name text
			)
			RETURNS integer AS
			$BODY$
			DECLARE
				brand_id integer;
			BEGIN
				brand_id = -1;
				IF(name is not null) THEN
					EXECUTE format('SELECT id FROM app.brands WHERE name ILIKE ''' || name || '''') INTO brand_id;
				END IF;

				IF(brand_id is null) THEN
					EXECUTE format('INSERT INTO app.brands (name) VALUES (''' || name || ''') RETURNING id') INTO brand_id;
				END IF;

				RETURN brand_id::integer;				

			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.find_or_create_by_brands(text)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.find_or_create_by_brands(text)
  	" 
  end
end
