CREATE TABLE declension_tbl
(
    id      INTEGER NOT NULL PRIMARY KEY,

    lang_id INTEGER NOT NULL,
    pos_id  INTEGER NOT NULL,
    main    BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (lang_id) REFERENCES language_tbl (id) ON DELETE RESTRICT,
    FOREIGN KEY (pos_id) REFERENCES pos_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX d_lang_idx ON declension_tbl (lang_id);
CREATE INDEX d_pos_idx ON declension_tbl (pos_id);

CREATE TABLE declension_value_connection_tbl
(
    id            INTEGER NOT NULL PRIMARY KEY,

    declension_id INTEGER NOT NULL,
    value_id      INTEGER NOT NULL,
    FOREIGN KEY (declension_id) REFERENCES declension_tbl (id) ON DELETE CASCADE,
    FOREIGN KEY (value_id) REFERENCES grammatical_category_value_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX dvc_declension_idx ON declension_value_connection_tbl (declension_id);
CREATE INDEX dvc_value_idx ON declension_value_connection_tbl (value_id);
