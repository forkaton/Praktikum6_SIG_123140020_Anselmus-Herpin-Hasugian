-- =========================================================================
-- PRAKTIKUM 6 SIG - INDEXING SPASIAL DAN OPTIMASI QUERY
-- Nama: Anselmus Herpin Hasugian (123140020)
-- =========================================================================

-- -------------------------------------------------------------------------
-- TAHAP 1: BENCHMARK AWAL (BEFORE INDEXING / SEQUENTIAL SCAN)
-- -------------------------------------------------------------------------

-- 1. Query Jarak Radius (Fasilitas Publik)
EXPLAIN ANALYZE 
SELECT a.nama, b.nama 
FROM fasilitas_publik a, fasilitas_publik b 
WHERE ST_DWithin(a.geom::geography, b.geom::geography, 1000) 
  AND a.id != b.id;

-- 2. Query Persinggungan (Jalan vs Wilayah)
EXPLAIN ANALYZE 
SELECT j.nama 
FROM jalan j, wilayah w 
WHERE w.nama = 'Kelurahan Way Hui' 
  AND ST_Intersects(j.geom, w.geom);

-- 3. Query Tumpang Tindih (Wilayah vs Wilayah)
EXPLAIN ANALYZE 
SELECT w1.nama, w2.nama 
FROM wilayah w1, wilayah w2 
WHERE ST_Intersects(w1.geom, w2.geom) 
  AND w1.id != w2.id;


-- -------------------------------------------------------------------------
-- TAHAP 2: PEMBUATAN SPATIAL INDEX (GIST)
-- -------------------------------------------------------------------------

-- Membuat R-Tree Index
CREATE INDEX idx_fasilitas_geom ON fasilitas_publik USING GIST (geom);
CREATE INDEX idx_jalan_geom ON jalan USING GIST (geom);
CREATE INDEX idx_wilayah_geom ON wilayah USING GIST (geom);

-- Memperbarui statistik database agar menggunakan indeks
VACUUM ANALYZE fasilitas_publik;
VACUUM ANALYZE jalan;
VACUUM ANALYZE wilayah;


-- -------------------------------------------------------------------------
-- TAHAP 3: BENCHMARK AKHIR (AFTER INDEXING / INDEX SCAN)
-- -------------------------------------------------------------------------
-- (Jalankan ulang ketiga query dari Tahap 1 untuk melihat perbedaan waktu)


-- -------------------------------------------------------------------------
-- TAHAP 4: OPTIMASI QUERY LAMBAT (ANTI-PATTERN VS BEST PRACTICE)
-- -------------------------------------------------------------------------

-- 1. Query Lambat (Anti-Pattern menggunakan ST_Distance)
EXPLAIN ANALYZE 
SELECT f1.nama, f2.nama 
FROM fasilitas_publik f1, fasilitas_publik f2
WHERE f1.nama ILIKE '%Rumah Sakit%' 
  AND ST_Distance(f1.geom::geography, f2.geom::geography) < 1000 
  AND f1.id != f2.id;

-- 2. Query Cepat (Best Practice menggunakan ST_DWithin / Bounding Box)
EXPLAIN ANALYZE 
SELECT f1.nama, f2.nama 
FROM fasilitas_publik f1, fasilitas_publik f2
WHERE f1.nama ILIKE '%Rumah Sakit%' 
  AND ST_DWithin(f1.geom::geography, f2.geom::geography, 1000) 
  AND f1.id != f2.id;