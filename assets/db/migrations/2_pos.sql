CREATE TABLE pos_tbl
(
    id           INTEGER NOT NULL PRIMARY KEY,

    name         TEXT    NOT NULL,
    abbreviation TEXT
);

INSERT INTO pos_tbl(id, name, abbreviation)
VALUES (1, 'Adjective', 'adj.'),
       (2, 'Adposition', 'adpos.'),
       (3, 'Adverb', 'adv.'),
       (4, 'Affix', 'afx.'),
       (5, 'Article', 'art.'),
       (6, 'Auxiliary Verb', 'aux.'),
       (7, 'Cardinal numeral', 'card.'),
       (8, 'Classifier', 'clf.'),
       (9, 'Clitic', 'clit.'),
       (10, 'Conjunction', 'cnj.'),
       (11, 'Contraction', 'contr.'),
       (12, 'Coverb', 'covrb.'),
       (13, 'Determiner', 'det.'),
       (14, 'Interjection', 'inj.'),
       (15, 'Noun', 'n.'),
       (16, 'Particle', 'ptcl.'),
       (17, 'Preverb', 'pvb.'),
       (18, 'Pronoun', 'pro.'),
       (19, 'Proper Noun', 'pn.'),
       (20, 'Verb', 'v.');
