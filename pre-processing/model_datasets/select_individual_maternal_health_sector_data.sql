/***********
This script selects maternal data from (Health sector hospital data known as (BDSS/SECTORIAL)) for indiviual-level modeling!
To avoid information of multiple visits, we only select a visit which leads to 
a delivery, abortion, or death!

input tables are:

layla.sector_maternal_09_12

all tables are stored in schema named layla

***************
 Created by Layla Pournajaf
***************/

SELECT * FROM layla.sector_maternal_09_12
where dead = 1 or abortion = 1 or delivery = 1