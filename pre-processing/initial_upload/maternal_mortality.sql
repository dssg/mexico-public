create schema if not exists original;
set schema 'original';

create table maternal_mortality (anionac int,	mesnac int,	dianac int,	sexo int, edaduni char, edadvalor int,	nacion int,	edo_civil int,	entrh int,	munrh int, locrh int,	tamlocrh int, ocupacion int,	escolar int,	derech	int , entocu	int, munocu int,	lococu int,	tamlococ int,	sitio_def	int, aniodef int,	mesdef int,	diadef int,	horadef int,	mindef int,	asist int,	causa4 varchar,	CAUSA3 varchar,	presunto int, trabajo int,	lugles int,	violfam	int, necropcia	int, certific	int, entregf	int, munregf	int, anioreg	int, mesreg	int, diareg int,	peso int,	aniocert int,	mescert int,	diacert int,	condemba int,	rel_emba	int, complicaro int,	year int,	RMM int);

COPY maternal_mortality FROM 'data/Materna2002a2012/Materna2002a2012.csv' CSV HEADER;
