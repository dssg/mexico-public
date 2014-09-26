# -*- coding: utf-8 -*-
"""
For DSSG Mexico Project
Compare category labels of each of the births databases, output a diffs file that describes differences
"""

import psycopg2 as dbconnect
import pandas as pd
import os
import subprocess

db = dbconnect.connect(host='',
                             database='mexico',
                             user='',
                             password='')

export_dir = "/Users/Nicke/desktop/dssg/mexico/scripts/nick/table_translations/cat_comparisons/"
schemas = ['births_08', 'births_09', 'births_10', 'births_11', 'births_12', 'births_13']
tables = [
    'CatVariables',
    'CatEdoConyugal',
    'Listadet',
    'CatEscolaridad',
    'CATCLUES',
    'CATPRODUCTO',
    'CatCertifica',
    'CatSexo',
    'CATMPO',
    'CatAtendioParto',
    'CatJurisd',
    'CatEstados',
    'CATMESES',
    'CatLocal',
    'CATOCUHA',
    'CatTrimestres',
    'CatTipoNaciAnterior',
    'CATDEREC',
    'CATLUGCAPT',
    'CatTipoProced',
    'CatLugarNac',
    'CatSiNo'
    ]

for table in tables:
    out_path = os.path.join(export_dir, table)
    
    if not os.path.exists(out_path):
        os.makedirs(out_path)    
    
    for schema in schemas:
        cat_data = pd.read_sql("""
        SELECT *
        FROM \"""" + schema + "\"." + "\"" + table + "\"", db)
        cat_data.to_csv(os.path.join(out_path, schema + ".csv"), index=False)
    
    diffs_list = '.csv '.join(reversed(schemas)) + ".csv"
    try:
        subprocess.call("cd " + out_path + " && diff -q --from-file " + diffs_list + " > diffs.txt", shell=True)
    except:
        pass