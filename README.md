# Praktikum 6 SIG: Indexing Spasial dan Optimasi Query

**Sistem Informasi Geografis - Teknik Informatika**
**Institut Teknologi Sumatera (ITERA)**

**Disusun Oleh:** Anselmus Herpin Hasugian (123140020)
**Dosen Pengampu:** 
- Muhammad Habib Algifari, S.Kom., M.T.I.
- Alya Khairunnisa Rizkita, S.Kom., M.Kom.

---

## Deskripsi Singkat
Repositori ini berisi dokumentasi dan hasil analisis dari Praktikum 6 mata kuliah Sistem Informasi Geografis (SIG). Fokus utama pada praktikum ini adalah melakukan benchmarking performa database spasial (PostgreSQL/PostGIS) dan menerapkan teknik optimasi query menggunakan Spatial Index (GiST).

Proses pengujian membandingkan waktu eksekusi (Execution Time) dari operasi geometri (seperti pencarian radius, persinggungan garis, dan tumpang tindih poligon) sebelum dan sesudah indeks diterapkan.

## Tujuan Praktikum
1. Menganalisis pengaruh volume data spasial terhadap performa query.
2. Mempraktikkan pembuatan Spatial Index menggunakan metode GiST pada tipe geometri Point, LineString, dan Polygon.
3. Membedah rencana eksekusi (query plan) menggunakan perintah EXPLAIN ANALYZE.
4. Melakukan refactoring query lambat (anti-pattern) menjadi best practice menggunakan fungsi bounding box.
5. Menghitung persentase peningkatan performa (speedup) secara kuantitatif.

## Teknologi yang Digunakan
* Database: PostgreSQL
* Spatial Extension: PostGIS
* Tools: pgAdmin 4 / QGIS

## Ringkasan Hasil Optimasi (Speedup)
Penerapan GiST Index dan pembaruan statistik tabel (VACUUM ANALYZE) memberikan peningkatan kecepatan eksekusi (speedup) yang sangat signifikan pada database praktikum:
* Query Titik (Fasilitas Publik): Kecepatan meningkat hingga 72.27%
* Query Garis vs Poligon (Jalan): Kecepatan meningkat hingga 94.81%
* Query Poligon vs Poligon (Wilayah): Kecepatan meningkat hingga 99.46%

Selain itu, optimasi query dari penggunaan ST_Distance (Anti-pattern) menjadi ST_DWithin (Best practice yang memanfaatkan Two-Phase Filter & Bounding Box) terbukti memberikan speedup ekstra sebesar 99.3%.

---

## Dokumentasi Lengkap
Catatan Penting: Untuk informasi yang lebih komprehensif, detail query SQL yang dieksekusi, bukti tangkapan layar (screenshot) hasil EXPLAIN ANALYZE, serta analisis mendalam dari setiap tahapan, silakan merujuk pada file Laporan PDF yang terlampir di dalam repositori ini.
