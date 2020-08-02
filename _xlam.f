: SCAN_LST ( fileid -- ) \ measuring nodelist size
    BEGIN
        DUP TIB N_LEN ROT READ-LINE THROW ." --- " .S ." --- " CR \ read line to TempInputBuffer
    WHILE
         TIB SWAP
         BL-SKIP \ skip leadind spaces
         SWAP DUP ?COMM IF \ is comment? "\"
            .S CR 2DROP
         ELSE ( D: fileid len addr ) ." ... " .S >IN ? DUP 100 DUMP CR
            SWAP 2DUP TYPE CR .S CR
            MAX_LEN @ MAX MAX_LEN !
            N_STR 1+!
            DROP
         THEN
    REPEAT  DROP
    N_STR ? MAX_LEN ?
;   