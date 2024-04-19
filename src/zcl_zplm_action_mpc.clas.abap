class ZCL_ZPLM_ACTION_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.
*"* public components of class ZCL_ZPLM_ACTION_MPC
*"* do not include other source files here!!!

  types:
  begin of TS_ACTIONRESPONSE,
     GUID type C length 32,
     COMPLETE type FLAG,
     NOTE type string,
     ROOTCAUSE type string,
     ROOTCAUSEDD type string,
     ACTIONTYPEDD type string,
  end of TS_ACTIONRESPONSE. .
  types:
TT_ACTIONRESPONSE type standard table of TS_ACTIONRESPONSE. .
  types:
   begin of ts_text_element,
      artifact_name  type c length 40,       " technical name
      artifact_type  type c length 4,
      parent_artifact_name type c length 40, " technical name
      parent_artifact_type type c length 4,
      text_symbol    type textpoolky,
   end of ts_text_element. .
  types:
         tt_text_elements type standard table of ts_text_element with key text_symbol. .
  types:
  begin of TS_ROOTCAUSE,
     ID type C length 2,
     VALUE type string,
  end of TS_ROOTCAUSE. .
  types:
TT_ROOTCAUSE type standard table of TS_ROOTCAUSE. .
  types:
  begin of TS_ACTIONTYPE,
     ID type C length 5,
     VALUE type string,
  end of TS_ACTIONTYPE. .
  types:
TT_ACTIONTYPE type standard table of TS_ACTIONTYPE. .
  types:
  begin of TS_ACTION,
     GUID type C length 32,
     ACTIONID type C length 24,
     DESCRIPTION type C length 40,
     PSTARTDATE type C length 8,
     PENDDATE type C length 8,
     DESCRIPTIONL type string,
     IMMEDIATEDISP type string,
     NOTE type string,
     ROOTCAUSE type string,
     ROOTCAUSEDD type string,
     ACTIONTYPEDD type string,
     QUESTION type C length 24,
     QGUID type C length 32,
     QDESCRIPTION type string,
     QDESCRIPTIONL type string,
     QNOTE type string,
     QDETERMINATION type string,
     AUDIT type C length 24,
     AGUID type C length 32,
     ADESCRIPTION type string,
     AWORKFORCE type string,
     AJOBID type string,
     ADISTRICT type string,
     AUSMAREA type string,
     ATOWN type string,
     AADDRESS type string,
  end of TS_ACTION. .
  types:
TT_ACTION type standard table of TS_ACTION. .
  types:
  begin of TS_PRINTPREVIEW,
     GUID type C length 32,
     DESCRIPTION type string,
     MIMETYPE type string,
  end of TS_PRINTPREVIEW. .
  types:
TT_PRINTPREVIEW type standard table of TS_PRINTPREVIEW. .
  types:
  begin of TS_ATTACHMENTS,
     GUID type C length 32,
     DOCID type C length 46,
     FILENAME type string,
     MIMETYPE type string,
  end of TS_ATTACHMENTS. .
  types:
TT_ATTACHMENTS type standard table of TS_ATTACHMENTS. .
  types:
  begin of TS_ACTIONSUB,
     GUID type C length 32,
     INDX type string,
     CODE type string,
     DETAILS type string,
     LONG_DESC type string,
  end of TS_ACTIONSUB. .
  types:
TT_ACTIONSUB type standard table of TS_ACTIONSUB. .

  constants GC_ACTION type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Action'. "#EC NOTEXT
  constants GC_ACTIONRESPONSE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionResponse'. "#EC NOTEXT
  constants GC_ACTIONSUB type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionSub'. "#EC NOTEXT
  constants GC_ACTIONTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ActionType'. "#EC NOTEXT
  constants GC_ATTACHMENTS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Attachments'. "#EC NOTEXT
  constants GC_PRINTPREVIEW type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'PrintPreview'. "#EC NOTEXT
  constants GC_ROOTCAUSE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'RootCause'. "#EC NOTEXT

  methods LOAD_TEXT_ELEMENTS
  final
    returning
      value(RT_TEXT_ELEMENTS) type TT_TEXT_ELEMENTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
*"* protected components of class ZCL_ZPLM_ACTION_MPC
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ZPLM_ACTION_MPC
*"* do not include other source files here!!!

  constants GC_INCL_NAME type STRING value 'ZCL_ZPLM_ACTION_MPC===========CP'. "#EC NOTEXT

  methods DEFINE_ACTIONRESPONSE
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ROOTCAUSE
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ACTIONTYPE
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ACTION
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_PRINTPREVIEW
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ATTACHMENTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ACTIONSUB
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods DEFINE_ASSOCIATIONS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
ENDCLASS.



CLASS ZCL_ZPLM_ACTION_MPC IMPLEMENTATION.


method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZPLM_ACTION_SRV' ).

define_actionresponse( ).
define_rootcause( ).
define_actiontype( ).
define_action( ).
define_printpreview( ).
define_attachments( ).
define_actionsub( ).
define_associations( ).
endmethod.


method DEFINE_ACTION.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - Action
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'Action' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'GUID' iv_abap_fieldname = 'GUID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 32 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ActionID' iv_abap_fieldname = 'ACTIONID' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 24 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Description' iv_abap_fieldname = 'DESCRIPTION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 40 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PStartDate' iv_abap_fieldname = 'PSTARTDATE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 8 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'PEndDate' iv_abap_fieldname = 'PENDDATE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 8 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DescriptionL' iv_abap_fieldname = 'DESCRIPTIONL' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ImmediateDisp' iv_abap_fieldname = 'IMMEDIATEDISP' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Note' iv_abap_fieldname = 'NOTE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RootCause' iv_abap_fieldname = 'ROOTCAUSE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RootCauseDD' iv_abap_fieldname = 'ROOTCAUSEDD' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ActionTypeDD' iv_abap_fieldname = 'ACTIONTYPEDD' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Question' iv_abap_fieldname = 'QUESTION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 24 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'QGUID' iv_abap_fieldname = 'QGUID' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 32 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'QDescription' iv_abap_fieldname = 'QDESCRIPTION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'QDescriptionL' iv_abap_fieldname = 'QDESCRIPTIONL' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'QNote' iv_abap_fieldname = 'QNOTE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'QDetermination' iv_abap_fieldname = 'QDETERMINATION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Audit' iv_abap_fieldname = 'AUDIT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 24 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AGUID' iv_abap_fieldname = 'AGUID' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 32 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ADescription' iv_abap_fieldname = 'ADESCRIPTION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AWorkforce' iv_abap_fieldname = 'AWORKFORCE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AJobID' iv_abap_fieldname = 'AJOBID' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ADistrict' iv_abap_fieldname = 'ADISTRICT' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AUSMArea' iv_abap_fieldname = 'AUSMAREA' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ATown' iv_abap_fieldname = 'ATOWN' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'AAddress' iv_abap_fieldname = 'AADDRESS' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZPLM_ACTION_MPC=>TS_ACTION' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'ActionSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_true ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
endmethod.


method DEFINE_ACTIONRESPONSE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - ActionResponse
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'ActionResponse' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'GUID' iv_abap_fieldname = 'GUID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 32 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Complete' iv_abap_fieldname = 'COMPLETE' ). "#EC NOTEXT
lo_property->set_label_from_text_element( iv_text_element_symbol = '001' iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
lo_property->set_type_edm_boolean( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Note' iv_abap_fieldname = 'NOTE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RootCause' iv_abap_fieldname = 'ROOTCAUSE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'RootCauseDD' iv_abap_fieldname = 'ROOTCAUSEDD' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'ActionTypeDD' iv_abap_fieldname = 'ACTIONTYPEDD' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZPLM_ACTION_MPC=>TS_ACTIONRESPONSE' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'ActionResponseSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_true ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
endmethod.


method DEFINE_ACTIONSUB.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - ActionSub
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'ActionSub' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'GUID' iv_abap_fieldname = 'GUID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 32 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'INDX' iv_abap_fieldname = 'INDX' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'CODE' iv_abap_fieldname = 'CODE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DETAILS' iv_abap_fieldname = 'DETAILS' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'LONG_DESC' iv_abap_fieldname = 'LONG_DESC' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_true ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZPLM_ACTION_MPC=>TS_ACTIONSUB' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'ActionSubSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
endmethod.


method DEFINE_ACTIONTYPE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - ActionType
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'ActionType' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'ID' iv_abap_fieldname = 'ID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 5 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Value' iv_abap_fieldname = 'VALUE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZPLM_ACTION_MPC=>TS_ACTIONTYPE' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'ActionTypeSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
endmethod.


method DEFINE_ASSOCIATIONS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*




data:
lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                   "#EC NEEDED
lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                   "#EC NEEDED
lo_association    type ref to /iwbep/if_mgw_odata_assoc,                        "#EC NEEDED
lo_ref_constraint type ref to /iwbep/if_mgw_odata_ref_constr,                   "#EC NEEDED
lo_assoc_set      type ref to /iwbep/if_mgw_odata_assoc_set,                    "#EC NEEDED
lo_nav_property   type ref to /iwbep/if_mgw_odata_nav_prop.                     "#EC NEEDED

***********************************************************************************************************************************
*   ASSOCIATIONS
***********************************************************************************************************************************

 lo_association = model->create_association(
                            iv_association_name = 'ActionAttachmentRelation' "#EC NOTEXT
                            iv_left_type        = 'Action' "#EC NOTEXT
                            iv_right_type       = 'Attachments' "#EC NOTEXT
                            iv_right_card       = 'M' "#EC NOTEXT
                            iv_left_card        = '1'  "#EC NOTEXT
                            iv_def_assoc_set    = abap_false ). "#EC NOTEXT
* Referential constraint for association - ActionAttachmentRelation
lo_ref_constraint = lo_association->create_ref_constraint( ).
lo_ref_constraint->add_property( iv_principal_property = 'GUID'   iv_dependent_property = 'GUID' ). "#EC NOTEXT
lo_assoc_set = model->create_association_set( iv_association_set_name  = 'ActionAttachmentRelationSet'                         "#EC NOTEXT
                                              iv_left_entity_set_name  = 'ActionSet'              "#EC NOTEXT
                                              iv_right_entity_set_name = 'AttachmentsSet'             "#EC NOTEXT
                                              iv_association_name      = 'ActionAttachmentRelation' ).                                 "#EC NOTEXT

 lo_association = model->create_association(
                            iv_association_name = 'ActionPrintPreviewRelation' "#EC NOTEXT
                            iv_left_type        = 'Action' "#EC NOTEXT
                            iv_right_type       = 'PrintPreview' "#EC NOTEXT
                            iv_right_card       = 'M' "#EC NOTEXT
                            iv_left_card        = '1'  "#EC NOTEXT
                            iv_def_assoc_set    = abap_false ). "#EC NOTEXT
* Referential constraint for association - ActionPrintPreviewRelation
lo_ref_constraint = lo_association->create_ref_constraint( ).
lo_ref_constraint->add_property( iv_principal_property = 'GUID'   iv_dependent_property = 'GUID' ). "#EC NOTEXT
lo_assoc_set = model->create_association_set( iv_association_set_name  = 'ActionPrintPreviewRelationSet'                         "#EC NOTEXT
                                              iv_left_entity_set_name  = 'ActionSet'              "#EC NOTEXT
                                              iv_right_entity_set_name = 'PrintPreviewSet'             "#EC NOTEXT
                                              iv_association_name      = 'ActionPrintPreviewRelation' ).                                 "#EC NOTEXT

 lo_association = model->create_association(
                            iv_association_name = 'ActionSubRelation' "#EC NOTEXT
                            iv_left_type        = 'Action' "#EC NOTEXT
                            iv_right_type       = 'ActionSub' "#EC NOTEXT
                            iv_right_card       = 'M' "#EC NOTEXT
                            iv_left_card        = '1'  "#EC NOTEXT
                            iv_def_assoc_set    = abap_false ). "#EC NOTEXT
* Referential constraint for association - ActionSubRelation
lo_ref_constraint = lo_association->create_ref_constraint( ).
lo_ref_constraint->add_property( iv_principal_property = 'GUID'   iv_dependent_property = 'GUID' ). "#EC NOTEXT
lo_assoc_set = model->create_association_set( iv_association_set_name  = 'ActionSubRelationSet'                         "#EC NOTEXT
                                              iv_left_entity_set_name  = 'ActionSet'              "#EC NOTEXT
                                              iv_right_entity_set_name = 'ActionSubSet'             "#EC NOTEXT
                                              iv_association_name      = 'ActionSubRelation' ).                                 "#EC NOTEXT


***********************************************************************************************************************************
*   NAVIGATION PROPERTIES
***********************************************************************************************************************************

* Navigation Properties for entity - Action
lo_entity_type = model->get_entity_type( iv_entity_name = 'Action' ). "#EC NOTEXT
lo_nav_property = lo_entity_type->create_navigation_property( iv_property_name  = 'FromRole_ActionAttachmentRelation' "#EC NOTEXT
                                                              iv_abap_fieldname = 'FROMROLE_ACTIONATTACHMENTRELAT' "#EC NOTEXT
                                                              iv_association_name = 'ActionAttachmentRelation' ). "#EC NOTEXT
lo_nav_property = lo_entity_type->create_navigation_property( iv_property_name  = 'FromRole_ActionPrintPreviewRelation' "#EC NOTEXT
                                                              iv_abap_fieldname = 'FROMROLE_ACTIONPRINTPREVIEWREL' "#EC NOTEXT
                                                              iv_association_name = 'ActionPrintPreviewRelation' ). "#EC NOTEXT
lo_nav_property = lo_entity_type->create_navigation_property( iv_property_name  = 'ActionSubSet' "#EC NOTEXT
                                                              iv_abap_fieldname = 'ACTIONSUBSET' "#EC NOTEXT
                                                              iv_association_name = 'ActionSubRelation' ). "#EC NOTEXT
* Navigation Properties for entity - PrintPreview
lo_entity_type = model->get_entity_type( iv_entity_name = 'PrintPreview' ). "#EC NOTEXT
lo_nav_property = lo_entity_type->create_navigation_property( iv_property_name  = 'ToRole_ActionPrintPreviewRelation' "#EC NOTEXT
                                                              iv_abap_fieldname = 'TOROLE_ACTIONPRINTPREVIEWRELAT' "#EC NOTEXT
                                                              iv_association_name = 'ActionPrintPreviewRelation' ). "#EC NOTEXT
* Navigation Properties for entity - Attachments
lo_entity_type = model->get_entity_type( iv_entity_name = 'Attachments' ). "#EC NOTEXT
lo_nav_property = lo_entity_type->create_navigation_property( iv_property_name  = 'ToRole_ActionAttachmentRelation' "#EC NOTEXT
                                                              iv_abap_fieldname = 'TOROLE_ACTIONATTACHMENTRELATIO' "#EC NOTEXT
                                                              iv_association_name = 'ActionAttachmentRelation' ). "#EC NOTEXT
endmethod.


method DEFINE_ATTACHMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - Attachments
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'Attachments' iv_def_entity_set = abap_false ). "#EC NOTEXT
lo_entity_type->set_is_media( 'X' ).  "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'GUID' iv_abap_fieldname = 'GUID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 32 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'DocID' iv_abap_fieldname = 'DOCID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 46 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'FileName' iv_abap_fieldname = 'FILENAME' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'MimeType' iv_abap_fieldname = 'MIMETYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZPLM_ACTION_MPC=>TS_ATTACHMENTS' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'AttachmentsSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
endmethod.


method DEFINE_PRINTPREVIEW.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - PrintPreview
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'PrintPreview' iv_def_entity_set = abap_false ). "#EC NOTEXT
lo_entity_type->set_is_media( 'X' ).  "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'GUID' iv_abap_fieldname = 'GUID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 32 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Description' iv_abap_fieldname = 'DESCRIPTION' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'MimeType' iv_abap_fieldname = 'MIMETYPE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZPLM_ACTION_MPC=>TS_PRINTPREVIEW' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'PrintPreviewSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
endmethod.


method DEFINE_ROOTCAUSE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  data:
        lo_annotation     type ref to /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       type ref to /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - RootCause
***********************************************************************************************************************************

lo_entity_type = model->create_entity_type( iv_entity_type_name = 'RootCause' iv_def_entity_set = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

lo_property = lo_entity_type->create_property( iv_property_name = 'ID' iv_abap_fieldname = 'ID' ). "#EC NOTEXT
lo_property->set_is_key( ).
lo_property->set_type_edm_string( ).
lo_property->set_maxlength( iv_max_length = 2 ). "#EC NOTEXT
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).
lo_property = lo_entity_type->create_property( iv_property_name = 'Value' iv_abap_fieldname = 'VALUE' ). "#EC NOTEXT
lo_property->set_type_edm_string( ).
lo_property->set_creatable( abap_false ).
lo_property->set_updatable( abap_false ).
lo_property->set_sortable( abap_false ).
lo_property->set_nullable( abap_false ).
lo_property->set_filterable( abap_false ).

lo_entity_type->bind_structure( iv_structure_name  = 'ZCL_ZPLM_ACTION_MPC=>TS_ROOTCAUSE' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
lo_entity_set = lo_entity_type->create_entity_set( 'RootCauseSet' ). "#EC NOTEXT

lo_entity_set->set_creatable( abap_false ).
lo_entity_set->set_updatable( abap_false ).
lo_entity_set->set_deletable( abap_false ).

lo_entity_set->set_pageable( abap_false ).
lo_entity_set->set_addressable( abap_false ).
lo_entity_set->set_has_ftxt_search( abap_false ).
lo_entity_set->set_subscribable( abap_false ).
lo_entity_set->set_filter_required( abap_false ).
endmethod.


method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20161109152913'.                  "#EC NOTEXT
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
endmethod.


method LOAD_TEXT_ELEMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


DATA:
     ls_text_element TYPE ts_text_element.                                 "#EC NEEDED


clear ls_text_element.
ls_text_element-artifact_name          = 'Complete'.                 "#EC NOTEXT
ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
ls_text_element-parent_artifact_name   = 'ActionResponse'.                            "#EC NOTEXT
ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
ls_text_element-text_symbol            = '001'.              "#EC NOTEXT
APPEND ls_text_element TO rt_text_elements.
endmethod.
ENDCLASS.
