# -*- coding: utf-8 -*-
"""
Created on Mon Jun 30 17:53:41 2014

@author: Nicke
"""

# -*- coding: utf-8 -*-
"""
For DSSG Mexico Project
Compare category labels of each of the births databases, output a diffs file that describes differences
"""

import psycopg2 as dbconnect
import pandas as pd
import os
import csv

db = dbconnect.connect(host='',
                             database='mexico',
                             user='',
                             password='')

out_dir = "/Users/Nicke/desktop/dssg/mexico/scripts/nick/table_analysis/"

table_schema = "public"
table_name = "clues_data"

export_dir = os.path.join(out_dir, table_schema, table_name)
if not os.path.exists(export_dir):
        os.makedirs(export_dir)

columns = pd.read_sql("""
SELECT column_name
FROM information_schema.columns
WHERE table_schema = '""" + table_schema + """' 
AND table_name = '""" + table_name + "'", db)

column_list = columns['column_name'].tolist()

for column in column_list:
    print "analyzing " + column
    distinct_df = pd.DataFrame()    
    try:
        distinct_df = pd.read_sql("SELECT COUNT(*), " + column + " FROM \"" + table_schema + "\".\"" + table_name + "\" GROUP BY " + column + " ORDER BY " + column, db)        
    except:
        print column + " read failed"
    try:
        distinct_df.to_csv(os.path.join(export_dir, column + ".csv"), index=False, quoting=csv.QUOTE_ALL)
    except:
        print column + " write failed"
        

#### Other stuff
data = pd.read_sql("""
SELECT count(*), prev_child_dob FROM births_data GROUP BY prev_child_dob ORDER BY prev_child_dob;""", db)