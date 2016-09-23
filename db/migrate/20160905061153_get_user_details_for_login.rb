class GetUserDetailsForLogin < ActiveRecord::Migration
  def up
  	execute "  		
			CREATE OR REPLACE FUNCTION app.get_user_details_for_login(IN character varying)
			  RETURNS SETOF json AS
			$BODY$

			BEGIN			     
	     	RETURN QUERY
	     		SELECT array_to_json(array_agg((t))) from (
		        SELECT users.id AS id, trim(username) AS user_name, trim(firstname) AS first_name, trim(lastname) AS last_name, trim(auth_mode) AS auth_mode, trim(password) as password, trim(salt) as salt, role_id, status_id, trim(email) AS email, groups.end_date, roles.name as role_name, menu_json, group_id
		        FROM app.users 
		        INNER JOIN app.groups ON groups.id = users.group_id
		        INNER JOIN app.roles ON roles.id = users.role_id
				    WHERE lower(users.username)=lower($1)
				  )t;
			 
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100
			  ROWS 1000;
			ALTER FUNCTION app.get_user_details_for_login(character varying)
			  OWNER TO paxcom;
  	"
  end

  def down 
  	execute "
  		DROP FUNCTION app.get_user_details_for_login(character varying);
  	"
  end
end
