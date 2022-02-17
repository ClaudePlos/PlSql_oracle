<pre>
select frm_nazwa, dok_numer_wlasny
,  LISTAGG(lst_numer, ', ') WITHIN  GROUP (ORDER BY lst_numer) numer_list
, lst_data_obliczen, lst_data_wyplaty, dok_data_zaksiegowania, knt_pelny_numer, sum(ks_kwota) kwota 
 from ek_listy, ek_dok_lst, kgt_dokumenty, kgt_ksiegowania, kg_konta, eat_firmy
where dls_dok_id = dok_id
  and dls_lst_id = lst_id
  and ks_dok_id = dok_id
  and ks_frm_id = frm_id
  and dok_frm_id = frm_id
  and (ks_knt_wn = knt_id)  
  and to_char(lst_data_obliczen, 'YYYY-MM') = '2022-01'
  and knt_pelny_numer like '5%w03'
 group by  frm_nazwa, dok_numer_wlasny, lst_data_obliczen, lst_data_wyplaty, dok_data_zaksiegowania, knt_pelny_numer
 order by 1,2
 </pre>
