SELECT 'ALTER TABLE ' || table_schema || '."' || table_name || '" RENAME TO ' || lower(table_name) || ';' FROM information_schema.tables WHERE table_name ~ '[[A-Z]]*';
