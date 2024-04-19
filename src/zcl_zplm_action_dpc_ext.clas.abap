class ZCL_ZPLM_ACTION_DPC_EXT definition
  public
  inheriting from ZCL_ZPLM_ACTION_DPC
  create public .

public section.
*"* public components of class ZCL_ZPLM_ACTION_DPC_EXT
*"* do not include other source files here!!!

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.
*"* protected components of class ZCL_ZPLM_ACTION_DPC_EXT
*"* do not include other source files here!!!

  methods ACTIONRESPONSESE_CREATE_ENTITY
    redefinition .
  methods ACTIONSET_GET_ENTITY
    redefinition .
  methods ACTIONSET_GET_ENTITYSET
    redefinition .
  methods ACTIONSUBSET_GET_ENTITYSET
    redefinition .
  methods ACTIONTYPESET_GET_ENTITYSET
    redefinition .
  methods ATTACHMENTSSET_GET_ENTITYSET
    redefinition .
  methods PRINTPREVIEWSET_GET_ENTITYSET
    redefinition .
  methods ROOTCAUSESET_GET_ENTITYSET
    redefinition .
  methods ACTIONSUBSET_CREATE_ENTITY
    redefinition .
private section.
*"* private components of class ZCL_ZPLM_ACTION_DPC_EXT
*"* do not include other source files here!!!

  class ZCL_ZPLM_ACTION_MPC definition load .
  methods GET_AUDIT_INFO
    importing
      !IV_ACTION_GUID type ZAUDIT_NOTIF-ACTION_GUID
    exporting
      !ES_ENTITY type ZCL_ZPLM_ACTION_MPC=>TS_ACTION .
  methods SEND_EMAIL
    importing
      !IV_ACTION_GUID type ZAUDIT_NOTIF-ACTION_GUID .
  methods SPLIT_LONG_STRING
    importing
      !IV_STRING type STRING
      !IV_TYPE type CHAR4
      !IV_GUID type PLMT_AUDIT_OBJECT_GUID_BAPI
    changing
      !CT_LONGTEXT type PLMT_BAPI_LONG_TEXT_TAB .
  methods GOS_ATTACH_XSTRING
    importing
      !IV_NAME type STRING
      !IV_CONTENT type XSTRING
      !IS_LPORB type SIBFLPORB
    returning
      value(RT_MESSAGES) type BAPIRETTAB .
ENDCLASS.



CLASS ZCL_ZPLM_ACTION_DPC_EXT IMPLEMENTATION.


METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

  DATA: lv_guid     TYPE char70,
        lv_filename TYPE string,

        lv_mimetype TYPE string,
        lv_file     TYPE xstring,

        ls_object   TYPE sibflporb.

  CASE iv_entity_name.

    WHEN 'Attachments'.
      SPLIT iv_slug AT '|' INTO lv_guid lv_filename.

      lv_mimetype = is_media_resource-mime_type.
      lv_file = is_media_resource-value.

      ls_object-catid = 'BO'.
      ls_object-typeid = 'BUS20370'.
      ls_object-instid = lv_guid.

      CALL METHOD me->gos_attach_xstring
        EXPORTING
          iv_name    = lv_filename
          iv_content = lv_file
          is_lporb   = ls_object.


  ENDCASE.

ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

  DATA: ls_key          LIKE LINE OF it_key_tab,
        lv_guid         TYPE bapi_20370_d-guid,
        lv_docid        TYPE sofolenti1-doc_id,

        lv_mimetype     TYPE mimetypes-type,
        ls_stream       TYPE ty_s_media_resource,
        ls_header       TYPE ihttpnvp.

  DATA: ls_gos_document   TYPE sofolenti1,
        lt_gos_data       TYPE TABLE OF solix,
        lv_gos_length     TYPE i,
        lv_gos_xstring    TYPE xstring,

        ls_auditaction    TYPE bapi_20370_d,
        lv_projectguid    TYPE cgpl_guid16,
        lr_project        TYPE REF TO cl_cgpl_project,
        lv_pdf_xstring    TYPE xstring.


  CASE iv_entity_name.

    WHEN 'Attachments'.

      READ TABLE it_key_tab WITH KEY name = 'DocID' INTO ls_key.
      IF sy-subrc EQ 0.
        lv_docid = ls_key-value.
      ENDIF.

      IF lv_docid IS NOT INITIAL.
        "Get the document
        CALL FUNCTION 'SO_DOCUMENT_READ_API1'
          EXPORTING
            document_id   = lv_docid
          IMPORTING
            document_data = ls_gos_document
          TABLES
            contents_hex  = lt_gos_data.

        "Convert to Xstring
        lv_gos_length = ls_gos_document-doc_size.
        CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
          EXPORTING
            input_length = lv_gos_length
          IMPORTING
            buffer       = lv_gos_xstring
          TABLES
            binary_tab   = lt_gos_data
          EXCEPTIONS
            failed       = 1
            OTHERS       = 2.

        IF lv_gos_xstring IS NOT INITIAL.
          ls_stream-value = lv_gos_xstring.
          ls_header-name = 'Content-Disposition'.

          "Set Mimetype
          CALL FUNCTION 'SDOK_MIMETYPE_GET'
            EXPORTING
              extension = ls_gos_document-obj_type
            IMPORTING
              mimetype  = lv_mimetype.
          ls_stream-mime_type = lv_mimetype.

          "Build filename
          CONCATENATE 'attachment; filename=' ls_gos_document-obj_descr INTO ls_header-value.
          CONCATENATE ls_header-value ls_gos_document-obj_type INTO ls_header-value SEPARATED BY '.'.

          me->set_header( is_header = ls_header ).
          copy_data_to_ref( EXPORTING is_data = ls_stream
                            CHANGING  cr_data = er_stream ).
        ENDIF.
      ENDIF.



    WHEN 'PrintPreview'.
      READ TABLE it_key_tab WITH KEY name = 'GUID' INTO ls_key.
      IF sy-subrc EQ 0.
        lv_guid = ls_key-value.
      ENDIF.

      IF lv_guid IS NOT INITIAL.
        "Get the Audit Action Object
        CALL FUNCTION 'BAPI_BUS20370_GET_DETAIL'
          EXPORTING
            guid              = lv_guid
          IMPORTING
            auditcorrecaction = ls_auditaction.

        "Get projectGUID
        CALL METHOD cl_plm_audit_convert_services=>conversion_aud_input
          EXPORTING
            iv_input  = ls_auditaction-external_id
          RECEIVING
            rv_output = lv_projectguid.

        "Get Project Object
        CALL METHOD cl_plm_audit_if_services=>get_cgpl_data_by_guid
          EXPORTING
            iv_guid        = lv_projectguid
            iv_change_mode = ' '
          IMPORTING
            er_project     = lr_project.

        "Get the PDF Data
        CALL METHOD cl_plm_audit_services=>collect_data
          EXPORTING
            ir_object             = lr_project
            iv_convert_data_2_pdf = abap_true
            iv_application_type   = 'AUD'
          IMPORTING
            ev_pdf                = lv_pdf_xstring
          EXCEPTIONS
            failed                = 1.

        IF lv_pdf_xstring IS NOT INITIAL.
          ls_stream-value = lv_pdf_xstring.
          ls_header-name = 'Content-Disposition'.

          "Set Mimetype
          lv_mimetype = 'application/pdf'.
          ls_stream-mime_type = lv_mimetype.

          "Build filename
          ls_header-value =  'attachment; filename=AuditDetails.pdf'.

          me->set_header( is_header = ls_header ).
          copy_data_to_ref( EXPORTING is_data = ls_stream
                            CHANGING  cr_data = er_stream ).
        ENDIF.
      ENDIF.
  ENDCASE.

ENDMETHOD.


METHOD actionresponsese_create_entity.

  DATA: lo_message_container  TYPE REF TO /iwbep/if_message_container,
        lv_objnr              TYPE crm_jsto-objnr,
        lv_completestatus     TYPE tj30t-estat,
        lv_msg                TYPE bapi_msg,

        ls_zaudit             TYPE zaudit_notif,
        ls_action             TYPE bapi_20370_d,
        lt_dummy              TYPE TABLE OF bapi_20310_status_m,
        ls_action_change      TYPE bapi_20370_c,
        ls_longtext           TYPE bapi_bus20350_long_text,
        lt_longtext           LIKE TABLE OF ls_longtext,

        lt_return             TYPE TABLE OF bapiret2.

  CONSTANTS:  c_userstatprofile   TYPE tj30t-stsma  VALUE 'UG_AM_01',
              c_userstatcomplete  TYPE tj30t-txt04  VALUE 'COMP',
              c_zrca(4)           TYPE c            VALUE 'ZRCA',
              c_note(4)           TYPE c            VALUE 'NOTE'.


**Read all the input values
  io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

  lo_message_container = mo_context->get_message_container( ).

**GET audit action info
  CALL FUNCTION 'BAPI_BUS20370_GET_DETAIL'
    EXPORTING
      guid              = er_entity-guid
    IMPORTING
      auditcorrecaction = ls_action
    TABLES
      status            = lt_dummy "Do this to get longtext to populate
      longtexts         = lt_longtext.

**Copy Exisitng values
  MOVE-CORRESPONDING ls_action TO ls_action_change.

**Update Received flag on zaudit_notif table
  SELECT SINGLE * FROM zaudit_notif
    INTO ls_zaudit
    WHERE action_guid = er_entity-guid.

  IF ls_zaudit-response = abap_false.
    ls_zaudit-response = abap_true.
    MODIFY zaudit_notif FROM ls_zaudit.
  ENDIF.

**Update start date
  IF ls_action-actualstartdate IS INITIAL.
    MOVE-CORRESPONDING ls_action TO ls_action_change.
    ls_action_change-actualstartdate = sy-datum.
  ENDIF.


**Update audit with values
  ls_action_change-z_rootcause   = er_entity-rootcausedd.
  "ls_action_change-z_action_type = er_entity-actiontypedd.

**Update Long Text

  "ROOT CAUSE
  "Parse the fiori string into 132 length textlines
  CALL METHOD me->split_long_string
    EXPORTING
      iv_guid     = er_entity-guid
      iv_string   = er_entity-rootcause
      iv_type     = c_zrca
    CHANGING
      ct_longtext = lt_longtext.

  ""NOTE
  "Parse the fiori string into 132 length textlines
  CALL METHOD me->split_long_string
    EXPORTING
      iv_guid     = er_entity-guid
      iv_string   = er_entity-note
      iv_type     = c_note
    CHANGING
      ct_longtext = lt_longtext.

**UPDATE The action with all the changes (DD and Long Text)
  CALL FUNCTION 'BAPI_BUS20370_CHANGE'
    EXPORTING
      auditcorrecaction = ls_action_change
    TABLES
      longtexts         = lt_longtext
      return            = lt_return.

  IF lt_return IS NOT INITIAL.
    CALL METHOD lo_message_container->add_messages_from_bapi
      EXPORTING
        it_bapi_messages = lt_return.

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        textid            = /iwbep/cx_mgw_busi_exception=>business_error
        message_container = lo_message_container.
  ENDIF.



**Update status if complete
  IF er_entity-complete = abap_true.
    "Get the status for Work complete
    SELECT SINGLE estat FROM tj30t
      INTO lv_completestatus
      WHERE stsma = c_userstatprofile
        AND txt04 = c_userstatcomplete.

    lv_objnr = er_entity-guid.

    "Updat the Status
    CALL FUNCTION 'CRM_STATUS_CHANGE_EXTERN'
      EXPORTING
        objnr               = lv_objnr
        user_status         = lv_completestatus
      EXCEPTIONS
        object_not_found    = 1
        status_inconsistent = 2
        status_not_allowed  = 3
        OTHERS              = 4.

    IF sy-subrc = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      """""" Delete from notification table """"""
      DELETE FROM zaudit_notif WHERE action_guid = er_entity-guid.

      "Email the Lead Auditor
      CALL METHOD me->send_email
        EXPORTING
          iv_action_guid = er_entity-guid.

    ELSE.
      lv_msg =  'Status Could not be updated, try again.'.
      CALL METHOD lo_message_container->add_message_text_only
        EXPORTING
          iv_msg_type           = 'E'
          iv_msg_text           = lv_msg
          iv_is_leading_message = abap_true.

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_container = lo_message_container.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD actionset_get_entity.

  DATA: ls_key_tab LIKE LINE OF it_key_tab, "(Could use io_tech_request_context->get_converted_keys)
        lv_actionguid TYPE zaudit_notif-action_guid.


  LOOP AT it_key_tab INTO ls_key_tab.
    CASE ls_key_tab-name.
      WHEN 'GUID'.
        lv_actionguid = ls_key_tab-value.
    ENDCASE.
  ENDLOOP.




  CALL METHOD me->get_audit_info
    EXPORTING
      iv_action_guid = lv_actionguid
    IMPORTING
      es_entity      = er_entity.
ENDMETHOD.


METHOD actionset_get_entityset.
  DATA: ls_zaudit       TYPE zaudit_notif,
        ls_entity       LIKE LINE OF et_entityset.

  SELECT * FROM zaudit_notif INTO CORRESPONDING FIELDS OF ls_zaudit WHERE responsible = sy-uname.

    CALL METHOD me->get_audit_info
      EXPORTING
        iv_action_guid = ls_zaudit-action_guid
      IMPORTING
        es_entity      = ls_entity.

    APPEND ls_entity TO et_entityset.
  ENDSELECT.
ENDMETHOD.


METHOD actionsubset_create_entity.

  DATA:  ls_plm_actions     TYPE zplm_actions,
         ls_plm_actions_t   TYPE zplm_actions_t,
         lv_topindx         TYPE zplm_actions-indx.

**Read all the input values
  io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

  IF er_entity-indx IS INITIAL.
    SELECT  indx FROM zplm_actions
      INTO lv_topindx WHERE guid = er_entity-guid ORDER BY indx DESCENDING.
      EXIT.
    ENDSELECT.

    lv_topindx = lv_topindx + 1.

    "ER_ENTITY-GUID
    ls_plm_actions-guid = er_entity-guid.
    ls_plm_actions_t-guid = er_entity-guid.

    ls_plm_actions-indx = lv_topindx.
    ls_plm_actions_t-indx = lv_topindx.

    INSERT INTO zplm_actions VALUES ls_plm_actions.
    INSERT INTO zplm_actions_t VALUES ls_plm_actions_t.
  ELSE.
    MOVE-CORRESPONDING er_entity TO ls_plm_actions.
    MOVE-CORRESPONDING er_entity TO ls_plm_actions_t.

    MODIFY zplm_actions FROM ls_plm_actions.
    MODIFY zplm_actions_t FROM ls_plm_actions_t.
  ENDIF.
ENDMETHOD.


METHOD actionsubset_get_entityset.
  DATA: ls_entityset  LIKE LINE OF et_entityset,
        ls_key_tab    LIKE LINE OF it_key_tab,
        lv_actionguid TYPE zaudit_notif-action_guid,

        lt_plm_actions    TYPE TABLE OF zplm_actions,
        lt_plm_actions_t  TYPE TABLE OF zplm_actions_t,
        ls_plm_actions    LIKE LINE OF lt_plm_actions,
        ls_plm_actions_t  LIKE LINE OF lt_plm_actions_t.

  LOOP AT it_key_tab INTO ls_key_tab.
    CASE ls_key_tab-name.
      WHEN 'GUID'.
        lv_actionguid = ls_key_tab-value.
    ENDCASE.
  ENDLOOP.

  SELECT * FROM zplm_actions INTO CORRESPONDING FIELDS OF TABLE lt_plm_actions
    WHERE guid = lv_actionguid.

  SELECT * FROM zplm_actions_t INTO CORRESPONDING FIELDS OF TABLE lt_plm_actions_t
    WHERE guid = lv_actionguid.

  SORT lt_plm_actions ASCENDING BY indx.

  "Loop through the actions
  LOOP AT lt_plm_actions INTO ls_plm_actions.
    CLEAR ls_entityset.
    ls_entityset-guid     = lv_actionguid.
    ls_entityset-indx     = ls_plm_actions-indx.
    ls_entityset-code     = ls_plm_actions-code.
    ls_entityset-details  = ls_plm_actions-details.

    READ TABLE lt_plm_actions_t INTO ls_plm_actions_t WITH KEY indx = ls_plm_actions-indx.
    IF sy-subrc = 0.
      ls_entityset-long_desc = ls_plm_actions_t-long_desc.
    ENDIF.

    shift ls_entityset-indx LEFT DELETING LEADING '0'.
    APPEND ls_entityset TO et_entityset.
  ENDLOOP.
ENDMETHOD.


METHOD actiontypeset_get_entityset.
  DATA: ls_actiontypes TYPE zplm_action_type,
        lt_actiontypes LIKE TABLE OF ls_actiontypes,
        ls_entityset   LIKE LINE OF et_entityset.


  SELECT *
    FROM zplm_action_type
    INTO TABLE lt_actiontypes.

  LOOP AT lt_actiontypes INTO ls_actiontypes.
    ls_entityset-id    = ls_actiontypes-action_code.
    ls_entityset-value = ls_actiontypes-action_desc.
    APPEND ls_entityset TO et_entityset.
  ENDLOOP.
ENDMETHOD.


METHOD attachmentsset_get_entityset.
  DATA: ls_entityset  LIKE LINE OF et_entityset,
        ls_key_tab    LIKE LINE OF it_key_tab,
        lv_actionguid TYPE zaudit_notif-action_guid,

        lv_gos_id       TYPE so_entryid,
        lt_gos_attach   TYPE TABLE OF srgbtbrel,
        ls_gos_attach   TYPE srgbtbrel,
        ls_gos_document TYPE sofolenti1,
        lv_mimetype     TYPE mimetypes-type.

  LOOP AT it_key_tab INTO ls_key_tab.
    CASE ls_key_tab-name.
      WHEN 'GUID'.
        lv_actionguid = ls_key_tab-value.
    ENDCASE.
  ENDLOOP.

  SELECT * FROM srgbtbrel
          INTO CORRESPONDING FIELDS OF TABLE lt_gos_attach
          WHERE reltype = 'ATTA'
            AND typeid_a = 'BUS20370'
            AND instid_a = lv_actionguid.

  "Add all the attachments to the email
  LOOP AT lt_gos_attach INTO ls_gos_attach.
    CLEAR: lv_mimetype, ls_entityset.
    lv_gos_id = ls_gos_attach-instid_b.
    CALL FUNCTION 'SO_DOCUMENT_READ_API1'
      EXPORTING
        document_id   = lv_gos_id
      IMPORTING
        document_data = ls_gos_document.

    ls_entityset-guid     = lv_actionguid.
    ls_entityset-docid    = ls_gos_document-doc_id.
    CONCATENATE ls_gos_document-obj_descr ls_gos_document-obj_type INTO ls_entityset-filename SEPARATED BY '.'.

    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = ls_gos_document-obj_type
      IMPORTING
        mimetype  = lv_mimetype.
    ls_entityset-mimetype = lv_mimetype.

    APPEND ls_entityset TO et_entityset.
  ENDLOOP.
ENDMETHOD.


METHOD get_audit_info.
  DATA: ls_action       TYPE bapi_20370_d,
        lt_actiondesc   TYPE TABLE OF bapi_bus20310_text,
        ls_actiondesc   TYPE bapi_bus20310_text,
        lt_actionltext  TYPE TABLE OF bapi_bus20350_long_text,
        ls_actionltext  TYPE bapi_bus20350_long_text,
        lt_dummy        TYPE TABLE OF bapi_20310_status_m,

        ls_question     TYPE bapi_20360_d,
        lt_questdesc    TYPE TABLE OF bapi_bus20310_text,
        ls_questdesc    TYPE bapi_bus20310_text,
        lt_questltext   TYPE TABLE OF bapi_bus20350_long_text,
        ls_questltext   TYPE bapi_bus20350_long_text,

        ls_auditkey     TYPE bapi_20350_key,
        ls_audit        TYPE bapi_20350_d,
        lt_auditdesc    TYPE TABLE OF bapi_bus20310_text,
        ls_auditdesc    TYPE bapi_bus20310_text,
        lt_auditobj     TYPE TABLE OF bapi_20350_obj_d,
        ls_auditobj     TYPE bapi_20350_obj_d.

  CONSTANTS:  c_desc TYPE tdid VALUE 'DESC',
              c_note TYPE tdid VALUE 'NOTE',
              "c_nega TYPE tdid VALUE 'NEGA',
              c_disp TYPE tdid VALUE 'ZIDP',
              c_rca  TYPE tdid VALUE 'ZRCA',
              c_detr TYPE tdid VALUE 'FACT',
              c_workforce TYPE plmt_auditobject_text VALUE 'Organization'.

  CLEAR: es_entity.

  "Get audit action details.
  CALL FUNCTION 'BAPI_BUS20370_GET_DETAIL'
    EXPORTING
      guid              = iv_action_guid
    IMPORTING
      auditcorrecaction = ls_action
    TABLES
      status            = lt_dummy "Need this to get longtext populated
      longtexts         = lt_actionltext
      texts             = lt_actiondesc.

  "Get Audit Question
  CALL FUNCTION 'BAPI_BUS20360_GET_DETAIL'
    EXPORTING
      guid             = ls_action-parent_quest_guid
    IMPORTING
      auditquestresult = ls_question
      audit            = ls_auditkey
    TABLES
      texts            = lt_questdesc
      longtexts        = lt_questltext.

  "Get Audit
  CALL FUNCTION 'BAPI_BUS20350_GET_DETAIL'
    EXPORTING
      guid           = ls_auditkey-guid
    IMPORTING
      audit          = ls_audit
    TABLES
      texts          = lt_auditdesc
      auditedobjects = lt_auditobj.


****Action info
  es_entity-guid         = ls_action-guid.
  READ TABLE lt_actiondesc INTO ls_actiondesc INDEX 1. "Get the action description
  IF ls_actiondesc IS NOT INITIAL.
    es_entity-description = ls_actiondesc-description.
  ENDIF.

  es_entity-actionid   = ls_action-external_id.
  es_entity-pstartdate = ls_action-planstartdate.
  es_entity-penddate   = ls_action-final_date.

  LOOP AT lt_actionltext INTO ls_actionltext.
    CASE ls_actionltext-text_id.
      WHEN c_desc.
        IF es_entity-descriptionl IS INITIAL.
          es_entity-descriptionl = ls_actionltext-text_line.
        ELSEIF ls_actionltext-format_col = '*'.
          CONCATENATE es_entity-descriptionl cl_abap_char_utilities=>newline ls_actionltext-text_line INTO es_entity-descriptionl.
        ELSE.
          CONCATENATE es_entity-descriptionl  ls_actionltext-text_line INTO es_entity-descriptionl SEPARATED BY space.
        ENDIF.
      WHEN c_note.
        IF es_entity-note IS INITIAL.
          es_entity-note = ls_actionltext-text_line.
        ELSEIF ls_actionltext-format_col = '*'.
          CONCATENATE es_entity-note cl_abap_char_utilities=>newline ls_actionltext-text_line INTO es_entity-note.
        ELSE.
          CONCATENATE es_entity-note ls_actionltext-text_line INTO es_entity-note SEPARATED BY space.
        ENDIF.
      WHEN c_disp.
        IF es_entity-immediatedisp IS INITIAL.
          es_entity-immediatedisp = ls_actionltext-text_line.
        ELSEIF ls_actionltext-format_col = '*'.
          CONCATENATE es_entity-immediatedisp cl_abap_char_utilities=>newline ls_actionltext-text_line INTO es_entity-immediatedisp.
        ELSE.
          CONCATENATE es_entity-immediatedisp ls_actionltext-text_line INTO es_entity-immediatedisp SEPARATED BY space.
        ENDIF.
      WHEN c_rca.
        IF es_entity-rootcause IS INITIAL.
          es_entity-rootcause = ls_actionltext-text_line.
        ELSEIF ls_actionltext-format_col = '*'.
          CONCATENATE es_entity-rootcause cl_abap_char_utilities=>newline ls_actionltext-text_line INTO es_entity-rootcause.
        ELSE.
          CONCATENATE es_entity-rootcause ls_actionltext-text_line INTO es_entity-rootcause SEPARATED BY space.
        ENDIF.
    ENDCASE.
  ENDLOOP.

  REPLACE ALL OCCURRENCES OF '<(>' IN es_entity-descriptionl WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN es_entity-descriptionl WITH ''.
  REPLACE ALL OCCURRENCES OF '<(>' IN es_entity-note WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN es_entity-note WITH ''.
  REPLACE ALL OCCURRENCES OF '<(>' IN es_entity-immediatedisp WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN es_entity-immediatedisp WITH ''.
  REPLACE ALL OCCURRENCES OF '<(>' IN es_entity-rootcause WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN es_entity-rootcause WITH ''.

  es_entity-rootcausedd   = ls_action-z_rootcause.
  "es_entity-actiontypedd  = ls_action-z_action_type.


****Question Info
  es_entity-question      = ls_question-external_id.
  es_entity-qguid         = ls_question-guid.
  READ TABLE lt_questdesc INTO ls_questdesc INDEX 1. "Get the question description
  IF ls_questdesc IS NOT INITIAL.
    es_entity-qdescription = ls_questdesc-description.
  ENDIF.

  LOOP AT lt_questltext INTO ls_questltext.
    CASE ls_questltext-text_id.
      WHEN c_desc.
        IF es_entity-qdescriptionl IS INITIAL.
          es_entity-qdescriptionl = ls_questltext-text_line.
        ELSEIF ls_questltext-format_col = '*'.
          CONCATENATE es_entity-qdescriptionl cl_abap_char_utilities=>newline ls_questltext-text_line INTO es_entity-qdescriptionl.
        ELSE.
          CONCATENATE es_entity-qdescriptionl ls_questltext-text_line INTO es_entity-qdescriptionl SEPARATED BY space.
        ENDIF.
      WHEN c_note.
        IF es_entity-qnote IS INITIAL.
          es_entity-qnote = ls_questltext-text_line.
        ELSEIF ls_questltext-format_col = '*'.
          CONCATENATE es_entity-qnote cl_abap_char_utilities=>newline ls_questltext-text_line INTO es_entity-qnote.
        ELSE.
          CONCATENATE es_entity-qnote ls_questltext-text_line INTO es_entity-qnote SEPARATED BY space.
        ENDIF.
      WHEN c_detr.
        IF es_entity-qdetermination IS INITIAL.
          es_entity-qdetermination = ls_questltext-text_line.
        ELSEIF ls_questltext-format_col = '*'.
          CONCATENATE es_entity-qdetermination cl_abap_char_utilities=>newline ls_questltext-text_line INTO es_entity-qdetermination.
        ELSE.
          CONCATENATE es_entity-qdetermination ls_questltext-text_line INTO es_entity-qdetermination SEPARATED BY space.
        ENDIF.
    ENDCASE.
  ENDLOOP.

  REPLACE ALL OCCURRENCES OF '<(>' IN es_entity-qdescriptionl WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN es_entity-qdescriptionl WITH ''.
  REPLACE ALL OCCURRENCES OF '<(>' IN es_entity-qnote WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN es_entity-qnote WITH ''.
  REPLACE ALL OCCURRENCES OF '<(>' IN es_entity-qdetermination  WITH ''.
  REPLACE ALL OCCURRENCES OF '<)>' IN es_entity-qdetermination WITH ''.

****Audit Info
  es_entity-audit         = ls_audit-external_id.
  es_entity-aguid         = ls_audit-guid.
  READ TABLE lt_auditdesc INTO ls_auditdesc INDEX 1. "Get the audit description
  IF ls_auditdesc IS NOT INITIAL.
    es_entity-adescription = ls_auditdesc-description.
  ENDIF.

  LOOP AT lt_auditobj INTO ls_auditobj.
    CASE ls_auditobj-auditobject_text.
      WHEN c_workforce.
        es_entity-aworkforce = ls_auditobj-value_text.
    ENDCASE.
  ENDLOOP.
  es_entity-ajobid        = ls_audit-z_jobid.
  es_entity-adistrict     = ls_audit-z_district.
  es_entity-ausmarea      = ls_audit-z_division.
  es_entity-atown         = ls_audit-z_town.
  es_entity-aaddress      = ls_audit-z_adress.

ENDMETHOD.


METHOD gos_attach_xstring.

  DATA: ls_folder_id      TYPE sofdk,
        lv_size           TYPE i,
        lt_ls_doc_change  TYPE STANDARD TABLE OF sodocchgi1,
        ls_doc_change     LIKE LINE OF lt_ls_doc_change,

        lv_file_ext   TYPE string,
        lv_objname    TYPE string,

        lv_offset     TYPE i,
        lv_offset_old TYPE i,
        lv_temp_len   TYPE i,

        lt_xdata      TYPE solix_tab,
        ls_xdata      TYPE solix,

        ls_object_hd_change TYPE sood1,

        lt_obj_header TYPE STANDARD TABLE OF solisti1,
        ls_header     TYPE solisti1,
        lt_data       TYPE soli_tab,
        ls_data       TYPE soli,
        ls_object_id  TYPE soodk,

        ls_message    TYPE bapiret2,

        ls_object_id_fol TYPE so_obj_id.

  CONSTANTS:
          c_hex_null  TYPE x LENGTH 1       VALUE '20',
          c_retype    TYPE breltyp-reltype  VALUE 'ATTA',
          c_obj_type  TYPE so_obj_tp        VALUE 'EXT'.


  CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
    EXPORTING
      region    = 'B'
    IMPORTING
      folder_id = ls_folder_id.


  lv_size = xstrlen( iv_content ).

  DATA: lv_extoffset TYPE i.
  FIND ALL OCCURRENCES OF '.' IN iv_name MATCH OFFSET lv_extoffset.
  lv_objname = iv_name+0(lv_extoffset).
  ADD 1 TO lv_extoffset.
  lv_file_ext = iv_name+lv_extoffset.

  ls_doc_change-obj_name = lv_objname.
  ls_doc_change-obj_descr = lv_objname.
  ls_doc_change-obj_langu = sy-langu.
  ls_doc_change-sensitivty = 'F'.
  ls_doc_change-doc_size = lv_size.

  "Set offset
  lv_offset = 0.
  WHILE lv_offset <= lv_size.
    lv_offset_old = lv_offset.
    lv_offset = lv_offset + 255.
    IF lv_offset > lv_size.
      lv_temp_len = xstrlen( iv_content+lv_offset_old ).
      CLEAR ls_xdata-line WITH c_hex_null IN BYTE MODE.
      ls_xdata-line = iv_content+lv_offset_old(lv_temp_len).
    ELSE.
      ls_xdata-line = iv_content+lv_offset_old(255).
    ENDIF.
    APPEND ls_xdata TO lt_xdata.
  ENDWHILE.

  ls_object_hd_change-objnam = ls_doc_change-obj_name.
  ls_object_hd_change-objdes = ls_doc_change-obj_descr.
  ls_object_hd_change-objsns = ls_doc_change-sensitivty.
  ls_object_hd_change-objla  = ls_doc_change-obj_langu.
  ls_object_hd_change-objlen = ls_doc_change-doc_size.
  ls_object_hd_change-file_ext = lv_file_ext.


  CONCATENATE '&SO_FILENAME=' iv_name INTO ls_header.
  APPEND ls_header TO lt_obj_header.
  CLEAR ls_header.
  ls_header = '&SO_FORMAT=BIN'.
  APPEND ls_header TO lt_obj_header.
*   change hex data to text data
  CALL FUNCTION 'SO_SOLIXTAB_TO_SOLITAB'
    EXPORTING
      ip_solixtab = lt_xdata
    IMPORTING
      ep_solitab  = lt_data.


* save object
  CALL FUNCTION 'SO_OBJECT_INSERT'
    EXPORTING
      folder_id                  = ls_folder_id
      object_hd_change           = ls_object_hd_change
      object_type                = c_obj_type
    IMPORTING
      object_id                  = ls_object_id
    TABLES
      objcont                    = lt_data
      objhead                    = lt_obj_header
    EXCEPTIONS
      component_not_available    = 01
      folder_not_exist           = 06
      folder_no_authorization    = 05
      object_type_not_exist      = 17
      operation_no_authorization = 21
      parameter_error            = 23
      OTHERS                     = 1000.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_message-message.
    ls_message-type = sy-msgty.
    ls_message-id = sy-msgid.
    ls_message-number = sy-msgno.
    ls_message-message_v1 = sy-msgv1.
    ls_message-message_v2 = sy-msgv2.
    ls_message-message_v3 = sy-msgv3.
    ls_message-message_v4 = sy-msgv4.
    APPEND ls_message TO rt_messages.
    RETURN.
  ENDIF.

* create relation
  DATA ls_obj_rolea TYPE borident.
  DATA ls_obj_roleb TYPE borident.
  ls_obj_rolea-objkey = is_lporb-instid.
  ls_obj_rolea-objtype = is_lporb-typeid.
  ls_obj_rolea-logsys = is_lporb-catid.
  ls_object_id_fol  = ls_folder_id.
  ls_object_id = ls_object_id.
  CONCATENATE ls_object_id_fol ls_object_id INTO ls_obj_roleb-objkey RESPECTING BLANKS.
  ls_obj_roleb-objtype = 'MESSAGE'.
  CLEAR ls_obj_roleb-logsys.
  CALL FUNCTION 'BINARY_RELATION_CREATE'
    EXPORTING
      obj_rolea    = ls_obj_rolea
      obj_roleb    = ls_obj_roleb
      relationtype = c_retype
    EXCEPTIONS
      OTHERS       = 1.
  IF sy-subrc = 0.
    COMMIT WORK AND WAIT.
  ELSE.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_message-message.
    ls_message-type = sy-msgty.
    ls_message-id = sy-msgid.
    ls_message-number = sy-msgno.
    ls_message-message_v1 = sy-msgv1.
    ls_message-message_v2 = sy-msgv2.
    ls_message-message_v3 = sy-msgv3.
    ls_message-message_v4 = sy-msgv4.
    APPEND ls_message TO rt_messages.
    RETURN.
  ENDIF.

ENDMETHOD.


METHOD printpreviewset_get_entityset.

  DATA: ls_entityset  LIKE LINE OF et_entityset,
        ls_key_tab    LIKE LINE OF it_key_tab,
        lv_actionguid TYPE zaudit_notif-action_guid.

  LOOP AT it_key_tab INTO ls_key_tab.
    CASE ls_key_tab-name.
      WHEN 'GUID'.
        lv_actionguid = ls_key_tab-value.
    ENDCASE.
  ENDLOOP.

  ls_entityset-guid = lv_actionguid.
  ls_entityset-description = 'PDF with Additional Details'.
  ls_entityset-mimetype = 'application/pdf'.

  APPEND ls_entityset TO et_entityset.

ENDMETHOD.


METHOD rootcauseset_get_entityset.
  DATA: ls_rootcause TYPE dd07t,
        lt_rootcause LIKE TABLE OF ls_rootcause,
        ls_entityset LIKE LINE OF et_entityset.


  SELECT *
    FROM dd07t
    INTO TABLE lt_rootcause
    WHERE domname EQ 'Z_ROOTCAUSE'
      AND ddlanguage EQ 'E'.

  LOOP AT lt_rootcause INTO ls_rootcause.
    ls_entityset-id    = ls_rootcause-domvalue_l.
    ls_entityset-value = ls_rootcause-ddtext.
    APPEND ls_entityset TO et_entityset.
  ENDLOOP.
ENDMETHOD.


METHOD send_email.
  DATA: ls_action         TYPE bapi_20370_d,
        ls_question       TYPE bapi_20360_d,
        ls_audit          TYPE bapi_20350_d,
        ls_audit_key      TYPE bapi_20350_key,
        ls_bpemail        TYPE bapiadsmtp,
        lt_bpemail        LIKE TABLE OF ls_bpemail,

        lv_username       TYPE bapibname-bapibname,
        ls_smtp           TYPE bapiadsmtp,
        lt_smtp           LIKE TABLE OF ls_smtp,
        lt_return         TYPE TABLE OF bapiret2,
        lo_message_container  TYPE REF TO /iwbep/if_message_container,
        lv_msg                TYPE bapi_msg,

        gv_sent_to_all    TYPE os_boolean,
        gv_email          TYPE adr6-smtp_addr,
        gv_html           TYPE bcsy_text,
        gr_send_request   TYPE REF TO cl_bcs,
        gr_bcs_exception  TYPE REF TO cx_bcs,
        gr_recipient      TYPE REF TO if_recipient_bcs,
        gr_sender         TYPE REF TO cl_sapuser_bcs,
        gr_document       TYPE REF TO cl_document_bcs.



  CONSTANTS:  c_leadauditor     TYPE c LENGTH 2 VALUE 'LA',
              c_subject         TYPE so_obj_des VALUE 'Audit Management Notification - Complete',
              c_html_header     TYPE string VALUE '<h1 style="color: #005bbb;">Quality Assurance Action Request</h1>'.

  lo_message_container = mo_context->get_message_container( ).

  "Get audit action details.
  CALL FUNCTION 'BAPI_BUS20370_GET_DETAIL'
    EXPORTING
      guid              = iv_action_guid
    IMPORTING
      auditcorrecaction = ls_action.

  "Get Audit Question
  CALL FUNCTION 'BAPI_BUS20360_GET_DETAIL'
    EXPORTING
      guid             = ls_action-parent_quest_guid
    IMPORTING
      auditquestresult = ls_question
      audit            = ls_audit_key.

  "Get Audit
  CALL FUNCTION 'BAPI_BUS20350_GET_DETAIL'
    EXPORTING
      guid  = ls_audit_key-guid
    IMPORTING
      audit = ls_audit.

  "Create Email class
  gr_send_request = cl_bcs=>create_persistent( ).

  "FROM
  gr_sender = cl_sapuser_bcs=>create( sy-uname ).
  CALL METHOD gr_send_request->set_sender
    EXPORTING
      i_sender = gr_sender.

  "TO: Lead Auditor
  lv_username = ls_action-z_leadauditor.
  CALL FUNCTION 'BAPI_USER_GET_DETAIL'
    EXPORTING
      username      = lv_username
      cache_results = 'X'
    TABLES
      return        = lt_return
      addsmtp       = lt_smtp.


  IF lt_return IS INITIAL.
    LOOP AT lt_smtp INTO ls_smtp.
      gv_email = ls_smtp-e_mail.
      gr_recipient = cl_cam_address_bcs=>create_internet_address( gv_email ).
      CALL METHOD gr_send_request->add_recipient
        EXPORTING
          i_recipient = gr_recipient.
    ENDLOOP.
  ENDIF.

  "Email Body
  CLEAR gv_html.
  APPEND c_html_header TO gv_html.
  APPEND '<p>A non-conformance issue has been completed.' TO gv_html.
  APPEND '</p><p><b>Audit:</b>&nbsp' TO gv_html.
  APPEND ls_audit-external_id TO gv_html.
  APPEND '</p><p><b>Question:</b>&nbsp' TO gv_html.
  APPEND ls_question-external_id TO gv_html.
  APPEND '</p><p><b>Action:</b>&nbsp' TO gv_html.
  APPEND ls_action-external_id TO gv_html.
  APPEND '</p>' TO gv_html.

  gr_document = cl_document_bcs=>create_document(
                  i_type        = 'HTM'
                  i_text        = gv_html
                  i_subject     = c_subject ).
  "Add document to send request
  CALL METHOD gr_send_request->set_document( gr_document ).


  "Send email
  TRY.
      gr_send_request->set_send_immediately( abap_true ).
      CALL METHOD gr_send_request->send(
        RECEIVING
          result = gv_sent_to_all ).
    CATCH cx_send_req_bcs.
      "No receipts could occur here... lets catch it, who cares if email is sent... users will notify us and they can fix their email addy then
  ENDTRY.

  IF gv_sent_to_all = abap_false.
    lv_msg =  'Email could not be sent to lead auditor'.
    CALL METHOD lo_message_container->add_message_text_only
      EXPORTING
        iv_msg_type           = 'E'
        iv_msg_text           = lv_msg
        iv_is_leading_message = abap_true.
*    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*      EXPORTING
*        textid            = /iwbep/cx_mgw_busi_exception=>business_error
*        message_container = lo_message_container.
  ENDIF.
ENDMETHOD.


METHOD split_long_string.
  DATA: ls_longtext LIKE LINE OF ct_longtext,
        lv_length   TYPE i,



        ls_text     TYPE string,
        lt_text     LIKE TABLE OF ls_text,

        ls_parts    TYPE swastrtab,
        lt_parts    LIKE TABLE OF ls_parts.

  "Clean out the existing entries
  DELETE ct_longtext WHERE text_id = iv_type.

  "Take the string and split at new lines.
  SPLIT iv_string AT cl_abap_char_utilities=>newline INTO TABLE lt_text.

  "Take lines longer than 132 and split them.
  CLEAR ls_longtext.
  ls_longtext-ref_guid  = iv_guid.
  ls_longtext-text_id   = iv_type.
  ls_longtext-langu     = 'EN'.
  ls_longtext-langu_iso = 'EN'.
  LOOP AT lt_text INTO ls_text.
    lv_length = strlen( ls_text ).

    IF lv_length > 132.
      CALL FUNCTION 'SWA_STRING_SPLIT'
        EXPORTING
          input_string         = ls_text
          max_component_length = 132
        TABLES
          string_components    = lt_parts.

      LOOP AT lt_parts INTO ls_parts.
        IF sy-tabix = 1.
          ls_longtext-format_col = '*'.
        ELSE.
          ls_longtext-format_col = ''.
        ENDIF.
        ls_longtext-text_line = ls_parts-str.
        APPEND ls_longtext TO ct_longtext.
      ENDLOOP.
    ELSE.
      ls_longtext-format_col = '*'.
      ls_longtext-text_line = ls_text.
      APPEND ls_longtext TO ct_longtext.
    ENDIF.


  ENDLOOP.
ENDMETHOD.
ENDCLASS.
