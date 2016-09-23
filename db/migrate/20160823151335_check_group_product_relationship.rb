class CheckGroupProductRelationship < ActiveRecord::Migration
  def up
  	execute "
			CREATE OR REPLACE FUNCTION app.check_group_product_relationship(
				group_id integer,
				product_id integer,
				competitor_id integer,
				competitor boolean DEFAULT false				
			)
			RETURNS SETOF json AS
			$BODY$
			DECLARE
				check_self_product boolean;				
				check_competitor boolean;				
				select_query text:='';
			BEGIN
			
				EXECUTE format('SELECT is_competitor FROM app.group_product_mapping WHERE group_id = %s AND my_product_id = %s AND is_competitor = false LIMIT 1', $1, $2, $2) INTO check_self_product;

				IF(check_self_product = false OR product_id = competitor_id) THEN 
					EXECUTE format('SELECT is_competitor FROM app.group_product_mapping WHERE group_id = %s AND competitor_product_id = %s LIMIT 1', $1, $3) INTO check_competitor;

					IF(check_competitor IS NULL) THEN
						select_query:= select_query || '
							SELECT json_build_object(''Status'', true, ''Message'', ''No Mapping exist for this group and product in system!!!'')';
					ELSIF(competitor) THEN
						IF(check_competitor) THEN
							select_query:= select_query || '
								SELECT json_build_object(''Status'', true, ''Message'', ''This product is your competitor!!!'')';
						ELSE
							select_query:= select_query || '
								SELECT json_build_object(''Status'', false, ''Message'', ''This product is your own product!!!'')';
						END IF;
					ELSE
						IF(check_competitor) THEN
							select_query:= select_query || '
								SELECT json_build_object(''Status'', false, ''Message'', ''This product is your competitor!!!'')';
						ELSE
							select_query:= select_query || '
								SELECT json_build_object(''Status'', false, ''Message'', ''This product is already linked to this group!!!'')';
						END IF;
					END IF;
				ELSE
					select_query:= select_query || '
						SELECT json_build_object(''Status'', false, ''Message'', ''Cannot add your competitor product as your own product!!!'')';
				END IF;
				
				RETURN QUERY EXECUTE format (select_query);					

			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			ALTER FUNCTION app.check_group_product_relationship(integer, integer, integer, boolean)
			  OWNER TO paxcom;
		"
  end

  def down
  	execute "
  		DROP FUNCTION app.check_group_product_relationship(integer, integer, integer, boolean)
  	" 
  end
end
