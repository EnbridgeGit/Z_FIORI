class ZCL_HCM_B_APPROVE_TIMESHEETS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_HCM_B_APPROVE_TIMESHEETS
*"* do not include other source files here!!!

  interfaces HCM_IF_APPROVE_TIMESHEETS .
  interfaces IF_BADI_INTERFACE .
protected section.
*"* protected components of class ZCL_HCM_B_APPROVE_TIMESHEETS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_HCM_B_APPROVE_TIMESHEETS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_HCM_B_APPROVE_TIMESHEETS IMPLEMENTATION.


method HCM_IF_APPROVE_TIMESHEETS~FILTER_TIME_RECORDS.
  "Do Nothing we don't want to filter the records any more.
endmethod.


method HCM_IF_APPROVE_TIMESHEETS~GET_PROFILE_ID.
endmethod.


METHOD hcm_if_approve_timesheets~get_status_filters.
  ev_read_approved = 'X'.
  ev_read_rejected = 'X'.
  ev_read_changed  = 'X'.
ENDMETHOD.


METHOD hcm_if_approve_timesheets~get_target_hours.
  "Implicit Enhancement will ignore this BADI if it returns nothing and will run standard logic
ENDMETHOD.


METHOD hcm_if_approve_timesheets~read_employees_for_manager.
  DATA: lv_hrdest TYPE tb_rfcdest.

  "Get the HR System from ZVARSYS
  CALL FUNCTION 'ZFI_GET_RFC_DEST'
    EXPORTING
      imp_paramtype = 'HR'
    IMPORTING
      exp_rfcdest   = lv_hrdest.


  "Z_FIORI_GET_USERFORMANAGER
  "Call the same function as standard code but in HR System
  CALL FUNCTION 'Z_FIORI_HCM_READ_EMPLOYEES' DESTINATION lv_hrdest
    EXPORTING
      iv_user  = iv_user
    IMPORTING
      rt_pernr = rt_pernr.
ENDMETHOD.
ENDCLASS.
