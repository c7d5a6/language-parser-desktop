CREATE TABLE language_tbl
(
    id           INTEGER NOT NULL PRIMARY KEY,

    display_name TEXT    NOT NULL UNIQUE,
    native_name  TEXT UNIQUE,
    comment      TEXT
);
