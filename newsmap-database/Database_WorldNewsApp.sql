-- 0) usa lo schema
CREATE DATABASE IF NOT EXISTS newsmapdb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE newsmapdb;

-- 1) Tabella country (PK = iso_code)
CREATE TABLE country (
  iso_code CHAR(2) NOT NULL,     -- ISO 3166-1 alpha-2 (IT, US, FR, ...)
  name VARCHAR(150) NOT NULL,
  region VARCHAR(100),
  lat DECIMAL(9,6),              -- centroide (opzionale)
  lon DECIMAL(9,6),
  timezone VARCHAR(50),
  inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (iso_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2) Fonte/Source (es. NewsAPI, BBC, Reuters)
CREATE TABLE source (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  external_source_id VARCHAR(255), -- id dell'API se presente
  url VARCHAR(500),
  description TEXT,
  inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_source_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3) News (articoli)
CREATE TABLE news (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  source_id BIGINT NOT NULL,
  external_id VARCHAR(255),      -- id dell'articolo fornito dall'API (se disponibile)
  title VARCHAR(1000) NOT NULL,
  description TEXT,
  url VARCHAR(1000) NOT NULL,
  url_to_image VARCHAR(1000),
  content LONGTEXT,
  language VARCHAR(10),
  category VARCHAR(100),
  published_at DATETIME,        -- data pubblicazione dell'articolo
  fetched_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- quando lo abbiamo prelevato
  popularity_score DOUBLE DEFAULT 0,
  inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_news_source FOREIGN KEY (source_id) REFERENCES source(id) ON DELETE CASCADE,
  UNIQUE KEY uq_news_source_ext (source_id, external_id),
  UNIQUE KEY uq_news_url (url(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4) Relazione many-to-many news <-> country
CREATE TABLE news_country (
  news_id BIGINT NOT NULL,
  country_iso CHAR(2) NOT NULL,
  PRIMARY KEY (news_id, country_iso),
  CONSTRAINT fk_nc_news FOREIGN KEY (news_id) REFERENCES news(id) ON DELETE CASCADE,
  CONSTRAINT fk_nc_country FOREIGN KEY (country_iso) REFERENCES country(iso_code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5) Tags e relazione news_tag (opzionale ma utile)
CREATE TABLE tag (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE news_tag (
  news_id BIGINT NOT NULL,
  tag_id BIGINT NOT NULL,
  PRIMARY KEY (news_id, tag_id),
  CONSTRAINT fk_nt_news FOREIGN KEY (news_id) REFERENCES news(id) ON DELETE CASCADE,
  CONSTRAINT fk_nt_tag FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6) Users (se prevedi autenticazione)
CREATE TABLE app_user (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'USER',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7) Preferenze / favorite countries per utente
CREATE TABLE user_favorite_country (
  user_id BIGINT NOT NULL,
  country_iso CHAR(2) NOT NULL,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, country_iso),
  CONSTRAINT fk_ufc_user FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE,
  CONSTRAINT fk_ufc_country FOREIGN KEY (country_iso) REFERENCES country(iso_code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8) Cache raw (opzionale): memorizza JSON raw della risposta API per TTL
CREATE TABLE news_cache (
  cache_key VARCHAR(255) PRIMARY KEY,
  response_json LONGTEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9) Indici utili
CREATE INDEX idx_news_published_at ON news (published_at);
CREATE INDEX idx_news_fetched_at ON news (fetched_at);
CREATE INDEX idx_news_source_id ON news (source_id);
CREATE INDEX idx_news_language ON news (language);

-- FULLTEXT per ricerca (MySQL supporta FULLTEXT su InnoDB)
CREATE FULLTEXT INDEX ft_idx_news_title_description ON news (title, description);
