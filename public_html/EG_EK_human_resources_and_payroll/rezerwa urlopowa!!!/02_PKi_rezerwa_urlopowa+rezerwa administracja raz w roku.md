<pre>




--2023-01-03


--- wykaz firm gdzie jest rezerwa administracja:
begin
eap_globals.USTAW_konsolidacje('T');
end;

select frm_nazwa, dok_numer_wlasny, dok_opis from kgt_dokumenty, eat_firmy 
where dok_frm_id = frm_id and dok_def_0 like 'REZ%' and upper(dok_opis) like '%ADMIN%' and to_char(dok_Data_zaksiegowania,'YYYY-MM') = '2021-12'
order by 1


select * from eat_firmy where frm_nazwa like '%Mark%'


-- W styczniu rezerwa jest robiona dla ADMINISTRACJI. 
1. ZAWIAZANIE - PK dodajemy na ostatni dzień starego roku. 

-- naprzod.NAP_EK_REZERWA.zawiaz_rezerwe_w_firmie
2. zmieniasz na czas generacjina != 
) where kontrybucja != 1 -- ustawienie aby tylko obiekty bez administracji
) where kontrybucja = 1 -- bez administracji 

i z akcji menu generujemy. 


ROZWIAZANIE TEZ ROBIMY w GRUDNIU za poprzedni rok: 
-- rozwiązanie trzeba zrobic z plsql bo moesiace zamkniete 
-- podaj frmId, dateksiegowania na miesiąc listopad tak by dokument zaksiegował sie w grudniu
-- idFirmy, daj na luty, idPK do rozwiązania, numer PK do rozwiązania
begin
 naprzod.NAP_EK_REZERWA.rozwiaz_rezerwe_w_firmie(300317, '2022-11-30', 12051328, 'PK/0105/12/21' ); 
end;

commit


2021:
JOL-MARK Sp. z o.o. PK/0120/12/21 PK/0121/12/21 i PK/0125/12/21 dla POSTĘP Sp. z o.o
NAPRZÓD SERVICE SP. Z O.O. PK/0061/12/21 PK/0062/12/21
Triomed Sp. z o.o.  PK/0104/12/21 PK/0105/12/21
NAPRZÓD CATERING SP. Z O.O. PK/0025/12/21 PK/0026/12/21
Naprzód Marketing PK/0080/12/21 PK/0081/12/21 i PK/0082/12/21 dla VENDI CLEANING SP. Z O.O. i PK/0083/12/21 dla Vendi Marketing Sp. z o.o.

 


CATERMED
HOSPITAL
IZAN


select * from kgt_dokumenty where dok_id = 12051512

update kgt_dokumenty set dok_frm_id = 300313  where dok_id = 12051512


select * from ek_zatrudnienie 

begin
eap_globals.USTAW_konsolidacje('T');
end;


-- założone rezerwy
select sum(ks_kwota) from kgt_ksiegowania where ks_dok_id in (
select dok_id from (

select dok_id, frm_nazwa, dok_numer_wlasny, dok_opis, dok_Data_zaksiegowania, dok_f_zatwierdzony 
 from kgt_dokumenty, eat_firmy
where upper(dok_opis) like '%REZERWA URLOPOWA%'
and to_char(dok_data_zaksiegowania,'YYYY-MM') = '2018-04'
and dok_f_zatwierdzony = 'T'
and dok_frm_id = frm_id
order by frm_nazwa


--and dok_frm_id = 300199
)) 

begin
eap_globals.USTAW_firme(300313);
eap_globals.USTAW_konsolidacje('N');
end;


select dok_def_0 from kgt_dokumenty where upper(dok_opis) like '%REZERWA URLOPOWA%'

UPDATE kgt_dokumenty SET dok_def_0 = 'REZ.URL.ZAWIAZANIE'  where upper(dok_opis) like '%REZERWA URLOPOWA%'


select dok_def_0, DOK_OPIS from kgt_dokumenty where upper(dok_opis) like '%ROZLICZENIE REZERWY%'

UPDATE kgt_dokumenty SET dok_def_0 = 'REZ.URL.ROZWIAZANIE'  where upper(dok_opis) like '%ROZLICZENIE REZERWY%'

COMMIT


</pre>
