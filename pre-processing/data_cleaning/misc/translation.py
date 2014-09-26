# -*- coding: utf-8 -*-
"""
Script to translate a column of text from Spanish to English
"""

import csv
import goslate

file_input = "/Users/Nicke/Desktop/translate_this2.csv"
file_output = "/Users/Nicke/Desktop/translation_out.csv"

translate_this = []
with open(file_input, 'rU') as input_file:
    input_reader = csv.reader(input_file)
    for row in input_reader:
        translate_this.append(row)

gs = goslate.Goslate()

for row in translate_this:
    row.append(gs.translate(row[1].encode('utf-8').strip(), 'en', 'sp'))
    
with open(file_output, 'w+') as output_file:
    output_writer = csv.writer(output_file)
    for row in translate_this:
        output_writer.writerow(row)
