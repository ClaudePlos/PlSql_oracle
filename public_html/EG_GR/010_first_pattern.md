<pre>
BEGIN

declare
v_frmSTART number;

begin

rollback;

v_frmSTART := eap_globals.ODCZYTAJ_FIRME;

begin
eap_globals.USTAW_konsolidacje('T');
end;

FOR x IN (
-- put here query
)
LOOP
insert into bctt_wyniki_raportow
(wr_pole_1_t, wr_pole_2_t, wr_pole_3_t, wr_pole_4_t, wr_pole_5_t, wr_pole_6_t, wr_pole_7_t)
values
(x.prc_id, x.prc_numer, x.prc_nazwisko, x.prc_imie, x.zat_status, x.sk_kod,x.zat_id);



END LOOP;


begin
eap_globals.USTAW_firme(v_frmSTART);
eap_globals.USTAW_konsolidacje('N');
end;


end;

open :kursor for 
select 
  wr_pole_2_t numer
, wr_pole_3_t nazwisko
, wr_pole_4_t imie
, wr_pole_5_t kod_zus
, wr_pole_6_t StanowiskoKosztow
, nvl(wr_pole_8_t,0) brutto_ZUS
, nvl(wr_pole_9_t,0) il_g_przep_mc 
, case when nvl(wr_pole_9_t,0)=0 then 0 else round(nvl(wr_pole_8_t,0)/nvl(wr_pole_9_t,0),2) end stawka_godz
, nvl(wr_pole_10_t,0) umowa_premie
, nvl(wr_pole_11_t,0) sod
, nvl(wr_pole_10_t,0)- nvl(wr_pole_11_t,0) dof_jako_potracenie 
from bctt_wyniki_raportow
order by wr_pole_3_t;

END;
</md>
