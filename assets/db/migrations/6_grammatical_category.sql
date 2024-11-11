CREATE TABLE grammatical_category_tbl
(
    id   INTEGER NOT NULL PRIMARY KEY,

    name TEXT    NOT NULL UNIQUE
);

INSERT INTO grammatical_category_tbl(id, name)
VALUES (1, 'Case'),
       (2, 'Gender'),
       (3, 'Number'),
       (4, 'Tense'),
       (5, 'Aspect'),
       (6, 'Mood');