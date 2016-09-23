# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

WITH group_channels as (
			SELECT group_id, json_agg(DISTINCT(channel_id)) AS channel_ids FROM app.group_channel_mapping GROUP BY group_id
			)
			UPDATE app.group_product_mapping
			SET valid_channels = channel_ids
			FROM group_channels
			where group_product_mapping.group_id = group_channels.group_id

SELECT count(product_id), product_id, group_id, json_agg(DISTINCT(competitor_product_id)) FROM app.channel_product_mapping
INNER JOIN app.group_product_mapping ON my_product_id = product_id
WHERE is_competitor = true
GROUP BY product_id, group_id
having count(product_id) > 1

SELECT count(my_product_id), my_product_id, json_agg(competitor_product_id), group_id FROM app.group_product_mapping
WHERE is_competitor = true
GROUP BY my_product_id, group_id
having count(my_product_id) > 1

SELECT * FROM app.universal_updater('group_product_mapping', 20030, 'valid_channels', '''[1,3,4,5,7,33]''')

******* Updating valid_channel_products column ******************
WITH valid_channel_products AS (SELECT array_agg(DISTINCT(channel_product_mapping.id)) as id, product_id, 
group_product_mapping.group_id AS group_id, json_agg(channels.name) as channel_names
FROM app.channel_product_mapping 
INNER JOIN app.group_product_mapping ON competitor_product_id = product_id
INNER JOIN app.group_channel_mapping ON group_channel_mapping.group_id = group_product_mapping.group_id
INNER JOIN app.channels ON channels.id = channel_product_mapping.channel_id
WHERE channel_product_mapping.channel_id =  group_channel_mapping.channel_id 
GROUP BY product_id, group_product_mapping.group_id)
UPDATE app.group_product_mapping SET valid_channel_products = valid_channel_products.id 
FROM valid_channel_products WHERE group_product_mapping.group_id = valid_channel_products.group_id AND 
competitor_product_id = product_id 


CHECK DUPLICATE RECORDS IN GROUP PRODUCT MAPPING
**********----------------****************
With group_mapping as (SELECT concat(group_id, my_product_id, competitor_product_id)::text as unique_index, id 
FROM app.group_product_mapping)
SELECT count(id), json_agg(id) FROM group_mapping group by unique_index having count(id) > 1