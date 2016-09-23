class FindOrCreateByCategories < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.find_or_create_by_categories(
				name text,
				full_name text DEFAULT 'unknown'::text
			)
			RETURNS integer AS
			$BODY$
			DECLARE
				category_id integer;
			BEGIN
				category_id = -1;
				IF(name is not null) THEN
					EXECUTE format('SELECT id FROM app.categories WHERE name::text ILIKE ''' || name || '''') INTO category_id;
				END IF;

				IF(category_id is null) THEN
					IF(full_name is null or full_name = 'unknown') THEN
						full_name:= full_name || '.' || name;
					END IF;

					EXECUTE format('INSERT INTO app.categories (name, full_name) VALUES (''' || name || ''', ''' || full_name || ''') RETURNING id') INTO category_id;
				END IF;

				RETURN category_id::integer;

			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.find_or_create_by_categories(text, text)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.find_or_create_by_categories(text, text)
  	" 
  end
end
