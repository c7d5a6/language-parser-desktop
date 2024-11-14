CREATE TABLE pos_lang_connection_tbl
(
    id      INTEGER NOT NULL PRIMARY KEY,

    lang_id INTEGER NOT NULL,
    pos_id  INTEGER NOT NULL,
    UNIQUE (lang_id, pos_id),
    FOREIGN KEY (lang_id) REFERENCES language_tbl (id) ON DELETE RESTRICT,
    FOREIGN KEY (pos_id) REFERENCES pos_tbl (id) ON DELETE RESTRICT
);
