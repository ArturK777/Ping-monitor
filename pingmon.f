REQUIRE /STRING lib\include\string.f
REQUIRE CONCAT ~micro\lib\str.f

\ 4 CONSTANT N_ITEMS \ !NEED max number of nodes
255 CONSTANT N_LEN  \ max length of nodelist string
0 VALUE FILEID
CREATE N_STR 0 , \ number of node strings in list
CREATE MAX_LEN 0 , \ max len of node string
CREATE DIMM[] 3 ALLOT 3 , 2 , 1 , \ NODES[]'s colums sizes
\ CREATE tSTR N_LEN ALLOT \ temp string buffer

: ?COMM ( addr -- c ) C@ 92 = ; \ is comment? "\"
: ?BL ( addr -- c ) C@ 32 = ; \ is space? "\"
: TRIM  ( str len -- str len-i ) \ Trim white space from end of string (from toolbelt.f)
    BEGIN  DUP WHILE
        1-  2DUP + C@ IsDelimiter 0=
    UNTIL 1+ THEN ;
: BL-SKIP  ( str len -- str+i len-i ) \ Skip over white space at start of string (from toolbelt.f)  
    BEGIN  DUP WHILE  OVER C@ IsDelimiter
    WHILE  1 /STRING  REPEAT THEN ;
: OPEN_LST ( -- fileid ) \ open list of nodes to ping "nodes.txt"
	SOURCE-NAME \ full name of source .f file
	CUT-PATH \ cut pathname
	S" nodes.txt" CONCAT \ full name of nodes.txt
\	2DUP DUMP CR 
 	R/O OPEN-FILE THROW DUP TO FILEID ;
: SCAN_LST ( fileid -- ) \ measuring nodelist size
    BEGIN
        DUP TIB N_LEN ROT READ-LINE THROW ." --- " .S ." --- " CR \ read line to TempInputBuffer
    WHILE
         TIB SWAP
         BL-SKIP \ skip leadind spaces
         SWAP DUP ?COMM IF \ is comment? "\"
            .S CR 2DROP
         ELSE ( D: fileid len addr ) ." ... " .S >IN ? DUP 100 DUMP CR
            0 BEGIN 
                SWAP ( D: fileid len 0 addr ) 
            WHILE
                
            REPEAT
            SWAP 2DUP TYPE CR .S CR
            MAX_LEN @ MAX MAX_LEN !
            N_STR 1+!
            DROP
         THEN
    REPEAT  DROP
    N_STR ? MAX_LEN ?
;   

CR .( ---) CR 
	OPEN_LST
    SCAN_LST
    CREATE NODES[] N_STR MAX_LEN * ALLOT .S .( *** ) CR \ array of nodes
\	READ_LST
\    READ_DIM
    CLOSE-FILE THROW
\    NODES[] 100 DUMP

CR .( ===) CR .S

\ : DIM_A ( i -- a ) MAX_LEN * NODES[] + ; \ NODES[i] cell addr
\ : READ_DIM ( fileid -- ) \ read nodes.txt to NODES[]
\     N_ITEMS 0 DO DUP
\        I DIM_A N_LEN 2- ROT .S ." *** " READ-LINE .S THROW ." --> " FILEID FILE-POSITION . D. CR 
\        2DROP
\    LOOP
\ ; 
