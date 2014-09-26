#!/bin/sh

# Define database parameters
HOST=
USER=
DB=mexico
export PGPASSWORD=""
ICD10DIR=/Users/Nicke/Desktop/DSSG/mexico/data_dicts/icd102010enMeta
BLOCKFILE=$ICD10DIR/blocks.txt
CHAPTERFILE=$ICD10DIR/chapters.txt
CODESFILE=$ICD10DIR//codes.txt

# New load codes file, blocks file, and chapter file, then merge them together
psql -h $HOST -U $USER $DB <<EOF
CREATE SCHEMA IF NOT EXISTS icd10;
DROP TABLE IF EXISTS icd10.codes;
CREATE TABLE icd10.codes (
	class_hierarchy integer,
	node_type varchar,
	explicit_derived varchar,
	chapter_num varchar,
	block_start varchar,
	code_dash varchar,
	code_no_dash varchar,
	code_no_dot varchar,
	code_description varchar,
	mortality_ref1 varchar,
	mortality_ref2 varchar,
	mortality_ref3 varchar,
	mortality_ref4 varchar,
	morbidity_ref varchar
)
;

\copy icd10.codes from $CODESFILE DELIMITER ';' ENCODING 'LATIN1';

DROP TABLE IF EXISTS icd10.blocks;
CREATE TABLE icd10.blocks (
	block_start varchar,
	block_end varchar,
	chapter_num varchar,
	block_description varchar
)
;

\copy icd10.blocks from $BLOCKFILE DELIMITER ';' ENCODING 'LATIN1';

DROP TABLE IF EXISTS icd10.chapters;
CREATE TABLE icd10.chapters (
	chapter_num varchar,
	chapter_description varchar
)
;

\copy icd10.chapters from $CHAPTERFILE DELIMITER ';' ENCODING 'LATIN1';

DROP TABLE IF EXISTS icd10_3;
CREATE TABLE icd10_3 AS
SELECT 
	icd10.codes.code_no_dot as icd_10_3,
	icd10.codes.block_start as block_start,
	icd10.codes.chapter_num as chapter_num,
	icd10.codes.code_description as code3_description,
	icd10.blocks.block_description as block_description,
	icd10.chapters.chapter_description as chapter_description
FROM icd10.codes
LEFT JOIN icd10.blocks
USING (block_start)
LEFT JOIN icd10.chapters
ON icd10.codes.chapter_num = icd10.chapters.chapter_num
WHERE class_hierarchy = 3
;

CREATE INDEX icd10_3_lookup ON icd10_3 (icd_10_3);

DROP TABLE IF EXISTS icd10_4;
CREATE TABLE icd10_4 AS
SELECT icd4.*,
	icd10_3.*
FROM (
	SELECT code as icd_10_4,
		title as code4_description
	FROM ICD10
	WHERE CHAR_LENGTH(code) = 4
	) as icd4
LEFT JOIN icd10_3
ON substring(icd4.icd_10_4, 1, 3) = icd10_3.icd_10_3
;

CREATE INDEX icd10_4_lookup ON icd10_4 (icd_10_4);

EOF
