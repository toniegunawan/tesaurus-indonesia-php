-- Thesaurus Database Schema
-- PHP 8.4 Thesaurus Application

CREATE DATABASE IF NOT EXISTS thesaurus_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE thesaurus_db;

-- Table: word_class
CREATE TABLE word_class (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    abbr VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_name (name),
    UNIQUE KEY unique_abbr (abbr)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: type
CREATE TABLE type (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: category
CREATE TABLE category (
    id INT(11) NOT NULL AUTO_INCREMENT,
    num INT(11) NOT NULL,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_num (num),
    UNIQUE KEY unique_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: subcategory
CREATE TABLE subcategory (
    id INT(11) NOT NULL AUTO_INCREMENT,
    cat_id INT(11) NOT NULL,
    num INT(11) NOT NULL,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    KEY fk_subcategory_category (cat_id),
    CONSTRAINT fk_subcategory_category FOREIGN KEY (cat_id) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: article
CREATE TABLE article (
    id INT(11) NOT NULL AUTO_INCREMENT,
    cat_id INT(11) NOT NULL,
    subcat_id INT(11) NOT NULL,
    num INT(11) NOT NULL,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    KEY fk_article_category (cat_id),
    KEY fk_article_subcategory (subcat_id),
    CONSTRAINT fk_article_category FOREIGN KEY (cat_id) REFERENCES category (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_article_subcategory FOREIGN KEY (subcat_id) REFERENCES subcategory (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: lemma
CREATE TABLE lemma (
    id INT(11) NOT NULL AUTO_INCREMENT,
    label_id INT(11) NOT NULL,
    name VARCHAR(255) NOT NULL,
    name_tagged VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    KEY idx_lemma_name (name),
    KEY fk_lemma_label (label_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: label
CREATE TABLE label (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    abbr VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY unique_name (name),
    UNIQUE KEY unique_abbr (abbr)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: word_relation (main table for synonyms and antonyms)
CREATE TABLE word_relation (
    id INT(11) NOT NULL AUTO_INCREMENT,
    article_id INT(11) NOT NULL,
    par_num INT(11) NOT NULL,
    wordclass_id INT(11) NOT NULL,
    group_num INT(11) NOT NULL,
    type_id INT(11) NOT NULL,
    word_order INT(11) NOT NULL,
    lemma_id INT(11) NOT NULL,
    PRIMARY KEY (id),
    KEY fk_word_relation_article (article_id),
    KEY fk_word_relation_wordclass (wordclass_id),
    KEY fk_word_relation_type (type_id),
    KEY fk_word_relation_lemma (lemma_id),
    CONSTRAINT fk_word_relation_article FOREIGN KEY (article_id) REFERENCES article (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_word_relation_wordclass FOREIGN KEY (wordclass_id) REFERENCES word_class (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_word_relation_type FOREIGN KEY (type_id) REFERENCES type (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_word_relation_lemma FOREIGN KEY (lemma_id) REFERENCES lemma (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add foreign key constraint for lemma table
ALTER TABLE lemma ADD CONSTRAINT fk_lemma_label FOREIGN KEY (label_id) REFERENCES label (id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Insert sample data for testing

-- Insert word classes
INSERT INTO word_class (name, abbr) VALUES 
('Noun', 'n'),
('Verb', 'v'),
('Adjective', 'adj'),
('Adverb', 'adv');

-- Insert types (synonym, antonym, etc.)
INSERT INTO type (name) VALUES 
('synonym'),
('antonym'),
('related'),
('hypernym'),
('hyponym');

-- Insert labels
INSERT INTO label (name, abbr) VALUES 
('Standard', 'std'),
('Formal', 'frm'),
('Informal', 'inf'),
('Archaic', 'arc');

-- Insert categories
INSERT INTO category (num, title, slug) VALUES 
(1, 'General Terms', 'general-terms'),
(2, 'Emotions', 'emotions'),
(3, 'Actions', 'actions');

-- Insert subcategories
INSERT INTO subcategory (cat_id, num, title, slug) VALUES 
(1, 1, 'Basic Concepts', 'basic-concepts'),
(2, 1, 'Positive Emotions', 'positive-emotions'),
(2, 2, 'Negative Emotions', 'negative-emotions'),
(3, 1, 'Physical Actions', 'physical-actions');

-- Insert articles
INSERT INTO article (cat_id, subcat_id, num, title, slug) VALUES 
(1, 1, 1, 'Existence', 'existence'),
(2, 1, 1, 'Happiness', 'happiness'),
(2, 2, 1, 'Sadness', 'sadness'),
(3, 1, 1, 'Movement', 'movement');

-- Insert sample lemmas
INSERT INTO lemma (label_id, name, name_tagged) VALUES 
(1, 'happy', 'happy_adj'),
(1, 'joyful', 'joyful_adj'),
(1, 'glad', 'glad_adj'),
(1, 'sad', 'sad_adj'),
(1, 'unhappy', 'unhappy_adj'),
(1, 'melancholy', 'melancholy_adj'),
(1, 'run', 'run_v'),
(1, 'walk', 'walk_v'),
(1, 'move', 'move_v');

-- Insert word relations (synonyms and antonyms)
-- Happy synonyms
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
(2, 1, 3, 1, 1, 1, 1), -- happy (base word)
(2, 1, 3, 1, 1, 2, 2), -- joyful (synonym)
(2, 1, 3, 1, 1, 3, 3); -- glad (synonym)

-- Happy antonyms
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
(2, 1, 3, 2, 2, 1, 4), -- sad (antonym)
(2, 1, 3, 2, 2, 2, 5), -- unhappy (antonym)
(2, 1, 3, 2, 2, 3, 6); -- melancholy (antonym)

-- Movement synonyms
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
(4, 1, 2, 1, 1, 1, 7), -- run (base word)
(4, 1, 2, 1, 1, 2, 8), -- walk (synonym)
(4, 1, 2, 1, 1, 3, 9); -- move (synonym)
