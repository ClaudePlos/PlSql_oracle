### k.skowronski(ClaudePlos) add 2016-10-17
### report about accountiong on the accounts in multi-firm 

<pre>
select frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc, ks_dok_data_zaksiegowania 
, nvl(sum(WN),0) WN
, nvl(sum(MA),0) MA  
from 
(
select frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc, ks_dok_data_zaksiegowania , ks_kwota WN, null  MA 
 from kgt_ksiegowania, kgt_dokumenty, kg_konta, eat_firmy 
where ks_dok_id = dok_id 
and dok_frm_id = frm_id
and dok_data_zaksiegowania between :dataOd and :dataDo
and (ks_knt_wn = knt_id ) 
AND (ks_f_zaksiegowany = 'T' or ks_f_symulacja = 'T') 
and knt_pelny_numer like :konto
and dok_numer_wlasny not like 'BO%'
union all 
select frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc, ks_dok_data_zaksiegowania , null WN, ks_kwota  MA 
 from kgt_ksiegowania, kgt_dokumenty, kg_konta, eat_firmy 
where ks_dok_id = dok_id 
and dok_frm_id = frm_id
and dok_data_zaksiegowania between :dataOd and :dataDo
and (ks_knt_ma = knt_id ) 
AND (ks_f_zaksiegowany = 'T' or ks_f_symulacja = 'T') 
and knt_pelny_numer like :konto
and dok_numer_wlasny not like 'BO%'
)
group by frm_nazwa, knt_pelny_numer, knt_nazwa, ks_tresc, ks_dok_data_zaksiegowania
order by frm_nazwa, ks_dok_data_zaksiegowania
</pre>
