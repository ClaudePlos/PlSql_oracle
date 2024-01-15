# PlSql_oracle
-- add k.skworonski 2015-09-27
--* test

<pre>
 -- przeszukiwanie kodu jak księgować dany dokument
select ad_rdok_kod, AD_NAZWA, PAU_ID, PAU_AD_ID, PAU_TP_ID, PAU_NAZWA, PAU_UTWORZYL, PAU_KIEDY_UTWORZYL, PAU_MODYFIKOWAL 
from KGT_AUTOMATY_DEKRETUJACE, KGT_POZYCJE_AUTOMATU 
where AD_ID = pau_ad_id and PAU_KOD like '%KSOSOB%' 
</pre>

<pre>
 --001. good flash back
select * from nazwa_tabeli AS OF TIMESTAMP TO_TIMESTAMP('20-10-2010 12:47:00','dd-mm-yyyy hh24:mi:ss') --- dalej mozna podac whera
</pre>

<pre>
--004. Good search in package
SELECT DISTINCT owner, NAME, TYPE
FROM ( SELECT * FROM all_source WHERE UPPER(text) LIKE '%CSS_STOPY_ODSETKOWE%') 
</pre>

