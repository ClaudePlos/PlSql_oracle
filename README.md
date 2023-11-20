# PlSql_oracle
-- add k.skworonski 2015-09-27
--* test

<p>
 -- przeszukiwanie kodu jak księgować dany dokument
select ad_rdok_kod, AD_NAZWA, PAU_ID, PAU_AD_ID, PAU_TP_ID, PAU_NAZWA, PAU_UTWORZYL, PAU_KIEDY_UTWORZYL, PAU_MODYFIKOWAL 
from KGT_AUTOMATY_DEKRETUJACE, KGT_POZYCJE_AUTOMATU 
where AD_ID = pau_ad_id and PAU_KOD like '%KSOSOB%' 
</p>
