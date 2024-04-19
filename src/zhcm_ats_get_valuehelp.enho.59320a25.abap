"Name: \FU:HCM_ATS_GET_VALUEHELP\SE:END\EI
ENHANCEMENT 0 ZHCM_ATS_GET_VALUEHELP.
*BTBOUNDY
  DATA: ls_aufk TYPE aufk,
        lv_text LIKE ls_aufk-ktext.

  CASE ls_fieldinfo-fieldname.
    WHEN 'RAUFNR'.
      CLEAR et_valuehelp.
      SELECT SINGLE aufk~aufnr aufk~kokrs aufk~ktext aufk~auart aufk~autyp
        FROM aufk INNER JOIN t003o ON aufk~auart = t003o~auart
        INTO CORRESPONDING FIELDS OF ls_aufk
        WHERE ( t003o~autyp = '01' OR t003o~autyp = '30' )
          AND aufk~aufnr = iv_search_string
          AND aufk~kokrs = lv_kokrs.
      CLEAR ls_picklist.
      ls_picklist-field_id = ls_aufk-aufnr.
      SHIFT ls_aufk-aufnr LEFT DELETING LEADING '0'.
      CONCATENATE ls_aufk-ktext '(' ls_aufk-aufnr ')' INTO ls_picklist-field_value.
      APPEND ls_picklist TO et_valuehelp.
  ENDCASE.
ENDENHANCEMENT.
