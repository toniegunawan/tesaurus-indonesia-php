# Tesaurus Indonesia - PHP 8.4

Aplikasi tesaurus untuk mencari sinonim dan antonim dalam bahasa Indonesia, dibangun dengan PHP 8.4 dan MySQL.

## Fitur

- 🔍 Pencarian sinonim dan antonim
- 🔤 Autocomplete untuk pencarian kata
- 📊 Statistik database tesaurus
- 🌐 REST API untuk integrasi
- 📱 Responsive web interface
- ⚡ Performa tinggi dengan PHP 8.4

## Struktur Database

Aplikasi ini menggunakan struktur database yang terdiri dari 8 tabel utama:

- `word_class` - Kelas kata (noun, verb, adjective, adverb)
- `type` - Tipe relasi (synonym, antonym, related)
- `lemma` - Kata dasar/lemma
- `word_relation` - Relasi antar kata (tabel utama)
- `label` - Label kata (formal, informal, dll)
- `article` - Artikel tesaurus
- `category` - Kategori kata
- `subcategory` - Sub-kategori kata

## Persyaratan Sistem

- PHP 8.4 atau lebih tinggi
- MySQL 5.7+ atau MariaDB 10.3+
- Apache/Nginx dengan mod_rewrite
- Ekstensi PHP: PDO, PDO_MySQL

## Instalasi

### 1. Clone atau Download Project

```bash
git clone <repository-url>
cd thesaurus-php
```

### 2. Setup Database

```bash
# Login ke MySQL
mysql -u root -p

# Import schema
mysql -u root -p < database/schema.sql
```

### 3. Konfigurasi Database

Edit file `src/Database/Connection.php` atau buat file `.env`:

```php
// Konfigurasi default di Connection.php
$host = 'localhost';
$dbname = 'thesaurus_db';
$username = 'root';
$password = '';
```

### 4. Setup Web Server

#### Apache
```apache
DocumentRoot /path/to/thesaurus-php/public
```

#### Nginx
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /path/to/thesaurus-php/public;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        try_files $uri /api.php$is_args$args;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_index api.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

#### PHP Built-in Server (Development)
```bash
cd public
php -S localhost:8000
```

## Penggunaan

### Web Interface

1. Buka browser dan akses `http://localhost:8000`
2. Masukkan kata yang ingin dicari
3. Lihat hasil sinonim dan antonim

### REST API

#### Endpoints

**1. Pencarian Kata**
```
GET /api/search?word=bahagia
```

Response:
```json
{
  "success": true,
  "data": {
    "word": "bahagia",
    "lemma": {
      "id": 1,
      "name": "bahagia",
      "name_tagged": "bahagia_adj",
      "label_name": "Standard"
    },
    "synonyms": [
      {
        "name": "gembira",
        "word_class": "Adjective",
        "word_class_abbr": "adj"
      }
    ],
    "antonyms": [
      {
        "name": "sedih",
        "word_class": "Adjective", 
        "word_class_abbr": "adj"
      }
    ],
    "related": []
  }
}
```

**2. Autocomplete**
```
GET /api/autocomplete?q=bah&limit=10
```

**3. Daftar Semua Kata**
```
GET /api/words?limit=100&offset=0
```

**4. Statistik**
```
GET /api/stats
```

### Contoh Penggunaan API dengan cURL

```bash
# Pencarian kata
curl "http://localhost:8000/api/search?word=senang"

# Autocomplete
curl "http://localhost:8000/api/autocomplete?q=sen&limit=5"

# Statistik
curl "http://localhost:8000/api/stats"
```

## Struktur Project

```
thesaurus-php/
├── config/
│   └── database.php          # Konfigurasi database
├── database/
│   └── schema.sql            # Schema database
├── public/
│   ├── .htaccess            # URL rewriting
│   ├── api.php              # Entry point API
│   └── index.html           # Web interface
├── src/
│   ├── Controllers/
│   │   └── ThesaurusController.php
│   ├── Database/
│   │   └── Connection.php
│   └── Services/
│       └── ThesaurusService.php
└── README.md
```

## Menambah Data

Untuk menambah data tesaurus, insert ke tabel-tabel berikut sesuai urutan:

1. `word_class` - Kelas kata
2. `type` - Tipe relasi
3. `label` - Label kata
4. `category` - Kategori
5. `subcategory` - Sub-kategori
6. `article` - Artikel
7. `lemma` - Kata dasar
8. `word_relation` - Relasi kata

Contoh:
```sql
-- Tambah lemma baru
INSERT INTO lemma (label_id, name, name_tagged) VALUES (1, 'indah', 'indah_adj');

-- Tambah relasi sinonim
INSERT INTO word_relation (article_id, par_num, wordclass_id, group_num, type_id, word_order, lemma_id) 
VALUES (1, 1, 3, 1, 1, 1, 10);
```

## Pengembangan

### Menambah Fitur Baru

1. Tambah method di `ThesaurusService.php`
2. Tambah endpoint di `ThesaurusController.php`
3. Update frontend di `index.html`

### Testing

```bash
# Test API endpoints
curl -X GET "http://localhost:8000/api/search?word=test"
curl -X GET "http://localhost:8000/api/stats"
```

## Troubleshooting

### Error Database Connection
- Pastikan MySQL berjalan
- Periksa kredensial database di `Connection.php`
- Pastikan database `thesaurus_db` sudah dibuat

### Error 404 API
- Pastikan mod_rewrite aktif di Apache
- Periksa file `.htaccess` di folder `public/`
- Untuk Nginx, pastikan konfigurasi URL rewriting benar

### Error PHP
- Pastikan PHP 8.4 terinstall
- Aktifkan ekstensi PDO dan PDO_MySQL
- Periksa error log PHP

## Kontribusi

1. Fork repository
2. Buat branch fitur (`git checkout -b fitur-baru`)
3. Commit perubahan (`git commit -am 'Tambah fitur baru'`)
4. Push ke branch (`git push origin fitur-baru`)
5. Buat Pull Request

## Lisensi

MIT License - lihat file LICENSE untuk detail.

## Kontak

Untuk pertanyaan atau dukungan, silakan buat issue di repository ini.
