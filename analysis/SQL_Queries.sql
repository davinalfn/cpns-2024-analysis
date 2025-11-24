create database formasi_cpns_2024;
use formasi_cpns_2024;

CREATE TABLE formasi_cpns (
    formation_id VARCHAR(150),
    agency VARCHAR(500),
    admission_path VARCHAR(200),
    formation_category VARCHAR(200),
    position VARCHAR(500),
    location VARCHAR(500),  
    num_of_formation INT,
    allow_disability BOOLEAN,
    minimum_salary_idr DECIMAL(15,2),
    maximum_salary_idr DECIMAL(15,2),
    education_code VARCHAR(100),
    education_major VARCHAR(500),  
    education_level_id INT,
    education_level VARCHAR(200)
);

-- Cek total data
select 'TOTAL DATA' as info, count(*) as jumlah from formasi_cpns;

-- Preview data
select * from formasi_cpns limit 10;

-- Cek struktur tabel
describe formasi_cpns;


-- CEK DATA QUALITY
-- Cek data kosong kolom penting
SELECT 'DATA KOSONG - agency' as cek,
       count(*) as total_data,
       sum(agency IS NULL OR agency = '') as data_kosong
FROM formasi_cpns;

SELECT 'DATA KOSONG - num_of_formation' as cek,
       count(*) as total_data,
       sum(num_of_formation IS NULL) as data_kosong
FROM formasi_cpns;

SELECT 'DATA KOSONG - minimum_salary_idr' as cek,
       count(*) as total_data,
       sum(minimum_salary_idr IS NULL) as data_kosong
FROM formasi_cpns;


-- Cek range nilai 
SELECT 'KUOTA FORMASI' as jenis,
       MIN(num_of_formation) as terkecil,
       MAX(num_of_formation) as terbesar,
       AVG(num_of_formation) as rata_rata
FROM formasi_cpns;

SELECT 'GAJI MAXIMUM' as jenis,
       MIN(maximum_salary_idr) as terkecil,
       MAX(maximum_salary_idr) as terbesar,
       AVG(maximum_salary_idr) as rata_rata
FROM formasi_cpns;



-- BASIC ANALISIS FORMASI
use formasi_cpns_2024;

-- 1. Overview
select 'STATISTIK UMUM' as judul;
select 
	count(*) as total_formasi,
	count(distinct agency) as jumlah_instansi,
	sum(num_of_formation) as total_kuota_nasional
from formasi_cpns;

-- 2. Instansi dengan formasi terbanyak
select 'TOP 10 INSTANSI' as judul;
select 
	agency as nama_instansi,
	count(*) as jumlah_formasi,
	sum(num_of_formation) as total_kuota
from formasi_cpns
group by agency
order by total_kuota desc
limit 10;

-- 3. Lokasi dengan formasi terbanyak
select'TOTAL 10 LOKASI' as judul;
select 
	location as nama_lokasi,
	count(*) as jumlah_formasi,
	sum(num_of_formation) as total_kuota
from formasi_cpns
group by location
order by total_kuota desc
limit 10;

-- 4. Tingkat pendidikan yang dicari
select 'FORMASI PER PENDIDIKAN' as judul;
select
	education_level as tingkat_pendidikan,
	count(*) as jumlah_formasi,
	sum(num_of_formation) as total_kuota
from formasi_cpns
group by education_level
order by total_kuota desc;

-- 5. Gaji rata-rata per pendidikan
select 'GAJI PER PENDIDIKAN' as judul;
select
	education_level as tingkat_pendidikan,
	avg(minimum_salary_idr) as gaji_minimum_rata,
	avg(maximum_salary_idr) as gaji_maximum_rata
from formasi_cpns
group by education_level
order by gaji_maximum_rata desc;

-- 6. Formasi untuk disabilitas
select 'FORMASI DISABILITAS' as judul;
select 
case
	when allow_disability = 1 then 'Ada formasi disabilitas'
	else 'Tidak ada formasi disabilitas'
	end as status_disabilitas,
	count(*) as jumlah_formasi,
	sum(num_of_formation) as total_kuota
	from formasi_cpns
	group by allow_disability;


-- Views for Power BI

create view vw_dashboard_simple as
select
	agency as instansi,
	position as jabatan,
	location as lokasi,
	num_of_formation as kuota,
	minimum_salary_idr as gaji_minimum,
	maximum_salary_idr as gaji_maximum,
	education_level as pendidikan,
	allow_disability as disabilitas
from formasi_cpns;

SELECT * FROM formasi_cpns_2024.vw_dashboard_simple;	









