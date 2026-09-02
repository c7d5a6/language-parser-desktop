DROP INDEX IF EXISTS dcplc_lang_idx;
DROP INDEX IF EXISTS dcplc_gc_idx;
DROP INDEX IF EXISTS dcplc_pos_idx;

CREATE INDEX dcplc_lang_idx ON declension_category_pos_lang_connection_tbl (lang_id);
CREATE INDEX dcplc_gc_idx ON declension_category_pos_lang_connection_tbl (gc_id);
CREATE INDEX dcplc_pos_idx ON declension_category_pos_lang_connection_tbl (pos_id);
