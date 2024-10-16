CREATE TABLE word_tbl
(
    id           INTEGER NOT NULL PRIMARY KEY,

    word         TEXT    NOT NULL,
--     written  TEXT ?,
    language     INTEGER NOT NULL,
    pos          INTEGER NOT NULL,
    comment      TEXT,
    forgotten_yn BOOLEAN NOT NULL DEFAULT FALSE,
    source_type  TEXT NOT NULL,
    FOREIGN KEY (language) REFERENCES language_tbl (id),
    FOREIGN KEY (pos) REFERENCES pos_tbl (id)
);
