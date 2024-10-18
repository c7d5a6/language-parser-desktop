CREATE TABLE language_phoneme_tbl
(
    id       INTEGER NOT NULL PRIMARY KEY,

    phoneme  TEXT    NOT NULL,
    language INTEGER NOT NULL,
    FOREIGN KEY (language) REFERENCES language_tbl (id)
);

CREATE UNIQUE INDEX language_phoneme_idx ON language_phoneme_tbl (phoneme, language);
