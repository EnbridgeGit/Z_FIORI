class ZCL_HCM_B_TSH_FIELDRANKINGS definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_HCM_B_TSH_FIELDRANKINGS
*"* do not include other source files here!!!

  interfaces IF_BADI_INTERFACE .
  interfaces IF_HCM_TSH_FIELDRANKINGS .
protected section.
*"* protected components of class ZCL_HCM_B_TSH_FIELDRANKINGS
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_HCM_B_TSH_FIELDRANKINGS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_HCM_B_TSH_FIELDRANKINGS IMPLEMENTATION.


METHOD if_hcm_tsh_fieldrankings~assign_fieldrankings.
  DATA: rank_field LIKE LINE OF field_rankings.

  rank_field-field_name = 'AWART'.
  rank_field-rank = 1.
  APPEND rank_field TO field_rankings.

  rank_field-field_name = 'VERSL'.
  rank_field-rank = 2.
  APPEND rank_field TO field_rankings.

  rank_field-field_name = 'LGART'.
  rank_field-rank = 3.
  APPEND rank_field TO field_rankings.
ENDMETHOD.
ENDCLASS.
