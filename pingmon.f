REQUIRE /STRING lib\include\string.f
REQUIRE CONCAT ~micro\lib\str.f

255 CONSTANT N_LEN  \ max length of nodelist string
0 VALUE FILEID
0 VALUE N_STR   \ number of node strings in list

: ?COMM ( addr -- flag ) C@ 92 = ; \ is comment? "\"
: !SKIP ( addr len -- flag ) 0= SWAP ?COMM OR INVERT ;  \ is not comment "\" or empty line
: ?BL ( addr -- c ) C@ 32 = ; \ is space? "\"
: TRIM  ( str len -- str len-i ) \ Trim white space from end of string (from toolbelt.f)
    BEGIN  DUP WHILE
        1-  2DUP + C@ IsDelimiter 0=
    UNTIL 1+ THEN ;
: BL-SKIP  ( str len -- str+i len-i ) \ Skip over white space at start of string (from toolbelt.f)  
    BEGIN  DUP WHILE  OVER C@ IsDelimiter
    WHILE  1 /STRING  REPEAT THEN ;
: OPEN_LST ( -- ) \ open list of nodes to ping "nodes.txt"
	SOURCE-NAME CUT-PATH  \ cut pathname from full name of source .f file
	S" nodes.txt" CONCAT  \ full name of nodes.txt
 	R/O OPEN-FILE THROW  ." FileID:" .S TO FILEID CR ;
: READ_LINE  ( -- len flag ) PAD N_LEN FILEID READ-LINE THROW ; \ read 1 line from nodelist
: SCAN#NODES  ( -- u )  0 \ count nodes in nodelist
	BEGIN  READ_LINE ( -- len flag ) ." --- " .S ." --- " CR \ read line to TempInputBuffer
    WHILE  PAD SWAP  BL-SKIP !SKIP  IF  \ is not comment "\" or empty line
		1+  \ nodes counter
\		ParseWord TYPE 
	THEN  
    REPEAT   TO N_STR ; \   PAD N_LEN ERASE ;
: READ_LST
	BEGIN READ_LINE
	WHILE
	REPEAT
;
CR .( ---) CR 
	OPEN_LST .S
	SCAN#NODES ( -- u )
    CREATE NODES[] N_LEN * ALLOT   \ array of nodes
\	0 0 FILEID REPOSITION-FILE THROW  
	READ_LST
    FILEID CLOSE-FILE THROW
\    NODES[] 100 DUMP

CR .( ===) CR .S

\ : DIM_A ( i -- a ) MAX_LEN * NODES[] + ; \ NODES[i] cell addr
\ : READ_DIM ( fileid -- ) \ read nodes.txt to NODES[]
\     N_ITEMS 0 DO DUP
\        I DIM_A N_LEN 2- ROT .S ." *** " READ-LINE .S THROW ." --> " FILEID FILE-POSITION . D. CR 
\        2DROP
\    LOOP
\ ; 
