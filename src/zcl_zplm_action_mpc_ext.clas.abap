class ZCL_ZPLM_ACTION_MPC_EXT definition
  public
  inheriting from ZCL_ZPLM_ACTION_MPC
  create public .

public section.
*"* public components of class ZCL_ZPLM_ACTION_MPC_EXT
*"* do not include other source files here!!!

  methods DEFINE
    redefinition .
protected section.
*"* protected components of class ZCL_ZPLM_ACTION_MPC_EXT
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_ZPLM_ACTION_MPC_EXT
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ZPLM_ACTION_MPC_EXT IMPLEMENTATION.


method DEFINE.

  DATA: lo_entity_type  TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
        lo_property     TYPE REF TO /iwbep/if_mgw_odata_property.


  CALL METHOD super->define.

  lo_entity_type = model->get_entity_type( 'PrintPreview' ).
  lo_entity_type->set_is_media( ).
  lo_property = lo_entity_type->get_property( 'MimeType' ).
  lo_property->set_as_content_type( ).

  lo_entity_type = model->get_entity_type( 'Attachments' ).
  lo_entity_type->set_is_media( ).
  lo_property = lo_entity_type->get_property( 'MimeType' ).
  lo_property->set_as_content_type( ).
endmethod.
ENDCLASS.
