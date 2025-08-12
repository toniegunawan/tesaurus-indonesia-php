-- Sample Data untuk Tesaurus Indonesia
-- Menambah lebih banyak data contoh untuk testing

USE thesaurus_db;

-- Tambah lebih banyak word classes
INSERT INTO word_class (name, abbr) VALUES 
('Preposition', 'prep'),
('Conjunction', 'conj'),
('Interjection', 'interj'),
('Pronoun', 'pron');

-- Tambah lebih banyak types
INSERT INTO type (name) VALUES 
('similar'),
('opposite'),
('broader'),
('narrower'),
('variant');

-- Tambah lebih banyak labels
INSERT INTO label (name, abbr) VALUES 
('Colloquial', 'coll'),
('Technical', 'tech'),
('Literary', 'lit'),
('Slang', 'slg');

-- Tambah lebih banyak categories
INSERT INTO category (num, title, slug) VALUES 
(4, 'Sifat dan Karakter', 'sifat-karakter'),
(5, 'Warna', 'warna'),
(6, 'Makanan', 'makanan'),
(7, 'Transportasi', 'transportasi'),
(8, 'Keluarga', 'keluarga');

-- Tambah subcategories
INSERT INTO subcategory (cat_id, num, title, slug) VALUES 
(4, 1, 'Sifat Positif', 'sifat-positif'),
(4, 2, 'Sifat Negatif', 'sifat-negatif'),
(5, 1, 'Warna Dasar', 'warna-dasar'),
(5, 2, 'Warna Campuran', 'warna-campuran'),
(6, 1, 'Makanan Pokok', 'makanan-pokok'),
(6, 2, 'Minuman', 'minuman'),
(7, 1, 'Kendaraan Darat', 'kendaraan-darat'),
(7, 2, 'Kendaraan Air', 'kendaraan-air'),
(8, 1, 'Anggota Keluarga', 'anggota-keluarga');

-- Tambah articles
INSERT INTO article (cat_id, subcat_id, num, title, slug) VALUES 
(4, 1, 1, 'Kebaikan', 'kebaikan'),
(4, 2, 1, 'Kejahatan', 'kejahatan'),
(5, 1, 1, 'Merah', 'merah'),
(5, 1, 2, 'Biru', 'biru'),
(6, 1, 1, 'Nasi', 'nasi'),
(6, 2, 1, 'Air', 'air'),
(7, 1, 1, 'Mobil', 'mobil'),
(8, 1, 1, 'Orang Tua', 'orang-tua');

-- Tambah lemmas untuk sifat positif
INSERT INTO lemma (label_id, name, name_tagged) VALUES 
-- Sifat positif
(1, 'baik', 'baik_adj'),
(1, 'bagus', 'bagus_adj'),
(1, 'hebat', 'hebat_adj'),
(1, 'luar biasa', 'luar_biasa_adj'),
(1, 'sempurna', 'sempurna_adj'),
(1, 'cantik', 'cantik_adj'),
(1, 'indah', 'indah_adj'),
(1, 'elok', 'elok_adj'),
(1, 'molek', 'molek_adj'),

-- Sifat negatif  
(1, 'buruk', 'buruk_adj'),
(1, 'jelek', 'jelek_adj'),
(1, 'rusak', 'rusak_adj'),
(1, 'hancur', 'hancur_adj'),

-- Warna
(1, 'merah', 'merah_adj'),
(1, 'merah muda', 'merah_muda_adj'),
(1, 'biru', 'biru_adj'),
(1, 'biru muda', 'biru_muda_adj'),
(1, 'hijau', 'hijau_adj'),
(1, 'kuning', 'kuning_adj'),
(1, 'hitam', 'hitam_adj'),
(1, 'putih', 'putih_adj'),

-- Makanan
(1, 'nasi', 'nasi_n'),
(1, 'beras', 'beras_n'),
(1, 'padi', 'padi_n'),
(1, 'roti', 'roti_n'),
(1, 'minum', 'minum_v'),
(1, 'air', 'air_n'),
(1, 'minuman', 'minuman_n'),

-- Transportasi
(1, 'mobil', 'mobil_n'),
(1, 'kendaraan', 'kendaraan_n'),
(1, 'otomobil', 'otomobil_n'),
(1, 'kapal', 'kapal_n'),
(1, 'perahu', 'perahu_n'),

-- Keluarga
(1, 'ayah', 'ayah_n'),
(1, 'bapak', 'bapak_n'),
(1, 'papa', 'papa_n'),
(1, 'ibu', 'ibu_n'),
(1, 'mama', 'mama_n'),
(1, 'bunda', 'bunda_n'),

-- Verba
(1, 'pergi', 'pergi_v'),
(1, 'berangkat', 'berangkat_v'),
(1, 'datang', 'datang_v'),
(1, 'tiba', 'tiba_v'),
(1, 'makan', 'makan_v'),
(1, 'santap', 'santap_v'),
(1, 'lahap', 'lahap_v');

-- Word relations untuk sifat positif (baik)
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "baik"
(5, 1, 3, 1, 1, 1, 10), -- baik (base)
(5, 1, 3, 1, 1, 2, 11), -- bagus
(5, 1, 3, 1, 1, 3, 12), -- hebat
(5, 1, 3, 1, 1, 4, 13), -- luar biasa
(5, 1, 3, 1, 1, 5, 14), -- sempurna

-- Antonim "baik"
(5, 1, 3, 2, 2, 1, 19), -- buruk
(5, 1, 3, 2, 2, 2, 20), -- jelek
(5, 1, 3, 2, 2, 3, 21); -- rusak

-- Word relations untuk cantik
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "cantik"
(5, 2, 3, 1, 1, 1, 15), -- cantik (base)
(5, 2, 3, 1, 1, 2, 16), -- indah
(5, 2, 3, 1, 1, 3, 17), -- elok
(5, 2, 3, 1, 1, 4, 18), -- molek

-- Antonim "cantik"
(5, 2, 3, 2, 2, 1, 20); -- jelek

-- Word relations untuk warna merah
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "merah"
(7, 1, 3, 1, 1, 1, 23), -- merah (base)
(7, 1, 3, 1, 1, 2, 24); -- merah muda (variant)

-- Word relations untuk warna biru  
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "biru"
(8, 1, 3, 1, 1, 1, 25), -- biru (base)
(8, 1, 3, 1, 1, 2, 26); -- biru muda (variant)

-- Word relations untuk makanan (nasi)
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "nasi" (berbagai bentuk beras)
(9, 1, 1, 1, 1, 1, 31), -- nasi (base)
(9, 1, 1, 1, 3, 2, 32), -- beras (broader)
(9, 1, 1, 1, 3, 3, 33); -- padi (broader)

-- Word relations untuk minuman
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "air"
(10, 1, 1, 1, 1, 1, 36), -- air (base)
(10, 1, 1, 1, 4, 2, 37); -- minuman (broader)

-- Word relations untuk transportasi (mobil)
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "mobil"
(11, 1, 1, 1, 1, 1, 38), -- mobil (base)
(11, 1, 1, 1, 1, 2, 39), -- kendaraan (broader)
(11, 1, 1, 1, 1, 3, 40); -- otomobil (formal)

-- Word relations untuk transportasi air
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "kapal"
(11, 2, 1, 1, 1, 1, 41), -- kapal (base)
(11, 2, 1, 1, 1, 2, 42); -- perahu

-- Word relations untuk keluarga (ayah)
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "ayah"
(12, 1, 1, 1, 1, 1, 43), -- ayah (base)
(12, 1, 1, 1, 1, 2, 44), -- bapak (formal)
(12, 1, 1, 1, 1, 3, 45); -- papa (informal)

-- Word relations untuk keluarga (ibu)
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "ibu"
(12, 2, 1, 1, 1, 1, 46), -- ibu (base)
(12, 2, 1, 1, 1, 2, 47), -- mama (informal)
(12, 2, 1, 1, 1, 3, 48); -- bunda (formal)

-- Word relations untuk verba pergi
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "pergi"
(4, 2, 2, 1, 1, 1, 49), -- pergi (base)
(4, 2, 2, 1, 1, 2, 50), -- berangkat

-- Antonim "pergi"
(4, 2, 2, 2, 2, 1, 51), -- datang
(4, 2, 2, 2, 2, 2, 52); -- tiba

-- Word relations untuk verba makan
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) VALUES 
-- Sinonim "makan"
(9, 2, 2, 1, 1, 1, 53), -- makan (base)
(9, 2, 2, 1, 1, 2, 54), -- santap (formal)
(9, 2, 2, 1, 1, 3, 55); -- lahap
