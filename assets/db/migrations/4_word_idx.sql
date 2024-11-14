CREATE INDEX word_idx ON word_tbl (word);
CREATE INDEX word_pos_idx ON word_tbl (pos);
CREATE INDEX word_lang_idx ON word_tbl (language);

CREATE VIRTUAL TABLE fts5_word
    USING fts5
(
    word,
    content='word_tbl',
    content_rowid='id',
    tokenize='trigram remove_diacritics 1'
);

CREATE TRIGGER word_tr_ai
    AFTER INSERT
    ON word_tbl
BEGIN
    INSERT INTO fts5_word(rowid, word) VALUES (new.id, new.word);
END;

CREATE TRIGGER word_tr_ad
    AFTER DELETE
    ON word_tbl
BEGIN
    INSERT INTO fts5_word(fts5_word, rowid, word) VALUES ('delete', old.id, old.word);
END;

CREATE TRIGGER word_tr_au
    AFTER UPDATE
    ON word_tbl
BEGIN
    INSERT INTO fts5_word(fts5_word, rowid, word) VALUES ('delete', old.id, old.word);
    INSERT INTO fts5_word(rowid, word) VALUES (new.id, new.word);
END;
