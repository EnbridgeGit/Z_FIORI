"Name: \TY:CL_HCM_TIMESHEET_APPRO_DPC_EXT\ME:GET_TARGET_HOURS\SE:END\EI
ENHANCEMENT 0 ZHCM_TIMESHEET_APPRO_DPC_EXT.
*BTBOUNDY - NEED TO DO THIS INSTEAD OF IMPLIMENTING get_target_hours which would be a copy of int_get_target_hours (Private method,can't use)

  "Only do if Badi activated and no records were returned
  IF lb_badi IS NOT INITIAL and rv_target_hours IS INITIAL.
    "Read Target hours for the week
    int_get_target_hours(
      EXPORTING
        iv_pernr = iv_pernr
        iv_begda = iv_begda
        iv_endda = iv_endda
      RECEIVING
      rv_target_hours = rv_target_hours ).
  ENDIF.
ENDENHANCEMENT.
