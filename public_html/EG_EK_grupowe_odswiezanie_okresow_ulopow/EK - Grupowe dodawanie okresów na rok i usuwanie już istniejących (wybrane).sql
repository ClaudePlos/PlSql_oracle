BEGIN
eap_api_install.wykonaj_polecenie('
DECLARE
v_apl_id NUMBER;
BEGIN
v_apl_id := eap_api_install.id_apl(''EK'');
Cssp_Dmp.wstaw_ogr (
p_ogr_apl_id  => v_apl_id,
p_ogr_nazwa  =>''EK - Grupowe dodawanie okresów na rok i usuwanie już istniejących (wybrane)'',
p_ogr_f_ignoruj_bledy => ''N'',
p_ogr_plsql => ''DECLARE'' || CHR(10) || '''' ||
               ''   v_p0 VARCHAR2 (200) := :p0; --rok'' || CHR(10) || '''' ||
               ''   v_p1 VARCHAR2 (200) := :p1; --czy nadpisac'' || CHR(10) || '''' ||
               ''   v_p2 VARCHAR2 (200) := :p2; --rodzaj'' || CHR(10) || '''' ||
               ''   v_p3 VARCHAR2 (200) := :p3;'' || CHR(10) || '''' ||
               ''   v_p4 VARCHAR2 (200) := :p4;'' || CHR(10) || '''' ||
               ''   v_p5 VARCHAR2 (200) := :p5;'' || CHR(10) || '''' ||
               ''   v_p6 VARCHAR2 (200) := :p6;'' || CHR(10) || '''' ||
               ''   v_p7 VARCHAR2 (200) := :p7;'' || CHR(10) || '''' ||
               ''   v_p8 VARCHAR2 (200) := :p8;'' || CHR(10) || '''' ||
               ''   v_p9 VARCHAR2 (200) := :p9;'' || CHR(10) || '''' ||
               ''   v_rok NUMBER;'' || CHR(10) || '''' ||
               ''   v_czy_nadpisac VARCHAR2(3) := v_p1;'' || CHR(10) || '''' ||
               ''   v_pocz_roku DATE;'' || CHR(10) || '''' ||
               ''   CURSOR cu_prc IS'' || CHR(10) || '''' ||
               ''     SELECT DISTINCT zat_prc_id prc_id'' || CHR(10) || '''' ||
               ''         FROM ek_zatrudnienie--, ek_pracownicy'' || CHR(10) || '''' ||
               ''       WHERE zat_typ_umowy = 0'' || CHR(10) || '''' ||
               ''           AND zat_data_zmiany <= ek_pck_utl01.koniec_roku_z_daty (v_pocz_roku)'' || CHR(10) || '''' ||
               ''           AND NVL (zat_data_do, v_pocz_roku) >= v_pocz_roku;'' || CHR(10) || '''' ||
               ''BEGIN'' || CHR(10) || '''' ||
               ''   BEGIN'' || CHR(10) || '''' ||
               ''      v_rok :=  v_p0;'' || CHR(10) || '''' ||
               ''   EXCEPTION'' || CHR(10) || '''' ||
               ''     WHEN OTHERS THEN'' || CHR(10) || '''' ||
               ''        nzp_log.loguj(''''Wprowadź rok!'''');'' || CHR(10) || '''' ||
               ''        RETURN;'' || CHR(10) || '''' ||
               ''   END;'' || CHR(10) || '''' ||
               ''   --'' || CHR(10) || '''' ||
               ''   v_pocz_roku := ek_pck_utl01.numer_do_daty (1, 1, v_rok);'' || CHR(10) || '''' ||
               ''   --'' || CHR(10) || '''' ||
               ''   FOR i IN cu_prc LOOP'' || CHR(10) || '''' ||
               ''      nzp_log.loguj (''''Generacja limitów dla pracownika nr  ''''|| ek_pck_select.numer_pracownika (i.prc_id)|| ''''.'''');'' || CHR(10) || '''' ||
               ''      FOR k IN (SELECT rwy_dg_kod, rwy_f_rok'' || CHR(10) || '''' ||
               ''                  FROM ek_rodzaje_wymiarow'' || CHR(10) || '''' ||
               ''                 WHERE rwy_dg_kod IS NOT NULL'' || CHR(10) || '''' ||
               ''                   AND rwy_f_automatyczny = ''''T'''''' || CHR(10) || '''' ||
               ''                   AND rwy_kod LIKE v_p2) LOOP    '' || CHR(10) || '''' ||
               ''       IF ek_pck_limity.czy_limit_istnieje (i.prc_id, k.rwy_dg_kod, v_rok) THEN '' || CHR(10) || '''' ||
               ''          IF v_czy_nadpisac = ''''N'''' THEN'' || CHR(10) || '''' ||
               ''            nzp_log.loguj(''''  Dla pracownika nr ''''|| ek_pck_select.numer_pracownika (i.prc_id)|| '''' limit ''''|| k.rwy_dg_kod'' || CHR(10) || '''' ||
               ''               || '''' jest już wprowadzony. Limit nie bedzie nadpisany.'''');           '' || CHR(10) || '''' ||
               ''          ELSIF v_czy_nadpisac = ''''T'''' THEN'' || CHR(10) || '''' ||
               ''            BEGIN'' || CHR(10) || '''' ||
               ''               IF k.rwy_f_rok = ''''T'''' THEN'' || CHR(10) || '''' ||
               ''                  ek_pck_limity.przenies_na_nowy_rok ('' || CHR(10) || '''' ||
               ''                     p_prc_id => i.prc_id,'' || CHR(10) || '''' ||
               ''                     p_dg_kod => k.rwy_dg_kod,'' || CHR(10) || '''' ||
               ''                     p_rok => v_rok'' || CHR(10) || '''' ||
               ''                  );'' || CHR(10) || '''' ||
               ''               END IF;'' || CHR(10) || '''' ||
               ''               ek_pck_limity.uaktualnij_okres (p_prc_id => i.prc_id, p_data => v_pocz_roku, p_rwy_dg_kod => k.rwy_dg_kod);'' || CHR(10) || '''' ||
               ''               nzp_log.loguj(''''  Dla pracownika nr ''''|| ek_pck_select.numer_pracownika (i.prc_id)||'''' limit ''''|| k.rwy_dg_kod|| '''' był już wygenerowany i został zaktualizowany.'''');'' || CHR(10) || '''' ||
               ''             EXCEPTION WHEN OTHERS THEN'' || CHR(10) || '''' ||
               ''                eap_blad.zglos('' || CHR(10) || '''' ||
               ''                     p_procedura => ''''dodanie_limitow'''','' || CHR(10) || '''' ||
               ''                     p_nazwa => ''''EK-30180'''','' || CHR(10) || '''' ||
               ''                     p_p1 => ek_pck_select.numer_pracownika (i.prc_id),'' || CHR(10) || '''' ||
               ''                     p_p2 => v_rok,'' || CHR(10) || '''' ||
               ''                     p_p3 => k.rwy_dg_kod);'' || CHR(10) || '''' ||
               ''             END;'' || CHR(10) || '''' ||
               ''           END IF;'' || CHR(10) || '''' ||
               ''         ELSE  --nie istnieje limit'' || CHR(10) || '''' ||
               ''           BEGIN'' || CHR(10) || '''' ||
               ''               IF k.rwy_f_rok = ''''T'''' THEN'' || CHR(10) || '''' ||
               ''                  ek_pck_limity.przenies_na_nowy_rok ('' || CHR(10) || '''' ||
               ''                     p_prc_id => i.prc_id,'' || CHR(10) || '''' ||
               ''                     p_dg_kod => k.rwy_dg_kod,'' || CHR(10) || '''' ||
               ''                     p_rok => v_rok'' || CHR(10) || '''' ||
               ''                  );'' || CHR(10) || '''' ||
               ''               END IF;'' || CHR(10) || '''' ||
               ''               ek_pck_limity.nalicz_limit (p_prc_id => i.prc_id,'' || CHR(10) || '''' ||
               ''                  p_dg_kod => k.rwy_dg_kod, p_rok => v_rok);'' || CHR(10) || '''' ||
               ''               IF ek_pck_limity.czy_limit_istnieje (i.prc_id, k.rwy_dg_kod, v_rok) THEN '' || CHR(10) || '''' ||
               ''                 nzp_log.loguj(''''  Dla pracownika nr ''''|| ek_pck_select.numer_pracownika (i.prc_id)|| '''' limit ''''|| k.rwy_dg_kod'' || CHR(10) || '''' ||
               ''                  || '''' został wygenerowany.'''');'' || CHR(10) || '''' ||
               ''               ELSE'' || CHR(10) || '''' ||
               ''                 nzp_log.loguj(''''  Dla pracownika nr ''''|| ek_pck_select.numer_pracownika (i.prc_id)|| '''' limit ''''|| k.rwy_dg_kod'' || CHR(10) || '''' ||
               ''                  || '''' nie został wygenerowany. Sprawdź czy przysługuje pracownikowi (oświadczenia, wartości domyślne).'''');'' || CHR(10) || '''' ||
               ''               END IF;'' || CHR(10) || '''' ||
               ''            EXCEPTION'' || CHR(10) || '''' ||
               ''               WHEN OTHERS THEN'' || CHR(10) || '''' ||
               ''                  eap_blad.zglos('' || CHR(10) || '''' ||
               ''                     p_procedura => ''''dodanie_limitow'''','' || CHR(10) || '''' ||
               ''                     p_nazwa => ''''EK-30180'''','' || CHR(10) || '''' ||
               ''                     p_p1 => ek_pck_select.numer_pracownika (i.prc_id),'' || CHR(10) || '''' ||
               ''                     p_p2 => v_rok,'' || CHR(10) || '''' ||
               ''                     p_p3 => k.rwy_dg_kod);'' || CHR(10) || '''' ||
               ''           END;'' || CHR(10) || '''' ||
               ''         END IF;'' || CHR(10) || '''' ||
               ''      END LOOP;'' || CHR(10) || '''' ||
               ''   END LOOP;'' || CHR(10) || '''' ||
               ''END;'',
p_ogr_krs_id => '''',
p_ogr_lst_id => '''',
p_ogr_kolumna_klucza => ''''
  );
  COMMIT;
END;',
'CSS_OPERACJE_GRUPOWE',
'Operacja grupowa <EK - Grupowe dodawanie okresów na rok i usuwanie już istniejących (wybrane)>');
END;
/
BEGIN
eap_api_install.wykonaj_polecenie('
DECLARE
v_ogr_id NUMBER;
v_lst_id NUMBER;
BEGIN
SELECT ogr_id
  INTO  v_ogr_id
  FROM CSS_OPERACJE_GRUPOWE
 WHERE ogr_nazwa LIKE ''EK - Grupowe dodawanie okresów na rok i usuwanie już istniejących (wybrane)'';
BEGIN
SELECT lst_id 
  INTO v_lst_id 
  FROM eat_listy 
 WHERE lst_nazwa = ''''
   AND lst_lp = 1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
v_lst_id := NULL;
END;
Cssp_Dmp.wstaw_pog (
p_pog_lp  =>''1'',
p_pog_nazwa  =>''Rok (YYYY)'',
p_pog_f_walidacja => ''N'',
p_pog_ogr_id => v_ogr_id,
p_pog_plsql_walidacji => '''',
p_pog_f_multilista => ''N'',
p_pog_lst_nazwa => '''',
p_pog_lst_lp_kod => '''',
p_pog_lst_lp_opis => '''',
p_pog_plsql_wart_dom => ''begin'' || CHR(10) || '''' ||
                        '' :WARTOSC := ''''W'''';'' || CHR(10) || '''' ||
                        '' :OPIS := ''''Wprowadź rok'''';'' || CHR(10) || '''' ||
                        ''end;'',
p_pog_warunek_listy => '''',
p_pog_sep_multi => ''0'',
p_pog_lst_id => v_lst_id
  );
  COMMIT;
END;',
'CSS_PARAMETRY_OPERACJI',
'Parametry operacji grupowej');
END;
/
BEGIN
eap_api_install.wykonaj_polecenie('
DECLARE
v_ogr_id NUMBER;
v_lst_id NUMBER;
BEGIN
SELECT ogr_id
  INTO  v_ogr_id
  FROM CSS_OPERACJE_GRUPOWE
 WHERE ogr_nazwa LIKE ''EK - Grupowe dodawanie okresów na rok i usuwanie już istniejących (wybrane)'';
BEGIN
SELECT lst_id 
  INTO v_lst_id 
  FROM eat_listy 
 WHERE lst_nazwa = ''''
   AND lst_lp = 1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
v_lst_id := NULL;
END;
Cssp_Dmp.wstaw_pog (
p_pog_lp  =>''2'',
p_pog_nazwa  =>''Czy nadpisywać limity?'',
p_pog_f_walidacja => ''T'',
p_pog_ogr_id => v_ogr_id,
p_pog_plsql_walidacji => '''',
p_pog_f_multilista => ''N'',
p_pog_lst_nazwa => ''TAK_NIE'',
p_pog_lst_lp_kod => ''1'',
p_pog_lst_lp_opis => ''2'',
p_pog_plsql_wart_dom => ''begin'' || CHR(10) || '''' ||
                        '' :WARTOSC := ''''N'''';'' || CHR(10) || '''' ||
                        '' :OPIS := ''''Nie'''';'' || CHR(10) || '''' ||
                        ''end;'',
p_pog_warunek_listy => '''',
p_pog_sep_multi => ''0'',
p_pog_lst_id => v_lst_id
  );
  COMMIT;
END;',
'CSS_PARAMETRY_OPERACJI',
'Parametry operacji grupowej');
END;
/
BEGIN
eap_api_install.wykonaj_polecenie('
DECLARE
v_ogr_id NUMBER;
v_lst_id NUMBER;
BEGIN
SELECT ogr_id
  INTO  v_ogr_id
  FROM CSS_OPERACJE_GRUPOWE
 WHERE ogr_nazwa LIKE ''EK - Grupowe dodawanie okresów na rok i usuwanie już istniejących (wybrane)'';
BEGIN
SELECT lst_id 
  INTO v_lst_id 
  FROM eat_listy 
 WHERE lst_nazwa = ''''
   AND lst_lp = 1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
v_lst_id := NULL;
END;
Cssp_Dmp.wstaw_pog (
p_pog_lp  =>''3'',
p_pog_nazwa  =>''Rodzaj limitu'',
p_pog_f_walidacja => ''T'',
p_pog_ogr_id => v_ogr_id,
p_pog_plsql_walidacji => '''',
p_pog_f_multilista => ''N'',
p_pog_lst_nazwa => ''EK_WYMIARY_DST'',
p_pog_lst_lp_kod => ''1'',
p_pog_lst_lp_opis => ''1'',
p_pog_plsql_wart_dom => ''begin'' || CHR(10) || '''' ||
                        '' :WARTOSC := ''''%'''';'' || CHR(10) || '''' ||
                        '' :OPIS := ''''%'''';'' || CHR(10) || '''' ||
                        ''end;'',
p_pog_warunek_listy => ''AND rwy_dg_kod IS NOT NULL AND rwy_f_automatyczny = ''''T'''''',
p_pog_sep_multi => ''0'',
p_pog_lst_id => v_lst_id
  );
  COMMIT;
END;',
'CSS_PARAMETRY_OPERACJI',
'Parametry operacji grupowej');
END;
/
