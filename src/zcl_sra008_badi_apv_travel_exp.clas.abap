class ZCL_SRA008_BADI_APV_TRAVEL_EXP definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_SRA008_BADI_APV_TRAVEL_EXP
*"* do not include other source files here!!!

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SRA008_BADI_APV_TRAVEL_EXP .
protected section.
*"* protected components of class ZCL_SRA008_BADI_APV_TRAVEL_EXP
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_SRA008_BADI_APV_TRAVEL_EXP
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_SRA008_BADI_APV_TRAVEL_EXP IMPLEMENTATION.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_ATTACHMENT_SET.
endmethod.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_COMMENT_SET.
endmethod.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_CONTACT_SET.
endmethod.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_COSTDIST_SET.
endmethod.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_LAST_MODIFIED.
endmethod.


METHOD if_sra008_badi_apv_travel_exp~change_meta_data.
  DATA: ls_entity       TYPE cl_sra008_mgw_med_tea=>ys_entity,
        ls_property     TYPE cl_sra008_mgw_med_tea=>ys_property,
        lv_order        TYPE i,
        io_property     TYPE REF TO /iwbep/if_mgw_odata_property,
        io_entity_type  TYPE REF TO /iwbep/if_mgw_odata_entity_typ.

  CLEAR lv_order.
  ADD 1000 TO lv_order.

  clear ls_property.
  ADD 10 TO lv_order.
  ls_property-entity_type       = 'Receipts'.
  ls_property-property_name     = 'ZZPARTICIPANTS'.
  ls_property-abap_name         = 'ZZPARTICIPANTS'.
  ls_property-is_key            = abap_false.
  ls_property-is_nullable       = abap_false.
  ls_property-is_creatable      = abap_false.
  ls_property-is_updatable      = abap_false.
  ls_property-is_filterable     = abap_false.
*  ls_property-visible_in_list   = cs_annotation_values-false.
*  ls_property-visible_in_detail = cs_annotation_values-false.
  ls_property-display_order     = lv_order.
  ls_property-semantic          = ''.
  INSERT ls_property INTO TABLE it_property.

  CLEAR ls_property.
  ADD 10 TO lv_order.
  ls_property-entity_type       = 'Receipts'.
  ls_property-property_name     = 'ZZNOTES'.
  ls_property-abap_name         = 'ZZNOTES'.
  ls_property-is_key            = abap_false.
  ls_property-is_nullable       = abap_false.
  ls_property-is_creatable      = abap_false.
  ls_property-is_updatable      = abap_false.
  ls_property-is_filterable     = abap_false.
*  ls_property-visible_in_list   = cs_annotation_values-false.
*  ls_property-visible_in_detail = cs_annotation_values-false.
  ls_property-display_order     = lv_order.
  ls_property-semantic          = ''.
  INSERT ls_property INTO TABLE it_property.

  CLEAR ls_property.
  ADD 10 TO lv_order.
  ls_property-entity_type       = 'Receipts'.
  ls_property-property_name     = 'ZZACCOUNTING'.
  ls_property-abap_name         = 'ZZACCOUNTING'.
  ls_property-is_key            = abap_false.
  ls_property-is_nullable       = abap_false.
  ls_property-is_creatable      = abap_false.
  ls_property-is_updatable      = abap_false.
  ls_property-is_filterable     = abap_false.
*  ls_property-visible_in_list   = cs_annotation_values-false.
*  ls_property-visible_in_detail = cs_annotation_values-false.
  ls_property-display_order     = lv_order.
  ls_property-semantic          = ''.
  INSERT ls_property INTO TABLE it_property.

  CLEAR ls_property.
  ADD 10 TO lv_order.
  ls_property-entity_type       = 'Receipts'.
  ls_property-property_name     = 'ZZEXCHANGE'.
  ls_property-abap_name         = 'ZZEXCHANGE'.
  ls_property-is_key            = abap_false.
  ls_property-is_nullable       = abap_false.
  ls_property-is_creatable      = abap_false.
  ls_property-is_updatable      = abap_false.
  ls_property-is_filterable     = abap_false.
*  ls_property-visible_in_list   = cs_annotation_values-false.
*  ls_property-visible_in_detail = cs_annotation_values-false.
  ls_property-display_order     = lv_order.
  ls_property-semantic          = ''.
  INSERT ls_property INTO TABLE it_property.


  CLEAR ls_property.
  ADD 10 TO lv_order.
  ls_property-entity_type       = 'Receipts'.
  ls_property-property_name     = 'ZZMILEAGETYPE'.
  ls_property-abap_name         = 'ZZMILEAGETYPE'.
  ls_property-is_key            = abap_false.
  ls_property-is_nullable       = abap_false.
  ls_property-is_creatable      = abap_false.
  ls_property-is_updatable      = abap_false.
  ls_property-is_filterable     = abap_false.
*  ls_property-visible_in_list   = cs_annotation_values-false.
*  ls_property-visible_in_detail = cs_annotation_values-false.
  ls_property-display_order     = lv_order.
  ls_property-semantic          = ''.
  INSERT ls_property INTO TABLE it_property.

  LOOP AT it_entity INTO ls_entity.
    IF ls_entity-entity_type = 'Receipts'.
      io_entity_type = it_model->get_entity_type( 'Receipts' ).

      io_property = io_entity_type->create_property( iv_property_name  = 'ZZPARTICIPANTS'
                                                     iv_abap_fieldname = 'ZZPARTICIPANTS' ).
      io_property->set_nullable( abap_true ).

      io_property = io_entity_type->create_property( iv_property_name  = 'ZZNOTES'
                                                     iv_abap_fieldname = 'ZZNOTES' ).
      io_property->set_nullable( abap_true ).

      io_property = io_entity_type->create_property( iv_property_name  = 'ZZACCOUNTING'
                                                     iv_abap_fieldname = 'ZZACCOUNTING' ).
      io_property->set_nullable( abap_true ).

      io_property = io_entity_type->create_property( iv_property_name  = 'ZZEXCHANGE'
                                                     iv_abap_fieldname = 'ZZEXCHANGE' ).
      io_property->set_nullable( abap_true ).

      io_property = io_entity_type->create_property( iv_property_name  = 'ZZMILEAGETYPE'
                                                     iv_abap_fieldname = 'ZZMILEAGETYPE' ).
      io_property->set_nullable( abap_true ).
    ENDIF.
  ENDLOOP.




ENDMETHOD.                    "IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_META_DATA


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_RECEIPT.
endmethod.


METHOD if_sra008_badi_apv_travel_exp~change_receipt_set.
  DATA: lt_addinfo      TYPE TABLE OF bapitraddi,
        lt_text         TYPE TABLE OF bapitrtext,
        lt_reccost      TYPE TABLE OF bapitrvcor,
        lt_bapireceipt  TYPE TABLE OF bapitrvreo,
        lt_mileage      TYPE TABLE OF bapitrvmil,
        lt_empinfo      TYPE TABLE OF bapitrvemp,

        ls_addinfo      LIKE LINE OF lt_addinfo,
        ls_text         LIKE LINE OF lt_text,
        ls_reccost      LIKE LINE OF lt_reccost,
        ls_bapireceipt  LIKE LINE OF lt_bapireceipt,
        ls_mileage      LIKE LINE OF lt_mileage,
        ls_empinfo      LIKE LINE OF lt_empinfo,

        lv_trvprofile   TYPE morei,
        lv_mileagekey   TYPE key_mile,

        ls_receipt  LIKE LINE OF it_receipt,
        lv_textid   LIKE ls_text-textid,
        lv_costdist LIKE ls_receipt-zzaccounting,
        lv_percent  TYPE string,
        lv_costobj  TYPE string,
        lv_extra    TYPE string.

  "Get the details from the BAPI
  CALL FUNCTION 'BAPI_TRIP_GET_DETAILS'
    EXPORTING
      employeenumber = iv_pernr
      tripnumber     = iv_trip_number
    TABLES
      receipts       = lt_bapireceipt
      addinfo        = lt_addinfo
      text           = lt_text
      costdist_rece  = lt_reccost
      mileage        = lt_mileage
      emp_info       = lt_empinfo.

  READ TABLE lt_empinfo INDEX 1 INTO ls_empinfo.

  lv_trvprofile = ls_empinfo-trip_provision_variant.

  LOOP AT it_receipt INTO ls_receipt.
    "Get the specific receipt from the BAPI return
    CLEAR: ls_bapireceipt,ls_addinfo, ls_text, ls_mileage.
    CONCATENATE 'R' ls_receipt-receipt_no INTO lv_textid.
    READ TABLE lt_bapireceipt WITH KEY receiptno = ls_receipt-receipt_no INTO ls_bapireceipt.
    READ TABLE lt_addinfo WITH KEY receiptno = ls_receipt-receipt_no INTO ls_addinfo.
    READ TABLE lt_text WITH KEY textid = lv_textid INTO ls_text.

    "Mileage Line
    IF ls_receipt-category = '12'.
      CONCATENATE '0' ls_receipt-receipt_no INTO lv_mileagekey.
      READ TABLE lt_mileage WITH KEY key_mile = lv_mileagekey INTO ls_mileage.

      IF ls_mileage-veh_type IS NOT INITIAL.
        SELECT SINGLE fztxt FROM t706e
          INTO ls_receipt-zzmileagetype
          WHERE spras = 'E'
            AND morei = lv_trvprofile
            AND kzpmf = ls_mileage-veh_type.
      ENDIF.
    ENDIF.


    "Build the cost accounting object
    CLEAR lv_costdist.
    LOOP AT lt_reccost INTO ls_reccost WHERE receiptno = ls_receipt-receipt_no.
      IF lv_costdist IS NOT INITIAL. "This is not the first loop
        CONCATENATE lv_costdist cl_abap_char_utilities=>newline INTO lv_costdist."Add new line chracter
      ENDIF.

      "Get the percentage, drop the decimal place
      CLEAR lv_percent.
      IF ls_bapireceipt-share_perc = 'X'. "This means its a percentage already.
        lv_percent = ls_reccost-rec_share.
      ELSE.
        "Not a percent so calculate it
        lv_percent = ls_reccost-rec_share / ls_receipt-receipt_amount * 100.
      ENDIF.
      SPLIT lv_percent AT '.' INTO: lv_percent lv_extra.

      "Concatenate the string with the percent and company code
      CONCATENATE lv_costdist lv_percent '%' INTO lv_costdist.
      CONCATENATE lv_costdist ls_reccost-comp_code  INTO lv_costdist SEPARATED BY space.

      "Add whatever objects are in the table.
      CONCATENATE ls_reccost-costcenter ls_reccost-order ls_reccost-cost_obj ls_reccost-wbs_elemt ls_reccost-network INTO lv_costobj.
      SHIFT lv_costobj LEFT DELETING LEADING '0'.
      CONCATENATE lv_costdist '/' lv_costobj INTO lv_costdist.

    ENDLOOP.

    "Populate exchange rate if needed.
    IF ls_bapireceipt-rec_curr NE ls_bapireceipt-loc_curr.
      ls_receipt-zzexchange = ls_bapireceipt-rec_rate.
    ENDIF.

    "Assign the fields to the odata object
    ls_receipt-zzparticipants = ls_addinfo-bus_reason.
    ls_receipt-zznotes = ls_text-textline.
    ls_receipt-zzaccounting = lv_costdist.

    MODIFY it_receipt FROM ls_receipt TRANSPORTING zzparticipants zznotes zzaccounting zzexchange zzmileagetype.
  ENDLOOP.
ENDMETHOD.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_USER_SET.
endmethod.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_WORKITEM.
endmethod.


METHOD if_sra008_badi_apv_travel_exp~change_worklist_set.
ENDMETHOD.


method IF_SRA008_BADI_APV_TRAVEL_EXP~CHANGE_WORKLIST_SUM_SET.
endmethod.
ENDCLASS.
