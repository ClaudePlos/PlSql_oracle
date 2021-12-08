### For Grupa Kapitałowa
<pre>
begin
eap_globals.USTAW_konsolidacje('T');
end;


select frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc
, (
select max(lst_data_wyplaty) from ek_dok_lst, ek_listy 
where dls_lst_id = lst_id
and dls_dok_id = dok_id
) data_wyplaty
, ks_dok_data_zaksiegowania 
, nvl(sum(WN),0) WN
, nvl(sum(MA),0) MA  
from 
(
select dok_id, frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc, ks_dok_data_zaksiegowania , ks_kwota WN, null  MA 
 from kgt_ksiegowania, kgt_dokumenty, kg_konta, eat_firmy
where ks_dok_id = dok_id 
and dok_frm_id = frm_id
and dok_data_zaksiegowania between :dataOd and :dataDo
and (ks_knt_wn = knt_id ) 
AND (ks_f_zaksiegowany = 'T' or ks_f_symulacja = 'T') 
and knt_pelny_numer like :konto
and dok_numer_wlasny not like 'BO%'
and frm_kl_id in (select ck_kl_kod from CKK_CECHY_KLIENTOW where ck_ce_id = 100603)-- grupa kapitałowa
union all 
select dok_id, frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc, ks_dok_data_zaksiegowania , null WN, ks_kwota  MA 
 from kgt_ksiegowania, kgt_dokumenty, kg_konta, eat_firmy 
where ks_dok_id = dok_id 
and dok_frm_id = frm_id
and dok_data_zaksiegowania between :dataOd and :dataDo
and (ks_knt_ma = knt_id ) 
AND (ks_f_zaksiegowany = 'T' or ks_f_symulacja = 'T') 
and knt_pelny_numer like :konto
and dok_numer_wlasny not like 'BO%'
and frm_kl_id in (select ck_kl_kod from CKK_CECHY_KLIENTOW where ck_ce_id = 100603)-- grupa kapitałowa
)
group by dok_id, frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc, ks_dok_data_zaksiegowania
order by frm_nazwa, ks_dok_data_zaksiegowania
</pre>
