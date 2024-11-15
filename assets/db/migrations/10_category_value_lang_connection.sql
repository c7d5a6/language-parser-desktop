CREATE TABLE category_value_lang_connection_tbl
(
    id      INTEGER NOT NULL PRIMARY KEY,

    lang_id INTEGER NOT NULL,
    gcv_id  INTEGER NOT NULL,
    UNIQUE (lang_id, gcv_id),
    FOREIGN KEY (lang_id) REFERENCES language_tbl (id) ON DELETE RESTRICT,
    FOREIGN KEY (gcv_id) REFERENCES grammatical_category_value_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX cvl_lang_idx ON category_value_lang_connection_tbl (lang_id);
CREATE INDEX cvl_gcv_idx ON category_value_lang_connection_tbl (gcv_id);
