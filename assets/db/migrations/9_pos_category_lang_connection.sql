CREATE TABLE pos_category_lang_connection_tbl
(
    id      INTEGER NOT NULL PRIMARY KEY,

    lang_id INTEGER NOT NULL,
    gc_id   INTEGER NOT NULL,
    pos_id  INTEGER NOT NULL,
    UNIQUE (lang_id, gc_id, pos_id),
    FOREIGN KEY (lang_id) REFERENCES language_tbl (id) ON DELETE RESTRICT,
    FOREIGN KEY (gc_id) REFERENCES grammatical_category_tbl (id) ON DELETE RESTRICT,
    FOREIGN KEY (pos_id) REFERENCES pos_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX pclc_lang_idx ON pos_category_lang_connection_tbl (lang_id);
CREATE INDEX pclc_gc_idx ON pos_category_lang_connection_tbl (gc_id);
CREATE INDEX pclc_pos_idx ON pos_category_lang_connection_tbl (pos_id);
