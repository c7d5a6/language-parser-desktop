CREATE TABLE grammatical_category_value_tbl
(
    id          INTEGER NOT NULL PRIMARY KEY,

    name        TEXT    NOT NULL UNIQUE,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES grammatical_category_tbl (id) ON DELETE RESTRICT
);

CREATE INDEX gcv_category_idx ON grammatical_category_value_tbl (category_id);
