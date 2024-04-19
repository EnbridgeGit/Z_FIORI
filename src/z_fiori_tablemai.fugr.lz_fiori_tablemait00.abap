*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSRA010_WFTASK..................................*
DATA:  BEGIN OF STATUS_ZSRA010_WFTASK                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSRA010_WFTASK                .
CONTROLS: TCTRL_ZSRA010_WFTASK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSRA010_WFTASK                .
TABLES: ZSRA010_WFTASK                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
