# 2021-09-01

begin
eap_globals.USTAW_konsolidacje('T');
end;

-- workers who earn lower then min 
select a.*, 2800*etat min_etat from (
SELECT frm_nazwa, sk_kod||' '||sk_opis sk_kod, prc_numer, prc_nazwisko, prc_imie, zat_stawka
, (select SUBSTR(wsl_alias,1,3)/SUBSTR(wsl_alias,4,6) from css_wartosci_slownikow where wsl_sl_nazwa like 'TYP_ETATU' and zat_wymiar=wsl_wartosc) etat
FROM ek_zatrudnienie, ek_pracownicy, css_stanowiska_kosztow, eat_firmy 
WHERE prc_id = zat_prc_id 
and zat_frm_id = frm_id
AND zat_typ_umowy = 0
and zat_sk_id = sk_id 
AND zat_data_zmiany <= :in_day
AND NVL(zat_data_do, :in_day) >= :in_day
order by PRC_NUMER ASC, PRC_NAZWISKO ASC, PRC_IMIE ASC) a
where zat_stawka < 2800*etat
order by frm_nazwa, sk_kod,  prc_nazwisko, prc_imie


# 2019 - last from EK form employees who works on foll time job

SELECT * FROM ek_zatrudnienie, ek_pracownicy
WHERE prc_id = zat_prc_id 
AND zat_typ_umowy = 0
AND zat_data_zmiany <= :in_day
AND NVL(zat_data_do, :in_day) >= :in_day
order by PRC_NUMER ASC, PRC_NAZWISKO ASC, PRC_IMIE ASC


# 2018
--ETAT: dodaj jako kolumna w select 
, (select SUBSTR(wsl_alias,1,3)/SUBSTR(wsl_alias,4,6) from css_wartosci_slownikow where wsl_sl_nazwa like 'TYP_ETATU' and zat_wymiar=wsl_wartosc) etat

-- dokładnie il prac w firmie
select frm_nazwa, ob_pelny_kod, typ_umowy, count(prc_id) prac from (
--- na UZ
SELECT distinct PRC_ID,PRC_NUMER,PRC_NAZWISKO,PRC_IMIE,PRC_NIP,PRC_DATA_UR,PRC_PESEL,PRC_DOWOD_OSOB, frm_nazwa, ob_pelny_kod
, (select wsl_alias from CSS_WARTOSCI_SLOWNIKOW where wsl_sl_nazwa = 'TYP_UMOWY' and wsl_wartosc = zat_typ_umowy) typ_umowy
 FROM EK_PRACOWNICY, ek_zatrudnienie, css_Stanowiska_kosztow, css_obiekty_w_przedsieb, css_stanowiska_obiekty, eat_firmy  
WHERE zat_prc_id = prc_id
and zat_sk_id = sk_id
and zat_frm_id = frm_id
and so_sk_id = sk_id
and so_ob_id = ob_id
and zat_id in (
  SELECT zat_id FROM ek_zatrudnienie
  WHERE prc_id = zat_prc_id 
  AND ( zat_typ_umowy in (1,2,3,10) ) -- uz
  AND zat_data_zmiany <= :data_od AND NVL(zat_data_do, sysdate) >= :data_do)
union all 
-- na UP
SELECT distinct PRC_ID,PRC_NUMER,PRC_NAZWISKO,PRC_IMIE,PRC_NIP,PRC_DATA_UR,PRC_PESEL,PRC_DOWOD_OSOB, frm_nazwa, ob_pelny_kod
, (select wsl_alias from CSS_WARTOSCI_SLOWNIKOW where wsl_sl_nazwa = 'TYP_UMOWY' and wsl_wartosc = zat_typ_umowy) typ_umowy
 FROM EK_PRACOWNICY, ek_zatrudnienie, css_Stanowiska_kosztow, css_obiekty_w_przedsieb, css_stanowiska_obiekty, eat_firmy  
WHERE zat_prc_id = prc_id
and zat_sk_id = sk_id
and zat_frm_id = frm_id
and so_sk_id = sk_id
and so_ob_id = ob_id
    AND zat_id in( SELECT zat_id FROM ek_zatrudnienie 
    WHERE prc_id = zat_prc_id 
    AND zat_typ_umowy in (0,7) 
    AND :data_od BETWEEN zat_data_zmiany AND NVL(zat_data_do, :data_do)) 
order by PRC_numer
)
group by ob_pelny_kod, frm_nazwa, typ_umowy
order by frm_nazwa, ob_pelny_kod, typ_umowy 






-- add k.skowronski 2005

-- 0 UP
-- 1 Dzielo
-- 2 Zlecenie 

----- 1. 
----- number of employees (contract)
select count(*) from ek_pracownicy, ek_zatrudnienie 
where zat_prc_id=prc_id
and ek_zatrudnienie.zat_data_zmiany = (
	 select max(zat_data_zmiany) from ek_zatrudnienie 
	 where zat_prc_id = prc_id
	 and zat_typ_umowy = 0 
	 and zat_data_zmiany <= last_day(to_date(:data_do,'MM-YYYY') ))
	 --
	 and (ek_zatrudnienie.zat_data_do >= to_date(:data_do,'MM-YYYY')
	 or ek_zatrudnienie.zat_data_do is null)
	 and zat_typ_umowy = 0

-- shorter version  - KS 2012-06-26
-- 2018-05-09 -- najlepiej zbiera dane !!!!! to zapytanie 
select count(distinct prc_id) from ek_zatrudnienie, ek_pracownicy where
(NVL(zat_data_do, to_date('2099', 'YYYY')) >= to_date('2012-01', 'YYYY-MM')
and zat_data_zmiany <= last_day(to_date('2012-01', 'YYYY-MM')))
and zat_typ_umowy = 0
and zat_prc_id = prc_id;

--- all company - etaty - obKod - on day
begin
eap_globals.USTAW_konsolidacje('T');
end;


select ob_pelny_kod, sum(SUBSTR(wsl_alias,1,3)/SUBSTR(wsl_alias,4,6)) etat from ek_pracownicy, ek_zatrudnienie, css_Stanowiska_kosztow, css_obiekty_w_przedsieb, css_stanowiska_obiekty, eat_firmy,
(select wsl_wartosc, wsl_wartosc_max, wsl_alias from css_wartosci_slownikow where wsl_sl_nazwa like 'TYP_ETATU') etat
where zat_prc_id=prc_id
and zat_sk_id = sk_id
and zat_frm_id = frm_id
and so_sk_id = sk_id
and so_ob_id = ob_id
and zat_wymiar=wsl_wartosc
and sk_kod = 'Z062'
and ek_zatrudnienie.zat_data_zmiany = (
	 select max(zat_data_zmiany) from ek_zatrudnienie 
	 where zat_prc_id = prc_id
	 and zat_typ_umowy = 0 
	 and zat_data_zmiany <= :na_dzien) -- ewent. do
	 --
	 and (ek_zatrudnienie.zat_data_do >= :na_dzien -- ewent. od
	 or ek_zatrudnienie.zat_data_do is null)
	 and zat_typ_umowy = 0
group by ob_pelny_kod

---***********************************************************************
-- 2. 
-- number of employees (freelance)
select * from ek_zatrudnienie, ek_pracownicy, ek_etapy_umowy  where
(NVL(zat_data_do, to_date('2099', 'YYYY')) >= to_date('2014-03', 'YYYY-MM')
and zat_data_zmiany <= last_day(to_date('2014-03', 'YYYY-MM')))
and zat_typ_umowy != 0  -- 6 o współpracę 
and eu_Zat_id = zat_id
and eu_miesiac = '2014-03-01'
and zat_prc_id = prc_id;



-- without stage agreement

	 SELECT prc_numer,  prc_nazwisko,  prc_imie, sk_kod , sk_opis, zat_stawka, zat_data_przyj, zat_data_zmiany, zat_data_do, zat_temat
	 , (select frm_nazwa from eat_firmy where frm_id = zat_frm_id) frm
	 FROM EK_PRACOWNICY, ek_zatrudnienie, css_Stanowiska_kosztow 
	 WHERE zat_prc_id = prc_id
	 and sk_id = zat_sk_id
	 AND ( (zat_typ_umowy in (1,2,3,10))) AND zat_data_zmiany <= :ddo AND NVL(zat_data_do, '2099-01-01') >= :dod
	 order by sk_kod, prc_nazwisko, zat_data_zmiany


--***************************************************************************
--- Umowy o pracę - wielofirmowo - etaty - obKod - na dzien
begin
eap_globals.USTAW_konsolidacje('T');
end;


select ob_pelny_kod, sum(SUBSTR(wsl_alias,1,3)/SUBSTR(wsl_alias,4,6)) etat from ek_pracownicy, ek_zatrudnienie, css_Stanowiska_kosztow, css_obiekty_w_przedsieb, css_stanowiska_obiekty, eat_firmy,
(select wsl_wartosc, wsl_wartosc_max, wsl_alias from css_wartosci_slownikow where wsl_sl_nazwa like 'TYP_ETATU') etat
where zat_prc_id=prc_id
and zat_sk_id = sk_id
and zat_frm_id = frm_id
and so_sk_id = sk_id
and so_ob_id = ob_id
and zat_wymiar=wsl_wartosc
and sk_kod = 'Z062'
and ek_zatrudnienie.zat_data_zmiany = (
	 select max(zat_data_zmiany) from ek_zatrudnienie 
	 where zat_prc_id = prc_id
	 and zat_typ_umowy = 0 
	 and zat_data_zmiany <= :na_dzien) -- ewent. do
	 --
	 and (ek_zatrudnienie.zat_data_do >= :na_dzien -- ewent. od
	 or ek_zatrudnienie.zat_data_do is null)
	 and zat_typ_umowy = 0
group by ob_pelny_kod




--- wyliczanie etatów rocznie - GOOD
declare 
v_mm varchar2(2);
v_txt varchar2(4000);
begin
--
for r1 in
(
	select ob_pelny_kod from css_obiekty_w_przedsieb
	where ob_stan_definicji = 'Z'
	and (ob_pelny_kod like '00-%' or ob_pelny_kod = '00')
	order by ob_pelny_kod
)
LOOP --start1
v_txt := r1.ob_pelny_kod||';';
----
FOR r2 IN 1..12
LOOP --start2
v_mm := substr('0'||r2,-2);
--
for rek in (
select ob_pelny_kod, sum(SUBSTR(wsl_alias,1,3)/SUBSTR(wsl_alias,4,6)) etat 
from ek_pracownicy, ek_zatrudnienie, css_Stanowiska_kosztow, css_obiekty_w_przedsieb, css_stanowiska_obiekty, eat_firmy,
(select wsl_wartosc, wsl_wartosc_max, wsl_alias from css_wartosci_slownikow where wsl_sl_nazwa like 'TYP_ETATU') etat
where zat_prc_id=prc_id
and zat_sk_id = sk_id
and zat_frm_id = frm_id
and so_sk_id = sk_id
and so_ob_id = ob_id
and zat_wymiar=wsl_wartosc
and ek_zatrudnienie.zat_data_zmiany = (
	 select max(zat_data_zmiany) from ek_zatrudnienie 
	 where zat_prc_id = prc_id
	 and zat_typ_umowy = 0 
	 and zat_data_zmiany <= last_day(to_date(:rok||'-'||v_mm,'YYYY-MM'))) -- ewent. do
	 --
	 and (ek_zatrudnienie.zat_data_do >= to_date(:rok||'-'||v_mm,'YYYY-MM') -- ewent. od
	 or ek_zatrudnienie.zat_data_do is null)
	 and zat_typ_umowy = 0
	 and ob_pelny_kod = r1.ob_pelny_kod
group by ob_pelny_kod
)
loop
v_txt := v_txt||rek.etat||';';
end loop; 
END LOOP;--end2;
--
 dbms_output.put_line (v_txt);
--
END LOOP; --end1
end;
