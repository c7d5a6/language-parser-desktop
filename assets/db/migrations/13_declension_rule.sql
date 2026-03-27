CREATE TABLE declension_rule_tbl
(
    id            INTEGER NOT NULL PRIMARY KEY,
    declension_id INTEGER NOT NULL,
    name          TEXT    NOT NULL,
    word_pattern  TEXT    DEFAULT NULL,
    enabled       BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (declension_id) REFERENCES declension_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX dr_declension_idx ON declension_rule_tbl (declension_id);

CREATE TABLE declension_rule_gc_value_connection_tbl
(
    id                 INTEGER NOT NULL PRIMARY KEY,
    declension_rule_id INTEGER NOT NULL,
    gcv_id             INTEGER NOT NULL,
    UNIQUE (declension_rule_id, gcv_id),
    FOREIGN KEY (declension_rule_id) REFERENCES declension_rule_tbl (id) ON DELETE RESTRICT,
    FOREIGN KEY (gcv_id) REFERENCES grammatical_category_value_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX drgc_rule_idx ON declension_rule_gc_value_connection_tbl (declension_rule_id);
CREATE INDEX drgc_gcv_idx ON declension_rule_gc_value_connection_tbl (gcv_id);

CREATE TABLE declension_rule_sound_change_tbl
(
    id                 INTEGER NOT NULL PRIMARY KEY,
    declension_rule_id INTEGER NOT NULL,
    change             TEXT    NOT NULL,
    FOREIGN KEY (declension_rule_id) REFERENCES declension_rule_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX drsc_rule_idx ON declension_rule_sound_change_tbl (declension_rule_id);
