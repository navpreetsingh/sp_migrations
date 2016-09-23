class InsertProducts < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.insert_products(				
				name text,
				brand text,
				category text,				
				image_url text,
				description text,
				group_id integer,
				channel_id integer,
				channel_sku text,
				custom_sku text,
				price decimal DEFAULT 0.0,
				selling_price decimal DEFAULT 0.0,
				is_complete boolean DEFAULT false,
				created_by integer DEFAULT -1,
				updated_by integer DEFAULT -1,
				status_id integer DEFAULT 4
			)
			RETURNS SETOF json AS
			$BODY$
			DECLARE
				brand_id integer;				
				category_id integer;
				product_id integer;
				overall_response text:='';
				sku_id text;	
			BEGIN				
				brand_id = app.find_or_create_by_brands(brand);
				category_id = app.find_or_create_by_categories(category);
				
				EXECUTE format('
					INSERT INTO app.products (name, brand_id, category_id, image_url, description, price, selling_price, is_complete, created_by, updated_by) VALUES (''%s'', %s, %s, ''%s'', ''%s'', %s, %s, ''%s'', %s, %s) RETURNING id, sku_id', $1, brand_id, category_id, $4, $5, $10, $11, $12, $13, $14
				) INTO product_id, sku_id;	

				IF(group_id is not null) THEN 
					EXECUTE format('
						SELECT * FROM app.insert_group_products (%s, %s, %s, ''%s'', false)', $6, product_id, product_id, $9
					);
				END IF;			

				IF(channel_sku is not null) THEN
					EXECUTE format('
						SELECT * FROM app.insert_channel_products (%s, %s, ''%s'', %s, %s, %s)', $7, product_id, $8, $15, $13, $14 
					);
				ELSE
					EXECUTE format('
						SELECT * FROM app.insert_channel_products (%s, %s, ''%s'', %s, %s, %s)', 6, product_id, sku_id, 3, $13, $14 
					);
				END IF;

				overall_response:= overall_response || '''status'', 200, ''Message'', ''Data Saved Successfully!!!'', ''ID'','  || product_id;
				
				RETURN QUERY EXECUTE format ('
					SELECT json_build_object (%s) as output', overall_response
				);

			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.insert_products(text, text, text, text, text, integer, integer, text, text, decimal, decimal, boolean, integer, integer, integer)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.insert_products(text, text, text, text, text, integer, integer, text, text, decimal, decimal, boolean, integer, integer, integer)
  	" 
  end
end
