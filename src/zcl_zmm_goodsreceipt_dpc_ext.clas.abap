class ZCL_ZMM_GOODSRECEIPT_DPC_EXT definition
  public
  inheriting from ZCL_ZMM_GOODSRECEIPT_DPC
  create public .

public section.
*"* public components of class ZCL_ZMM_GOODSRECEIPT_DPC_EXT
*"* do not include other source files here!!!
protected section.
*"* protected components of class ZCL_ZMM_GOODSRECEIPT_DPC_EXT
*"* do not include other source files here!!!

  methods GRSET_CREATE_ENTITY
    redefinition .
  methods GRSET_DELETE_ENTITY
    redefinition .
  methods GRSET_GET_ENTITY
    redefinition .
  methods GRSET_GET_ENTITYSET
    redefinition .
  methods POMOVEMENTSET_GET_ENTITYSET
    redefinition .
  methods POSET_GET_ENTITY
    redefinition .
  methods POSET_GET_ENTITYSET
    redefinition .
private section.
*"* private components of class ZCL_ZMM_GOODSRECEIPT_DPC_EXT
*"* do not include other source files here!!!

  methods CALCULATE_OPEN_PO_QTY
    importing
      !IM_PONUMBER type EBELN
      !IM_POITEM type ANY
      !IM_QTY type ERFMG
    exporting
      !EX_REM_QTY type ERFMG
      !EX_GR_COMPL type ANY .
  class ZCL_ZMM_GOODSRECEIPT_MPC definition load .
  methods GET_POMOVEMENT
    importing
      !IM_PONUMBER type EBELN
      !IM_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IM_ENTITY_NAME type STRING
    changing
      !EX_DATA type ZCL_ZMM_GOODSRECEIPT_MPC=>TT_POMOVEMENT .
  methods GET_GR
    importing
      !IM_GRNUMBER type MBLNR
      !IM_GRYEAR type MJAHR
      !IM_GRITEM type MBLPO optional
      !IM_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IM_ENTITY_NAME type STRING
    changing
      !EX_DATA type ZCL_ZMM_GOODSRECEIPT_MPC=>TT_GR .
  methods GET_PO
    importing
      !IM_PONUMBER type EBELN
      !IM_POITEM type EBELP optional
      !IM_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
      !IM_ENTITY_NAME type STRING
    changing
      !EX_DATA type ZCL_ZMM_GOODSRECEIPT_MPC=>TT_PO .
ENDCLASS.



CLASS ZCL_ZMM_GOODSRECEIPT_DPC_EXT IMPLEMENTATION.


METHOD calculate_open_po_qty.

  DATA: lt_return           TYPE STANDARD TABLE OF bapiret2,
        lt_poitem           TYPE STANDARD TABLE OF bapimepoitem,
        lt_pohistory_totals TYPE STANDARD TABLE OF bapiekbes,
        lv_gr_qty           TYPE wemng,
        lv_rem_qty          TYPE wemng,
        lv_del_compl        TYPE boole_d.

  FIELD-SYMBOLS: <pohistory_totals> LIKE LINE OF lt_pohistory_totals,
                 <poitem>           LIKE LINE OF lt_poitem.

  CALL FUNCTION 'BAPI_PO_GETDETAIL1'
    EXPORTING
      purchaseorder    = im_ponumber
    TABLES
      return           = lt_return
      poitem           = lt_poitem
      pohistory_totals = lt_pohistory_totals.

  IF lt_poitem[] IS NOT INITIAL.
    LOOP AT lt_poitem ASSIGNING <poitem> WHERE po_item EQ im_poitem.
      lv_del_compl = <poitem>-no_more_gr.
      CHECK <poitem>-no_more_gr IS INITIAL. "Delivery completion indicator set?
      lv_rem_qty = <poitem>-quantity.
      LOOP AT lt_pohistory_totals ASSIGNING <pohistory_totals>
                                  WHERE po_item EQ im_poitem.
        lv_gr_qty = <pohistory_totals>-deliv_qty.
        lv_rem_qty = lv_rem_qty - lv_gr_qty.
        EXIT.
      ENDLOOP.
      ex_rem_qty = lv_rem_qty.
      EXIT.
    ENDLOOP.

    IF lv_del_compl IS NOT INITIAL. "not initial means Delivery completed
      ex_gr_compl = abap_true.
    ELSEIF lv_rem_qty GE im_qty.
      ex_gr_compl = abap_false.
    ELSE.
      ex_gr_compl = abap_true.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD get_gr.

  DATA: ls_header     TYPE bapi2017_gm_head_02,
        lt_items      TYPE TABLE OF bapi2017_gm_item_show,
        ls_poheader   TYPE bapimepoheader,
        lt_poitem     TYPE TABLE OF bapimepoitem,
        ls_poitem     LIKE LINE OF lt_poitem,
        lv_canceled   TYPE char1,
        lv_frbnr      TYPE frbnr1.  "Bill of lading

  FIELD-SYMBOLS: <item> LIKE LINE OF lt_items.

  DATA: ls_entityset          LIKE LINE OF ex_data,
        lt_return             TYPE TABLE OF bapiret2,
        lo_message_container  TYPE REF TO /iwbep/if_message_container,
        lv_msg                TYPE bapi_msg.

**Populate Data
  CHECK im_grnumber IS NOT INITIAL.
  CHECK im_gryear IS NOT INITIAL.

  REFRESH: lt_items,lt_return.
  CALL FUNCTION 'BAPI_GOODSMVT_GETDETAIL'
    EXPORTING
      materialdocument = im_grnumber
      matdocumentyear  = im_gryear
    IMPORTING
      goodsmvt_header  = ls_header
    TABLES
      goodsmvt_items   = lt_items
      return           = lt_return.

  IF lt_return[] IS NOT INITIAL.
*    me->/iwbep/if_sb_dpc_comm_services~rfc_save_log(
*      EXPORTING
*        iv_entity_type = im_entity_name
*        it_return      = lt_return
*        it_key_tab     = im_key_tab ).
    EXIT.
  ENDIF.

  IF im_gritem IS NOT INITIAL.
    DELETE lt_items WHERE matdoc_itm <> im_gritem.
  ENDIF.

**Field Mapping
  LOOP AT lt_items ASSIGNING <item> WHERE move_type EQ '101'.
    CLEAR ls_entityset.

    IF lt_poitem[] IS INITIAL.
      CALL FUNCTION 'BAPI_PO_GETDETAIL1'
        EXPORTING
          purchaseorder = <item>-po_number
        IMPORTING
          poheader      = ls_poheader
        TABLES
          return        = lt_return
          poitem        = lt_poitem.
    ENDIF.

    ls_entityset-grnumber        = ls_header-mat_doc.
    ls_entityset-gryear          = ls_header-doc_year.
    ls_entityset-headertext      = ls_header-header_txt.
    ls_entityset-postingdate     = ls_header-pstng_date.
    ls_entityset-documentdate    = ls_header-doc_date.
    ls_entityset-username        = ls_header-username.
    ls_entityset-entrytime       = ls_header-entry_date.
    ls_entityset-deliverynote    = ls_header-ref_doc_no.
    ls_entityset-gritem          = <item>-matdoc_itm.
    ls_entityset-ponumber        = <item>-po_number.
    ls_entityset-poitem          = <item>-po_item.
    ls_entityset-storageloc      = <item>-stge_loc.
    ls_entityset-goodsreceipient = <item>-gr_rcpt.
    ls_entityset-plant           = <item>-plant.
    ls_entityset-quantity        = <item>-entry_qnt.
    ls_entityset-unit            = <item>-entry_uom.
    ls_entityset-movetype        = <item>-move_type .
    ls_entityset-itemtext        = <item>-item_text.
    ls_entityset-vendor          = ls_poheader-vendor.

    SELECT SINGLE name1 INTO ls_entityset-vendorname FROM lfa1
      WHERE lifnr = ls_poheader-vendor.

    SELECT SINGLE frbnr INTO lv_frbnr
                              FROM mkpf
                              WHERE mblnr EQ ls_header-mat_doc
                              AND mjahr EQ ls_header-doc_year.
    IF sy-subrc EQ 0.
      ls_entityset-billoflading = lv_frbnr.
    ENDIF.

    READ TABLE lt_poitem INTO ls_poitem
                         WITH KEY po_item = <item>-po_item.
    IF sy-subrc EQ 0.
      ls_entityset-material = ls_poitem-material.
      SHIFT ls_entityset-material LEFT DELETING LEADING '0'.
      ls_entityset-matdesc  = ls_poitem-short_text.
    ENDIF.
    CALL FUNCTION 'WB2_CHK_HEAD_STAT_MD_SINGLE'
      EXPORTING
        mblnr            = ls_header-mat_doc
        mjahr            = ls_header-doc_year
      IMPORTING
        canceled         = lv_canceled
      EXCEPTIONS
        record_not_found = 1
        OTHERS           = 2.

    IF sy-subrc = 0 AND lv_canceled IS INITIAL.
      APPEND ls_entityset TO ex_data.
    ENDIF.
  ENDLOOP.

  CHECK ex_data[] IS INITIAL.


*  lv_msg =  'Nothing Found for that Mat Doc'.
*
*
*  CALL METHOD lo_message_container->add_message_text_only
*    EXPORTING
*      iv_msg_type               = 'E'
*      iv_msg_text               = lv_msg
*      iv_is_leading_message     = abap_true
*      iv_entity_type            = im_entity_name
*      it_key_tab                = im_key_tab
*      iv_add_to_response_header = abap_true.
*
*  RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*    EXPORTING
*      textid            = /iwbep/cx_mgw_busi_exception=>business_error
*      message_container = lo_message_container.

ENDMETHOD.


METHOD GET_PO.

  DATA: ls_poheader         TYPE bapimepoheader,
        lt_poitem           TYPE TABLE OF bapimepoitem,
        ls_poitem           TYPE bapimepoitem,
        lt_pohistory_totals	TYPE TABLE OF	bapiekbes,
        ls_pohistory_totals LIKE LINE OF lt_pohistory_totals,
        lt_poaccount        TYPE TABLE OF  bapimepoaccount,
        ls_poaccount        LIKE LINE OF lt_poaccount,
        lv_vendorname       TYPE lfa1-name1,
        lv_sernp            TYPE serail,
        lv_materialdesc     TYPE makt-maktx.

  DATA: ls_entityset          LIKE LINE OF ex_data,
        lt_return             TYPE TABLE OF bapiret2,
        lo_message_container  TYPE REF TO /iwbep/if_message_container,
        lv_msg                TYPE bapi_msg.


  CHECK im_ponumber IS NOT INITIAL.

**Populate Data
  CALL FUNCTION 'BAPI_PO_GETDETAIL1'
    EXPORTING
      purchaseorder      = im_ponumber
      account_assignment = 'X'
    IMPORTING
      poheader           = ls_poheader
    TABLES
      return             = lt_return
      poitem             = lt_poitem
      poaccount          = lt_poaccount
      pohistory_totals   = lt_pohistory_totals.

  IF lt_return IS NOT INITIAL.
*    me->/iwbep/if_sb_dpc_comm_services~rfc_save_log(
*      EXPORTING
*        iv_entity_type = im_entity_name
*        it_return      = lt_return
*        it_key_tab     = im_key_tab ).
    EXIT.
  ENDIF.

  IF im_poitem IS NOT INITIAL.
    DELETE lt_poitem WHERE po_item <> im_poitem.
  ENDIF.


**Field Mapping
  ls_entityset-ponumber = ls_poheader-po_number.
  ls_entityset-compcode = ls_poheader-comp_code.
  ls_entityset-vendor = ls_poheader-vendor.

  "Vendor Name
  IF ls_poheader-vendor IS NOT INITIAL.
    SELECT SINGLE name1
      FROM lfa1
      INTO lv_vendorname
      WHERE lifnr = ls_poheader-vendor.

    IF sy-subrc = 0.
      ls_entityset-vendorname = lv_vendorname.
    ENDIF.
  ENDIF.


* In GetEntity operation we support only read for the first entry in the response table
  LOOP AT lt_poitem INTO ls_poitem.

    CLEAR:  ls_entityset-poitem,     ls_entityset-material,
            ls_entityset-vendormat,  ls_entityset-plant,
            ls_entityset-storageloc, ls_entityset-quantity,
            ls_entityset-materialdesc.

    CHECK ls_poitem-delete_ind  IS INITIAL AND
          ls_poitem-no_more_gr  IS INITIAL.

    ls_entityset-poitem       = ls_poitem-po_item.
    ls_entityset-material     = ls_poitem-material.
    ls_entityset-vendormat    = ls_poitem-vend_mat.
    ls_entityset-plant        = ls_poitem-plant.
    ls_entityset-storageloc   = ls_poitem-stge_loc.
    ls_entityset-unit         = ls_poitem-po_unit.
    ls_entityset-materialdesc = ls_poitem-short_text.

    READ TABLE lt_poaccount INTO ls_poaccount
                            WITH KEY po_item = ls_poitem-po_item.
    IF sy-subrc EQ 0.
      ls_entityset-goodsreceipient = ls_poaccount-gr_rcpt.
    ENDIF.

*    IF sy-sysid EQ 'SFC' OR sy-sysid EQ 'PEC' AND
*       sy-sysid EQ 'QEC' OR sy-sysid EQ 'PEC'.
      SELECT SINGLE sernp INTO lv_sernp FROM marc
                                        WHERE matnr EQ ls_poitem-material.
      IF sy-subrc EQ 0.
        IF lv_sernp NE ' '.
          ls_entityset-serialautogen = 'Y'.
        ELSE.
          ls_entityset-serialautogen = 'N'.
        ENDIF.
      ELSE.
        ls_entityset-serialautogen = 'N'.
      ENDIF.
*    ELSE.
*      ls_entityset-serialautogen = 'NN'.
*    ENDIF.

    READ TABLE lt_pohistory_totals INTO ls_pohistory_totals
                                   WITH KEY po_item = ls_poitem-po_item.
    IF sy-subrc EQ 0.
      ls_entityset-quantity = ls_poitem-quantity - ls_pohistory_totals-deliv_qty.
    ELSE.
      ls_entityset-quantity = ls_poitem-quantity.
    ENDIF.

    CHECK ls_entityset-quantity IS NOT INITIAL.
    APPEND ls_entityset TO ex_data.
  ENDLOOP.

  CHECK ex_data[] IS INITIAL.

*  IF im_poitem IS NOT INITIAL.
*    CONCATENATE 'Nothing Found for PONumber' im_ponumber 'and POItem' im_poitem INTO lv_msg SEPARATED BY space.
*  else.
*    CONCATENATE 'Nothing Found for PONumber' im_ponumber INTO lv_msg SEPARATED BY space.
*  ENDIF.
*
*  CALL METHOD lo_message_container->add_message_text_only
*    EXPORTING
*      iv_msg_type               = 'E'
*      iv_msg_text               = lv_msg
*      iv_is_leading_message     = abap_true
*      iv_entity_type            = im_entity_name
*      it_key_tab                = im_key_tab
*      iv_add_to_response_header = abap_true.
*
*  RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*    EXPORTING
*      textid            = /iwbep/cx_mgw_busi_exception=>business_error
*      message_container = lo_message_container.

ENDMETHOD.


METHOD get_pomovement.

  DATA: lt_goodsmvt_items     TYPE TABLE OF bapiekbe,
        ls_goodsmvt_items     LIKE LINE OF lt_goodsmvt_items,
        ls_poheader           TYPE BAPIMEPOHEADER,
        lv_canceled           TYPE char1,
        lt_return             TYPE TABLE OF bapiret2.

  DATA: ls_entityset          LIKE LINE OF ex_data.


  DATA: lo_message_container  TYPE REF TO /iwbep/if_message_container,
        lv_msg                TYPE bapi_msg.

* Get message container object
  lo_message_container = mo_context->get_message_container( ).

  CHECK im_ponumber IS NOT INITIAL.

  "Get the GR Numbers from PO History
  CALL FUNCTION 'BAPI_PO_GETDETAIL1'
    EXPORTING
      purchaseorder = im_ponumber
    IMPORTING
      poheader      = ls_poheader
    TABLES
      pohistory     = lt_goodsmvt_items.


  SORT lt_goodsmvt_items.
  DELETE ADJACENT DUPLICATES FROM lt_goodsmvt_items COMPARING mat_doc.
  LOOP AT lt_goodsmvt_items INTO ls_goodsmvt_items WHERE move_type = '101'.

    CLEAR ls_entityset.
    ls_entityset-movement      = ls_goodsmvt_items-mat_doc.
    ls_entityset-movementyear  = ls_goodsmvt_items-doc_year.
    ls_entityset-enteredon     = ls_goodsmvt_items-entry_date.
    ls_entityset-deliverynote  = ls_goodsmvt_items-ref_doc_no.

    "Bill of Lading
    SELECT SINGLE frbnr usnam  INTO (ls_entityset-billoflading, ls_entityset-enteredby)
      FROM mkpf
      WHERE mblnr EQ ls_goodsmvt_items-mat_doc
      AND mjahr EQ ls_goodsmvt_items-doc_year.

    ls_entityset-movementitem    = ls_goodsmvt_items-matdoc_itm.
    ls_entityset-movementtype    = ls_goodsmvt_items-move_type.
    ls_entityset-ponumber        = im_ponumber.
    ls_entityset-poitem          = ls_goodsmvt_items-po_item.
    ls_entityset-vendor          = ls_poheader-vendor.

    SELECT SINGLE name1 INTO ls_entityset-vendorname
      FROM lfa1
      WHERE lifnr = ls_poheader-vendor.

    CALL FUNCTION 'WB2_CHK_HEAD_STAT_MD_SINGLE'
      EXPORTING
        mblnr            = ls_goodsmvt_items-mat_doc
        mjahr            = ls_goodsmvt_items-doc_year
      IMPORTING
        canceled         = lv_canceled
      EXCEPTIONS
        record_not_found = 1
        OTHERS           = 2.

    IF sy-subrc = 0 AND lv_canceled IS INITIAL.
      APPEND ls_entityset TO ex_data.
    ENDIF.
  ENDLOOP.


  CHECK ex_data[] IS INITIAL.

  IF im_ponumber IS NOT INITIAL.
    CONCATENATE 'Nothing Found for PONumber' im_ponumber INTO lv_msg SEPARATED BY space.
  ENDIF.

*  CALL METHOD lo_message_container->add_message_text_only
*    EXPORTING
*      iv_msg_type               = 'E'
*      iv_msg_text               = lv_msg
*      iv_is_leading_message     = abap_true
*      iv_entity_type            = im_entity_name
*      it_key_tab                = im_key_tab
*      iv_add_to_response_header = abap_true.
*
*  RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*    EXPORTING
*      textid            = /iwbep/cx_mgw_busi_exception=>business_error
*      message_container = lo_message_container.

ENDMETHOD.


METHOD grset_create_entity.

  DATA: ls_goodsmvt_header   TYPE bapi2017_gm_head_01,
      ls_goodsmvt_code      TYPE gm_code,
      lt_goodsmvt_item      TYPE TABLE OF bapi2017_gm_item_create,
      ls_goodsmvt_item      LIKE LINE OF lt_goodsmvt_item,
      lv_testrun            TYPE bapi2017_gm_gen-testrun,
      lt_return             TYPE TABLE OF bapiret2,
      ls_return             LIKE LINE OF lt_return,
      ls_request_input_data TYPE zcl_zmm_goodsreceipt_mpc=>ts_gr,
      goodsmvt_headret      TYPE  bapi2017_gm_head_ret,
      materialdocument      TYPE  bapi2017_gm_head_ret-mat_doc,
      matdocumentyear       TYPE  bapi2017_gm_head_ret-doc_year,
      lv_rem_qty            TYPE erfmg.

  DATA: lo_message_container TYPE REF TO /iwbep/if_message_container,
        lv_lead_msg          TYPE abap_bool,
        error_msg            TYPE symsgty,
        lv_msg               TYPE bapi_msg,
        err_details          TYPE /iwbep/if_message_container=>ty_s_error_detail.

  io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

* Get message container object
  lo_message_container = mo_context->get_message_container( ).

  CLEAR: ls_goodsmvt_header, ls_goodsmvt_item.

* Populate header data
  ls_goodsmvt_header-pstng_date         = ls_request_input_data-postingdate.
  ls_goodsmvt_header-doc_date           = ls_request_input_data-documentdate.
  ls_goodsmvt_header-bill_of_lading     = ls_request_input_data-billoflading.
  ls_goodsmvt_header-pr_uname           = sy-uname.
  ls_goodsmvt_header-header_txt         = ls_request_input_data-headertext.
  ls_goodsmvt_header-ref_doc_no         = ls_request_input_data-deliverynote.

* Populate Item details
  ls_goodsmvt_item-material             = ls_request_input_data-material .
  ls_goodsmvt_item-plant                = ls_request_input_data-plant.
  ls_goodsmvt_item-stge_loc             = ls_request_input_data-storageloc.
  ls_goodsmvt_item-move_type            = '101'.
  ls_goodsmvt_item-entry_qnt            = ls_request_input_data-quantity .
  ls_goodsmvt_item-entry_uom            = ls_request_input_data-unit.
  ls_goodsmvt_code                      = '01'. " Godds movement code for purchase order
  ls_goodsmvt_item-mvt_ind              = 'B'.  " Movement indicator for purchase order
  ls_goodsmvt_item-po_number            = ls_request_input_data-ponumber.
  ls_goodsmvt_item-po_item              = ls_request_input_data-poitem.
  ls_goodsmvt_item-gr_rcpt              = ls_request_input_data-goodsreceipient.
  ls_goodsmvt_item-gr_rcptx             = 'X'.
  ls_goodsmvt_item-item_text            = ls_request_input_data-itemtext.
  ls_goodsmvt_item-serialno_auto_numberassignment = ls_request_input_data-serialautogen.

*Check open PO quantity to set no more good receipt flag
  IF ls_request_input_data-deliverycomplete IS INITIAL.
    calculate_open_po_qty( EXPORTING im_ponumber = ls_request_input_data-ponumber
                                     im_poitem   = ls_request_input_data-poitem
                                     im_qty      = ls_request_input_data-quantity
                           IMPORTING ex_rem_qty  = lv_rem_qty
                                     ex_gr_compl = ls_goodsmvt_item-no_more_gr ).
  ELSE.
    ls_goodsmvt_item-no_more_gr = abap_true.
  ENDIF.

  APPEND ls_goodsmvt_item TO lt_goodsmvt_item.

  lv_testrun = abap_false.

*  IF sy-uname EQ 'JMITTENDORF' OR sy-uname EQ 'MZHOSSAIN' OR sy-uname EQ 'BTBOUNDY'.
*    lv_testrun = abap_true.
*  ENDIF.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_goodsmvt_header
      goodsmvt_code    = ls_goodsmvt_code
      testrun          = lv_testrun
    IMPORTING
      goodsmvt_headret = goodsmvt_headret
      materialdocument = materialdocument
      matdocumentyear  = matdocumentyear
    TABLES
      goodsmvt_item    = lt_goodsmvt_item
      return           = lt_return.

  IF lt_return[] IS NOT INITIAL. "Error returned from BApi
    CALL METHOD lo_message_container->add_messages_from_bapi
      EXPORTING
        it_bapi_messages = lt_return.

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        textid            = /iwbep/cx_mgw_busi_exception=>business_error
        message_container = lo_message_container.
  ELSE. "BApi Success
    IF lv_testrun EQ abap_false.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      er_entity               = ls_request_input_data.
      er_entity-grnumber      = materialdocument.
      er_entity-quantity      = lv_rem_qty.
      SHIFT er_entity-grnumber LEFT DELETING LEADING '0'.
    ELSE.
      er_entity               = ls_request_input_data.
      er_entity-quantity      = lv_rem_qty.
      er_entity-grnumber = 'Test Mode'.

*      CONCATENATE 'Material docoment' materialdocument 'is created' INTO lv_msg SEPARATED BY space.
*      CALL METHOD lo_message_container->add_message_text_only
*        EXPORTING
*          iv_msg_type           = 'E'
*          iv_msg_text           = lv_msg
*          iv_is_leading_message = abap_true.
*      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*        EXPORTING
*          textid            = /iwbep/cx_mgw_busi_exception=>business_error
*          message_container = lo_message_container.
    ENDIF.

*    DATA: lv_msg TYPE bapi_msg.
*    CONCATENATE 'Mat doc' materialdocument 'is created' INTO lv_msg SEPARATED BY space.
*    CALL METHOD lo_message_container->add_message_text_only
*      EXPORTING
*        iv_msg_type           = 'E'
*        iv_msg_text           = lv_msg
*        iv_is_leading_message = abap_true.
*    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*      EXPORTING
*        textid            = /iwbep/cx_mgw_busi_exception=>business_error
*        message_container = lo_message_container.
  ENDIF.

ENDMETHOD.


METHOD grset_delete_entity.

 DATA:  lv_matdoc               TYPE  bapi2017_gm_head_02-mat_doc,
        lv_matdocyear           TYPE  bapi2017_gm_head_02-doc_year,
        ls_goodsmvt_headrer     TYPE  bapi2017_gm_head_ret,
        lt_return	              TYPE TABLE OF bapiret2,
        lt_goodsmvt_matdocitem  TYPE TABLE OF bapi2017_gm_item_04,
        lv_goodsmvt_pstng_date  TYPE  bapi2017_gm_head_02-pstng_date,
        lv_goodsmvt_pr_uname  TYPE  bapi2017_gm_head_01-pr_uname.

  DATA: lo_message_container TYPE REF TO /iwbep/if_message_container.

  FIELD-SYMBOLS: <key_tab> LIKE LINE OF it_key_tab.

* Get message container object
  lo_message_container = mo_context->get_message_container( ).

  LOOP AT it_key_tab ASSIGNING <key_tab>
                     WHERE name EQ 'GRNumber'
                     OR    name EQ 'GRYear'.

    IF <key_tab>-name EQ 'GRNumber'.
      lv_matdoc     = <key_tab>-value.
    ELSEIF <key_tab>-name EQ 'GRYear'.
      lv_matdocyear = <key_tab>-value.
    ENDIF.
  ENDLOOP.


  lv_goodsmvt_pstng_date = sy-datum.
  lv_goodsmvt_pr_uname   = sy-uname.

  CALL FUNCTION 'BAPI_GOODSMVT_CANCEL'
    EXPORTING
      materialdocument    = lv_matdoc
      matdocumentyear     = lv_matdocyear
      goodsmvt_pstng_date = lv_goodsmvt_pstng_date
      goodsmvt_pr_uname   = lv_goodsmvt_pr_uname
    IMPORTING
      goodsmvt_headret    = ls_goodsmvt_headrer
    TABLES
      return              = lt_return
      goodsmvt_matdocitem = lt_goodsmvt_matdocitem.

  IF lt_return[] IS NOT INITIAL.
    CALL METHOD lo_message_container->add_messages_from_bapi
      EXPORTING
        it_bapi_messages = lt_return.

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        textid            = /iwbep/cx_mgw_busi_exception=>business_error
        message_container = lo_message_container.
  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

*    DATA: lv_msg TYPE bapi_msg.
*    CONCATENATE 'Mat doc' lv_matdoc 'is deleted' INTO lv_msg SEPARATED BY space.
*    CALL METHOD lo_message_container->add_message_text_only
*      EXPORTING
*        iv_msg_type           = 'E'
*        iv_msg_text           = lv_msg
*        iv_is_leading_message = abap_true.
*    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*      EXPORTING
*        textid            = /iwbep/cx_mgw_busi_exception=>business_error
*        message_container = lo_message_container.
  ENDIF.

ENDMETHOD.


METHOD grset_get_entity.

  DATA: lv_filter_grnumber  TYPE mblnr,
        lv_filter_gryear    TYPE mjahr,
        lv_filter_gritem    TYPE mblpo.

  DATA: lt_entityset        LIKE TABLE OF er_entity,
        ls_key_tab          LIKE LINE OF it_key_tab. "(Could use io_tech_request_context->get_converted_keys)


  LOOP AT it_key_tab INTO ls_key_tab.
    CASE ls_key_tab-name.
      WHEN 'GRNumber'.
        lv_filter_grnumber  = ls_key_tab-value.
      WHEN 'GRYear'.
        lv_filter_gryear    = ls_key_tab-value.
      WHEN 'GRItem'.
      lv_filter_gritem      = ls_key_tab-value.
        "These are when you come from POMovement
      WHEN 'Movement'.
        lv_filter_grnumber  = ls_key_tab-value.
      WHEN 'MovementYear'.
        lv_filter_gryear    = ls_key_tab-value.
      WHEN 'MobementItem'.
        lv_filter_gritem    = ls_key_tab-value.
    ENDCASE.
  ENDLOOP.

  CALL METHOD me->get_gr
    EXPORTING
      im_grnumber    = lv_filter_grnumber
      im_gryear      = lv_filter_gryear
      im_gritem      = lv_filter_gritem
      im_key_tab     = it_key_tab
      im_entity_name = iv_entity_name
    CHANGING
      ex_data        = lt_entityset.

  IF lt_entityset IS NOT INITIAL.
    READ TABLE lt_entityset INTO er_entity INDEX 1.
  ENDIF.
ENDMETHOD.


METHOD grset_get_entityset.

**Get Mandatory Filter
  DATA: lo_filter TYPE  REF TO /iwbep/if_mgw_req_filter,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        lv_filter_str TYPE string,
        ls_filter TYPE /iwbep/s_mgw_select_option,
        ls_filter_range TYPE /iwbep/s_cod_select_option.

  DATA: ls_keys             LIKE LINE OF et_entityset,
        lr_filter_grnumber  LIKE RANGE OF ls_keys-grnumber,
        ls_filter_grnumber  LIKE LINE OF lr_filter_grnumber,
        lv_filter_grnumber  TYPE mblnr,
        lr_filter_gryear    LIKE RANGE OF ls_keys-gryear,
        ls_filter_gryear    LIKE LINE OF lr_filter_gryear,
        lv_filter_gryear    TYPE  mjahr.


  lo_filter = io_tech_request_context->get_filter( ).
  lt_filter_select_options = lo_filter->get_filter_select_options( ).
  lv_filter_str = lo_filter->get_filter_string( ).

**Check if the supplied filter is supported by standard gateway runtime process
  IF  lv_filter_str IS NOT INITIAL AND lt_filter_select_options IS INITIAL.
    me->/iwbep/if_sb_dpc_comm_services~log_message(
      EXPORTING
        iv_msg_type   = 'E'
        iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
        iv_msg_number = 025 ).
    " Raise Exception
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
      EXPORTING
        textid = /iwbep/cx_mgw_tech_exception=>internal_error.
  ENDIF.

**Maps filter table lines to function module parameters
  LOOP AT lt_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-property.
        WHEN 'GRNUMBER'.
          lo_filter->convert_select_option(
            EXPORTING
              is_select_option = ls_filter
            IMPORTING
              et_select_option = lr_filter_grnumber ).

          READ TABLE lr_filter_grnumber INTO ls_filter_grnumber INDEX 1.
          IF sy-subrc = 0.
            lv_filter_grnumber = ls_filter_grnumber-low.
          ENDIF.
        WHEN 'GRYEAR'.
          lo_filter->convert_select_option(
            EXPORTING
              is_select_option = ls_filter
            IMPORTING
              et_select_option = lr_filter_gryear ).

          READ TABLE lr_filter_gryear INTO ls_filter_gryear INDEX 1.
          IF sy-subrc = 0.
            lv_filter_gryear = ls_filter_gryear-low.
          ENDIF.
        WHEN 'SAP__ORIGIN'.

        WHEN OTHERS.
          " Log message in the application log
          me->/iwbep/if_sb_dpc_comm_services~log_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
              iv_msg_number = 020
              iv_msg_v1     = ls_filter-property ).
          " Raise Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
            EXPORTING
              textid = /iwbep/cx_mgw_tech_exception=>internal_error.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  IF lv_filter_grnumber IS NOT INITIAL AND lv_filter_gryear IS NOT INITIAL.

    CALL METHOD me->get_gr
      EXPORTING
        im_grnumber    = lv_filter_grnumber
        im_gryear      = lv_filter_gryear
        im_key_tab     = it_key_tab
        im_entity_name = iv_entity_name
      CHANGING
        ex_data        = et_entityset.

  ENDIF.

ENDMETHOD.


METHOD pomovementset_get_entityset.

**Get Mandatory Filter
  DATA: lo_filter                TYPE  REF TO /iwbep/if_mgw_req_filter,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        lv_filter_str            TYPE string,
        ls_filter                TYPE /iwbep/s_mgw_select_option,
        ls_filter_range          TYPE /iwbep/s_cod_select_option.

  DATA: ls_keys                  LIKE LINE OF et_entityset,
        lr_filter_ponumber       LIKE RANGE OF ls_keys-ponumber,
        ls_filter_ponumber       LIKE LINE OF lr_filter_ponumber,
        lv_filter_ponumber       TYPE bstnr.

  lo_filter                = io_tech_request_context->get_filter( ).
  lt_filter_select_options = lo_filter->get_filter_select_options( ).
  lv_filter_str            = lo_filter->get_filter_string( ).

**Check if the supplied filter is supported by standard gateway runtime process
  IF lv_filter_str IS NOT INITIAL AND lt_filter_select_options IS INITIAL.
    me->/iwbep/if_sb_dpc_comm_services~log_message(
      EXPORTING
        iv_msg_type   = 'E'
        iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
        iv_msg_number = 025 ).

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception " Raise Exception
      EXPORTING
        textid = /iwbep/cx_mgw_tech_exception=>internal_error.
  ENDIF.

**Maps filter table lines to function module parameters
  LOOP AT lt_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-property.
        WHEN 'PONUMBER'.
          lo_filter->convert_select_option(
            EXPORTING
              is_select_option = ls_filter
            IMPORTING
              et_select_option = lr_filter_ponumber ).

          READ TABLE lr_filter_ponumber INTO ls_filter_ponumber INDEX 1.
          IF sy-subrc = 0.
            lv_filter_ponumber = ls_filter_ponumber-low.
          ENDIF.
        WHEN OTHERS.
          " Log message in the application log
          me->/iwbep/if_sb_dpc_comm_services~log_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
              iv_msg_number = 020
              iv_msg_v1     = ls_filter-property ).
          " Raise Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
            EXPORTING
              textid = /iwbep/cx_mgw_tech_exception=>internal_error.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.


  IF lv_filter_ponumber IS NOT INITIAL.  "Filter by purchase order number

    CALL METHOD me->get_pomovement
      EXPORTING
        im_ponumber    = lv_filter_ponumber
        im_key_tab     = it_key_tab
        im_entity_name = iv_entity_name
      CHANGING
        ex_data        = et_entityset.

  ENDIF.

ENDMETHOD.


METHOD poset_get_entity.

  DATA: lv_filter_ponumber  TYPE bapimepoheader-po_number,
        lv_filter_poitem    TYPE bapimepoitem-po_item.

  DATA: lt_entityset        LIKE TABLE OF er_entity,
        ls_keys             LIKE er_entity. "(Could use IT_KEY_TAB)

  io_tech_request_context->get_converted_keys(
    IMPORTING
      es_key_values = ls_keys ).

  lv_filter_ponumber  = ls_keys-ponumber.
  lv_filter_poitem    = ls_keys-poitem.

  CALL METHOD me->get_po
    EXPORTING
      im_ponumber    = lv_filter_ponumber
      im_poitem      = lv_filter_poitem
      im_key_tab     = it_key_tab
      im_entity_name = iv_entity_name
    CHANGING
      ex_data        = lt_entityset.

  IF lt_entityset IS NOT INITIAL.
    READ TABLE lt_entityset INTO er_entity INDEX 1.
  ENDIF.

ENDMETHOD.


METHOD poset_get_entityset.

**Get Mandatory Filter
  DATA: lo_filter TYPE  REF TO /iwbep/if_mgw_req_filter,
        lt_filter_select_options TYPE /iwbep/t_mgw_select_option,
        lv_filter_str TYPE string,
        ls_filter TYPE /iwbep/s_mgw_select_option,
        ls_filter_range TYPE /iwbep/s_cod_select_option.

  DATA: ls_keys             LIKE LINE OF et_entityset,
        lr_filter_ponumber  LIKE RANGE OF ls_keys-ponumber,
        ls_filter_ponumber  LIKE LINE OF lr_filter_ponumber,
        lv_filter_ponumber  TYPE bapimepoheader-po_number,
        lr_filter_poitem    LIKE RANGE OF ls_keys-poitem,
        ls_filter_poitem    LIKE LINE OF lr_filter_poitem,
        lv_filter_poitem    TYPE bapimepoitem-po_item.


  lo_filter = io_tech_request_context->get_filter( ).
  lt_filter_select_options = lo_filter->get_filter_select_options( ).
  lv_filter_str = lo_filter->get_filter_string( ).

**Check if the supplied filter is supported by standard gateway runtime process
  IF  lv_filter_str IS NOT INITIAL AND lt_filter_select_options IS INITIAL.
    me->/iwbep/if_sb_dpc_comm_services~log_message(
      EXPORTING
        iv_msg_type   = 'E'
        iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
        iv_msg_number = 025 ).
    " Raise Exception
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
      EXPORTING
        textid = /iwbep/cx_mgw_tech_exception=>internal_error.
  ENDIF.

**Maps filter table lines to function module parameters
  LOOP AT lt_filter_select_options INTO ls_filter.
    LOOP AT ls_filter-select_options INTO ls_filter_range.
      CASE ls_filter-property.
        WHEN 'PONUMBER'.
          lo_filter->convert_select_option(
            EXPORTING
              is_select_option = ls_filter
            IMPORTING
              et_select_option = lr_filter_ponumber ).

          READ TABLE lr_filter_ponumber INTO ls_filter_ponumber INDEX 1.
          IF sy-subrc = 0.
            lv_filter_ponumber = ls_filter_ponumber-low.
          ENDIF.
        WHEN 'POITEM'.
          lo_filter->convert_select_option(
            EXPORTING
              is_select_option = ls_filter
            IMPORTING
              et_select_option = lr_filter_poitem ).

          READ TABLE lr_filter_poitem INTO ls_filter_poitem INDEX 1.
          IF sy-subrc = 0.
            lv_filter_poitem = ls_filter_poitem-low.
          ENDIF.
        WHEN OTHERS.
          " Log message in the application log
          me->/iwbep/if_sb_dpc_comm_services~log_message(
            EXPORTING
              iv_msg_type   = 'E'
              iv_msg_id     = '/IWBEP/MC_SB_DPC_ADM'
              iv_msg_number = 020
              iv_msg_v1     = ls_filter-property ).
          " Raise Exception
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
            EXPORTING
              textid = /iwbep/cx_mgw_tech_exception=>internal_error.
      ENDCASE.
    ENDLOOP.
  ENDLOOP.

  IF lv_filter_ponumber IS NOT INITIAL AND lv_filter_poitem IS NOT INITIAL.

    CALL METHOD me->get_po
      EXPORTING
        im_ponumber    = lv_filter_ponumber
        im_poitem      = lv_filter_poitem
        im_key_tab     = it_key_tab
        im_entity_name = iv_entity_name
      CHANGING
        ex_data        = et_entityset.

  ELSEIF lv_filter_ponumber IS NOT INITIAL.

    CALL METHOD me->get_po
      EXPORTING
        im_ponumber    = lv_filter_ponumber
        im_key_tab     = it_key_tab
        im_entity_name = iv_entity_name
      CHANGING
        ex_data        = et_entityset.

  ENDIF.

ENDMETHOD.
ENDCLASS.
